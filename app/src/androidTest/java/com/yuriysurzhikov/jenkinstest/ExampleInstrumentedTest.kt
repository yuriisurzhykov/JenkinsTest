package com.yuriysurzhikov.jenkinstest

import androidx.test.espresso.Espresso.onView
import androidx.test.espresso.action.ViewActions.*
import androidx.test.espresso.assertion.ViewAssertions.matches
import androidx.test.espresso.matcher.ViewMatchers.*
import androidx.test.ext.junit.rules.ActivityScenarioRule
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import org.hamcrest.Matchers.allOf
import org.junit.Rule

import org.junit.Test
import org.junit.runner.RunWith

@RunWith(AndroidJUnit4::class)
class ExampleInstrumentedTest {

    @get:Rule
    val scenarioRule = ActivityScenarioRule(MainActivity::class.java)

    @Test
    fun useAppContext() {
        InstrumentationRegistry.getInstrumentation().waitForIdleSync()
        onView(withId(R.id.edit_text))
            .perform(typeText("123124wvdsvas"), closeSoftKeyboard())
            .check(matches(allOf(isDisplayed(), isFocused())))
        onView(withId(R.id.button))
            .check(matches(allOf(isDisplayed(), isEnabled(), isClickable())))
            .perform(click())
    }
}