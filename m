Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753054Ab2G0AlI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 20:41:08 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:38786 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752821Ab2G0AlG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 20:41:06 -0400
MIME-Version: 1.0
From: Bryan Wu <bryan.wu@canonical.com>
Date: Fri, 27 Jul 2012 08:40:44 +0800
X-Google-Sender-Auth: PqDCNMtLFjn1qN8-8GiZZIbSydM
Message-ID: <CAK5ve-Kt_Mw_wgp6E0nXEvNjh88rtARES+CpS7Kj=Zq0rHEYKA@mail.gmail.com>
Subject: [GIT PULL] LED subsystem update for v3.6
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: lkml <linux-kernel@vger.kernel.org>,
        Linux LED Subsystem <linux-leds@vger.kernel.org>, rpurdie@rpsys.net,
        akpm <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please consider pulling the following changes since commit
28a33cbc24e4256c143dce96c7d93bf423229f92:

  Linux 3.5 (2012-07-21 13:58:29 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/cooloney/linux-leds.git
for-3.6-rc1

for you to fetch changes up to d45bb11616c94c76c6e40960a120c0687b708a2e:

  leds-lp8788: forgotten unlock at lp8788_led_work (2012-07-27 08:16:07 +0800)

----------------------------------------------------------------
Axel Lin (1):
      leds: max8997: Simplify max8997_led_set_mode implementation

Bryan Wu (22):
      led-triggers: rename *trigger to *trig for unified naming scheme
      leds: fix sparse warnings due to missing static
      leds: convert Big Networks LED driver to devm_kzalloc()
      leds: convert HTC ASIC3 LED driver to devm_kzalloc() and cleanup
error exit path
      leds: convert Atmel PWM LED driver to devm_kzalloc()
      leds: convert LP3944 LED driver to devm_kzalloc()
      leds: convert DA9030/DA9034 LED driver to devm_kzalloc() and
cleanup error exit path
      leds: convert LP5521 LED driver to devm_kzalloc() and cleanup
error exit path
      leds: convert BD2802 RGB LED driver to devm_kzalloc() and
cleanup error exit path
      leds: convert PCA9633 LED driver to devm_kzalloc()
      leds: convert LP5523 LED driver to devm_kzalloc() and cleanup
error exit path
      leds: convert Renesas TPU LED driver to devm_kzalloc() and
cleanup error exit path
      leds: convert LT3593 LED driver to devm_kzalloc()
      leds: convert PCA9532 LED driver to devm_kzalloc()
      leds: convert Sun Fire LED driver to devm_kzalloc() and cleanup
error exit path
      leds: convert PCA955x LED driver to devm_kzalloc() and cleanup
error exit path
      leds: convert ADP5520 LED driver to devm_kzalloc() and cleanup
error exit path
      leds: convert Freescale MC13783 LED driver to devm_kzalloc() and
cleanup error exit path
      leds: convert TCA6507 LED driver to devm_kzalloc()
      leds: convert LM3530 LED driver to devm_kzalloc() and cleanup
error exit path
      leds: convert DAC124S085 LED driver to devm_kzalloc()
      leds: convert Network Space v2 LED driver to devm_kzalloc() and
cleanup error exit path

Dan Carpenter (3):
      leds-lp5523: BUG() in error handling in probe()
      LEDS: memory leak in blinkm_led_common_set()
      LEDS: propagate error codes in blinkm_detect()

Devendra Naga (5):
      leds: [trivial]Remove unnecesary return
      leds-88pm860x: use devm_kzalloc function
      leds-mc13783: set platform data to NULL at mc13783_led_remove
      leds/leds-s3c24xx: use devm_gpio_request
      leds-lp8788: forgotten unlock at lp8788_led_work

Fabio Baltieri (5):
      leds: add oneshot blink functions
      ledtrig-ide-disk: use generic one-shot blink api
      leds: fix led_brightness_set when soft-blinking
      leds: add oneshot trigger
      leds: use led_set_brightness in led_trigger_event

G.Shark Jeong (1):
      leds: Add LED driver for lm3556 chip

Jan-Simon Möller (1):
      LEDS: add BlinkM RGB LED driver, documentation and update MAINTAINERS

Jesper Dangaard Brouer (1):
      leds: correct trivial type in drivers/leds/Kconfig

Kim, Milo (1):
      leds: add new lp8788 led driver

Peter Meerwald (1):
      leds: convert tca6507 driver to module_i2c_driver()

Sachin Kamat (5):
      leds: Use module_platform_driver() in leds-max8997.c file
      leds: Use devm_kzalloc in leds-pwm.c file
      leds: Use devm_kzalloc in leds-regulator.c file
      leds: Use devm_kzalloc in leds-max8997.c file
      leds: Use devm_kzalloc in leds-gpio.c file

Shuah Khan (2):
      leds: Rename led_set_brightness() to __led_set_brightness()
      leds: Rename led_brightness_set() to led_set_brightness()

Sylwester Nawrocki (2):
      leds: Convert S3C24XX LED driver to devm_kzalloc()
      leds: Convert S3C24XX LED driver to gpiolib API

 Documentation/leds/00-INDEX               |   2 +
 Documentation/leds/leds-blinkm.txt        |  80 +++
 Documentation/leds/leds-lm3556.txt        |  85 ++++
 Documentation/leds/ledtrig-oneshot.txt    |  59 +++
 MAINTAINERS                               |   5 +
 drivers/leds/Kconfig                      |  39 +-
 drivers/leds/Makefile                     |   4 +
 drivers/leds/led-class.c                  |  27 +-
 drivers/leds/led-core.c                   |  66 ++-
 drivers/leds/led-triggers.c               | 114 +++--
 drivers/leds/leds-88pm860x.c              |   9 +-
 drivers/leds/leds-adp5520.c               |   8 +-
 drivers/leds/leds-asic3.c                 |  16 +-
 drivers/leds/leds-atmel-pwm.c             |   5 +-
 drivers/leds/leds-bd2802.c                |   8 +-
 drivers/leds/leds-blinkm.c                | 815 ++++++++++++++++++++++++++++++
 drivers/leds/leds-da903x.c                |   9 +-
 drivers/leds/leds-dac124s085.c            |   4 +-
 drivers/leds/leds-gpio.c                  |  11 +-
 drivers/leds/leds-lm3530.c                |  24 +-
 drivers/leds/leds-lm3556.c                | 512 +++++++++++++++++++
 drivers/leds/leds-lp3944.c                |   9 +-
 drivers/leds/leds-lp5521.c                |  20 +-
 drivers/leds/leds-lp5523.c                |  30 +-
 drivers/leds/leds-lp8788.c                | 193 +++++++
 drivers/leds/leds-lt3593.c                |   9 +-
 drivers/leds/leds-max8997.c               |  93 +---
 drivers/leds/leds-mc13783.c               |   9 +-
 drivers/leds/leds-netxbig.c               |  10 +-
 drivers/leds/leds-ns2.c                   |  19 +-
 drivers/leds/leds-pca9532.c               |  10 +-
 drivers/leds/leds-pca955x.c               |  18 +-
 drivers/leds/leds-pca9633.c               |   6 +-
 drivers/leds/leds-pwm.c                   |   7 +-
 drivers/leds/leds-regulator.c             |   9 +-
 drivers/leds/leds-renesas-tpu.c           |  23 +-
 drivers/leds/leds-s3c24xx.c               |  44 +-
 drivers/leds/leds-sunfire.c               |  21 +-
 drivers/leds/leds-tca6507.c               |  17 +-
 drivers/leds/leds.h                       |   2 +-
 drivers/leds/ledtrig-backlight.c          |   8 +-
 drivers/leds/ledtrig-default-on.c         |   2 +-
 drivers/leds/ledtrig-gpio.c               |   6 +-
 drivers/leds/ledtrig-heartbeat.c          |   2 +-
 drivers/leds/ledtrig-ide-disk.c           |  25 +-
 drivers/leds/ledtrig-oneshot.c            | 204 ++++++++
 drivers/leds/ledtrig-timer.c              |   2 +-
 drivers/leds/ledtrig-transient.c          |   8 +-
 include/linux/leds.h                      |  29 +-
 include/linux/platform_data/leds-lm3556.h |  50 ++
 net/mac80211/led.c                        |   2 +-
 51 files changed, 2376 insertions(+), 413 deletions(-)
 create mode 100644 Documentation/leds/leds-blinkm.txt
 create mode 100644 Documentation/leds/leds-lm3556.txt
 create mode 100644 Documentation/leds/ledtrig-oneshot.txt
 create mode 100644 drivers/leds/leds-blinkm.c
 create mode 100644 drivers/leds/leds-lm3556.c
 create mode 100644 drivers/leds/leds-lp8788.c
 create mode 100644 drivers/leds/ledtrig-oneshot.c
 create mode 100644 include/linux/platform_data/leds-lm3556.h
