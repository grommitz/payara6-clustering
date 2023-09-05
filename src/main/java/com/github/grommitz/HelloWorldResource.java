package com.github.grommitz;

import jakarta.ws.rs.GET;
import jakarta.ws.rs.Path;
import jakarta.ws.rs.core.Response;

@Path("/hello")
public class HelloWorldResource {

	@GET
	public Response get() {
		return Response.ok("hello world").build();

	}
}
