package it.myapp;

import io.quarkus.test.junit.QuarkusTest;
import org.junit.jupiter.api.Test;

import static io.restassured.RestAssured.given;
import static org.hamcrest.CoreMatchers.containsString;

@QuarkusTest
class HelloResourceTest {

    @Test
    void helloEndpointReturns200WithGreeting() {
        given()
            .when().get("/hello")
            .then()
              .statusCode(200)
              .body(containsString("Hello from myapp"));
    }

    @Test
    void healthEndpointIsExposed() {
        given()
            .when().get("/q/health/ready")
            .then()
              .statusCode(200);
    }
}
