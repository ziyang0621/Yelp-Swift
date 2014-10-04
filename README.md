
# RottenTomatoes Box Office Demo

This is an iOS Swift demo application for displaying the Yelp search and filter using the [Yelp API](http://www.yelp.com/developers/documentation/v2/search_api). This application uses [CodePath's Swift Yelp client](https://github.com/thecodepath/ios_yelp_swift) to to make unauthenticated requests to their search API.

Time spent: 10 hours spent in total

Completed user stories:

 * [x] Required: Table rows should be dynamic height according to the content height
 * [x] Required: Custom cells should have the proper Auto Layout constraints
 * [x] Required: Search bar should be in the navigation bar (doesn't have to expand to show location like the real Yelp app does).
 * [x] Required: The filters you should actually have are: category, sort (best match, distance, highest rated), radius (meters), deals (on/off).
 * [x] Required: The filters table should be organized into sections as in the mock.
 * [x] Required: You can use the default UISwitch for on/off states.
 * [x] Required: Radius filter should expand as in the real Yelp app
 * [x] Required: Categories should show a subset of the full list with a "See All" row to expand.
 * [x] Required: Clicking on the "Search" button should dismiss the filters page and trigger the search w/ the new filter settings.

  

Stories not implemented:
 * Optional: infinite scroll for restaurant results
 * Optional: Implement map view of restaurant results
 * Optional: implement a custom switch
 * Optional: Implement the restaurant detail page

Walkthrough of most of the  user stories (Network error not shown):

![Video Walkthrough](yelp.gif)

GIF created with [LiceCap](http://www.cockos.com/licecap/).
