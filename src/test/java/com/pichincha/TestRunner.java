package com.pichincha;

import static org.junit.jupiter.api.Assertions.*;

import com.intuit.karate.Runner;
import org.junit.jupiter.api.Test;

class TestRunner {

    @Test
    void testMarvelCharactersApi() {
        final var results = Runner.path("src/test/java/com/pichincha/features")
                .outputCucumberJson(true)
                .parallel(5);
        assertEquals(0, results.getFailCount(), results.getErrorMessages());
    }
}
