package com.github.grommitz.health;

import com.hazelcast.core.HazelcastInstance;
import fish.payara.micro.PayaraMicro;
import fish.payara.micro.PayaraMicroRuntime;
import fish.payara.micro.data.InstanceDescriptor;
import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import org.eclipse.microprofile.health.HealthCheck;
import org.eclipse.microprofile.health.HealthCheckResponse;
import org.eclipse.microprofile.health.Readiness;

import java.util.Collection;
import java.util.logging.Logger;

@Readiness
@ApplicationScoped
public class ClusterSizeHealthCheck implements HealthCheck {

	private final static Logger logger = Logger.getLogger(ClusterSizeHealthCheck.class.getName());

	@Inject
	HazelcastInstance hazelcastInstance;

	@Override
	public HealthCheckResponse call() {

		PayaraMicroRuntime runtime = PayaraMicro.getInstance().getRuntime();
		Collection<InstanceDescriptor> instances = runtime.getClusteredPayaras();

		logger.info("HZ config = " + hazelcastInstance.getConfig());
		logger.info("hazelcastInstance: " + hazelcastInstance.getName()
						+ ", cluster contains " + instances.size() + " instances");
		instances.forEach(i -> logger.info(i.toJsonString(false)));

		return HealthCheckResponse.named("cluster-size")
				.status(true)
				.withData("size", instances.size())
				.build();
	}

}