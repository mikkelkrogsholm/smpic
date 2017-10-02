## smpic_save ----

#' Save a social media sized ggplot
#'
#' @param p the ggplot you want to preview.
#' @param filename filename for your plot.
#' @param sm the social media picture type you want it sized to.
#' @param text_factor a factor for the text in the plot. Change it if the text
#'     looks to small.
#'
#' @export
#'
#' @examples
#' library(dplyr)
#' library(ggplot2)
#' library(smpic)
#'
#' p <- ggplot(iris) +
#'      geom_point(aes(Petal.Length, Petal.Width, color = Species), show.legend = FALSE) +
#'        geom_label(data = summarise_if(group_by(iris, Species), is.numeric, mean),
#'                   aes(Petal.Length, Petal.Width, label = Species, color = Species),
#'                   show.legend = FALSE) +
#'        labs(x = "Petal Length", y = "Petal Width",
#'             title = "Look mom, a flower plot!",
#'             subtitle = "Yet another iris data set visualization.",
#'             caption = "Source: iris") +
#'        theme_minimal()
#'
#'   smpic_view(p, sm = "facebook_shared_images", text_factor = 2.2)
#'
#'   smpic_save(p, filename = "my_new_social_media_plot.png",
#'              sm = "facebook_shared_images", text_factor = 2.2)

smpic_save <- function(p, filename = NULL,
                       sm = c("facebook_shared_images", "facebook_profile_image",
                              "facebook_cover_photo", "facebook_shared_link",
                              "facebook_highlighted_image", "facebook_event_image",
                              "linkedin_profile_image", "linkedin_standard_logo",
                              "linkedin_hero_image", "linkedin_business_banner_image",
                              "linkedin_square_logo", "youtube_channel_cover_photo",
                              "youtube_video_uploads", "instagram_profile_image",
                              "instagram_photo_thumbnails", "instagram_photo_size",
                              "twitter_header_photo", "twitter_profile_image",
                              "twitter_in-stream_photo", "pinterest_profile_image",
                              "pinterest_board_display", "pinterest_board_display_thumbnails",
                              "pinterest_pin_sizes", "tumblr_profile_image",
                              "tumblr_image_posts", "g+_profile_image", "g+_cover_image",
                              "g+_shared_image", "g+_shared_video", "g+_shared_image_square",
                              "ello_banner_image", "ello_profile_image"),
                       text_factor = 1) {

  # set generic filename
  if(is.null(filename)){
    filename = paste0(format( Sys.time(), format = '%Y%m%d-%H%M%S'), '-Rplot.png')
  }

  # Set dimensions to fit with social media
  sm <- sm[1]
  my_dims <- dplyr::filter(smpic::smpic_dim, id == sm)

  # Make height and width calculations
  dpi <- text_factor * 100
  width.calc <- my_dims$width / dpi
  height.calc <- my_dims$height / dpi

  # Save the plot to file
  ggplot2::ggsave(filename = filename,
                  dpi = dpi,
                  width = width.calc,
                  height = height.calc,
                  units = 'in',
                  plot = p)
}

## smpic_view ----

#' Preview a social media sized ggplot
#'
#' @param p the ggplot you want to preview.
#' @param sm the social media picture type you want it sized to.
#' @param text_factor a factor for the text in the plot. Change it if the text
#'     looks to small.
#'
#' @return a plot
#' @export
#'
#' @examples
#' library(dplyr)
#' library(ggplot2)
#' library(smpic)
#'
#' p <- ggplot(iris) +
#'      geom_point(aes(Petal.Length, Petal.Width, color = Species), show.legend = FALSE) +
#'        geom_label(data = summarise_if(group_by(iris, Species), is.numeric, mean),
#'                   aes(Petal.Length, Petal.Width, label = Species, color = Species),
#'                   show.legend = FALSE) +
#'        labs(x = "Petal Length", y = "Petal Width",
#'             title = "Look mom, a flower plot!",
#'             subtitle = "Yet another iris data set visualization.",
#'             caption = "Source: iris") +
#'        theme_minimal()
#'
#'   smpic_view(p, sm = "facebook_shared_images", text_factor = 2.2)

smpic_view <- function(p,
                       sm = c("facebook_shared_images", "facebook_profile_image",
                              "facebook_cover_photo", "facebook_shared_link",
                              "facebook_highlighted_image", "facebook_event_image",
                              "linkedin_profile_image", "linkedin_standard_logo",
                              "linkedin_hero_image", "linkedin_business_banner_image",
                              "linkedin_square_logo", "youtube_channel_cover_photo",
                              "youtube_video_uploads", "instagram_profile_image",
                              "instagram_photo_thumbnails", "instagram_photo_size",
                              "twitter_header_photo", "twitter_profile_image",
                              "twitter_in-stream_photo", "pinterest_profile_image",
                              "pinterest_board_display", "pinterest_board_display_thumbnails",
                              "pinterest_pin_sizes", "tumblr_profile_image",
                              "tumblr_image_posts", "g+_profile_image", "g+_cover_image",
                              "g+_shared_image", "g+_shared_video", "g+_shared_image_square",
                              "ello_banner_image", "ello_profile_image"),
                       text_factor = 1) {

  # Set dimensions to fit with social media
  sm <- sm[1]
  my_dims <- dplyr::filter(smpic::smpic_dim, id == sm)

  # Set temp filename
  filename <- paste0(tempfile(), ".png")

  # Make height and width calculations
  dpi <- text_factor * 100
  width.calc <- my_dims$width / dpi
  height.calc <- my_dims$height / dpi

  # Save the plot to the temporary file
  ggplot2::ggsave(filename = filename,
                  dpi = dpi,
                  width = width.calc,
                  height = height.calc,
                  units = 'in',
                  plot = p)

  # Create a title for the view
  title <- stringr::str_replace_all(sm, "_", " ")
  title <- stringr::str_to_title(title)
  title <- stringr::str_c(title, " ", my_dims$width, " x ", my_dims$height)

  # Show the image back
  im <- imager::load.image(filename)
  graphics::plot(im, main = title)

  }
