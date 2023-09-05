package com.grommitz;

import jakarta.ws.rs.ApplicationPath;
import org.glassfish.jersey.server.ResourceConfig;
import org.glassfish.jersey.server.ServerProperties;

@ApplicationPath("/")
public class RestApp extends ResourceConfig {

	public RestApp() {
		super();
		packages(true, "com.grommitz");
		property(ServerProperties.TRACING, "ON_DEMAND");
		property(ServerProperties.TRACING_THRESHOLD, "VERBOSE");
		property(ServerProperties.BV_SEND_ERROR_IN_RESPONSE, true);
	}
}
