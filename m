Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933177Ab1EZSFc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 14:05:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:16485 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933091Ab1EZSFa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 14:05:30 -0400
X-ExtLoop1: 1
Date: Thu, 26 May 2011 20:05:18 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Abhijeet Dharmapurikar <adharmap@codeaurora.org>,
        Axel Lin <axel.lin@gmail.com>, Graeme Gregory <gg@slimlogic.co.uk>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Johan Palsson <johan.palsson@stericsson.com>,
        Karl Komierowski <karl.komierowski@stericsson.com>,
        Keshava Munegowda <Keshava_mgowda@ti.com>, Lesly A M <leslyam@ti.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Paul Parsons <lost.distance@yahoo.com>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Trilok Soni <tsoni@codeaurora.org>,
        Vincent Palatin <vpalatin@chromium.org>,
        Wanlong Gao <wanlong.gao@gmail.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: [GIT] [2.6.40] MFD pull request
Message-ID: <20110526180518.GC20068@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Here is the MFD pull request for the 2.6.40 merge window. A big part of it is
coming from the final removal of the mfd_data pointer. The next contender
comes with the addition of the Qualcomm PMIC 8921 driver and a couple of its
input sub devices. More support for this chip will be added with the next
merge window.
The regular 88pm860x update came with rtc support, while the twl one brought
support for the twl6025 chipset. The WM8xxx update was fairly small this time.
Finally, asic3's LED support is enabled now.

Thanks in advance for pulling this one in:

The following changes since commit 4db70f73e56961b9bcdfd0c36c62847a18b7dbb5:

  tmpfs: fix XATTR N overriding POSIX_ACL Y (2011-05-25 19:53:02 -0700)

are available in the git repository at:
  git://git.kernel.org/pub/scm/linux/kernel/git/sameo/mfd-2.6.git for-next

Abhijeet Dharmapurikar (3):
      mfd: Add Qualcomm PMIC 8921 core driver
      mfd: Add pm8xxx irq support
      MAINTAINERS: Add patterns for pmic 8921 files to MSM subsystem

Axel Lin (3):
      mfd: Group TPSxxxxx power management chips together
      mfd: Group NXP PCF50633* drivers together
      mfd: Fix omap_usbhs_alloc_children error handling

Graeme Gregory (2):
      mfd: Add phoenix lite (twl6025) support to twl6030
      mfd: Fix twl6030 irq definitions

Haojian Zhuang (8):
      mfd: Fix build warning on 88pm860x
      power_supply: Use max8925 platform_data from cell
      regulator: Enable max8925 i2c sequence for control
      mfd: Add rtc support to 88pm860x
      mfd: Avoid to allocate 88pm860x static platform data
      mfd: Remove unused parameter from 88pm860x API
      mfd: Remove checking on max8925 regulator[0]
      mfd: Avoid to use constraint name in 88pm860x regulator driver

Johan Palsson (1):
      mfd: Correct the name and bitmask for ab8500-gpadc BTempPullUp

Karl Komierowski (1):
      mfd: Add manual ab8500-gpadc batt temp activation for AB8500 3.0

Keshava Munegowda (2):
      mfd: Fix omap usbhs crash when rmmoding ehci or ohci
      mfd: Add omap-usbhs runtime PM support

Lesly A M (4):
      mfd: Correct the twl4030-power warning print during script loading
      mfd: Modifying the twl4030-power macro name Main_Ref to all caps
      mfd: TWL5030 version checking in twl-core
      mfd: Check twl4030-power remove script error condition after i2cwrite

Linus Walleij (1):
      mfd: Provide ab8500-core enumerators for chip cuts

Mark Brown (3):
      mfd: Remove compatibility interface for WM831x specific IRQ API
      mfd: Provide platform data for WM831x GPIO configuration
      mfd: Continue with IRQ setup even if we don't have PMIC main IRQ

Paul Parsons (3):
      leds: Add ASIC3 LED support
      mfd: Add ASIC3 LED support
      mfd: Fix ASIC3 SD Host Controller Configuration size

Peter Ujfalusi (1):
      mfd: Update twl4030-code maintainer e-mail address

Randy Dunlap (1):
      regulator: Fix 88pm8607.c printk format warning

Samuel Ortiz (20):
      mfd: Add platform data pointer back
      mfd: Use mfd cell platform_data for ab3550 cells platform bits
      mfd: Use mfd cell platform_data for ab3100 cells platform bits
      mmc: Use device platform_data to retrieve tmio_mmc platform bits
      w1: Use device platform_data to retrieve ds1wm platform bits
      mfd: Pass htc-pasic3 led platform data through the cell platform_data
      mfd: Use mfd cell platform_data for wl1273 cells platform bits
      fb: Use platform_data to retrieve tmiofb platform bits
      mtd: Use platform_data to retrieve tmio_nand platform bits
      mfd: Use mfd cell platform_data for timberdale cells platform bits
      mfd: Use mfd cell platform_data for rdc321x cells platform bits
      mfd: Use mfd cell platform_data for mc13xxx cells platform bits
      mfd: Use mfd cell platform_data for janz cells platform bits
      mfd: Use mfd cell platform_data for twl4030 codec cells platform bits
      mfd: Use mfd cell platform_data for tps6105x cells platform bits
      mfd: Use mfd cell platform_data for 88pm860x cells platform bits
      mfd: Use mfd cell platform_data for davinci cells platform bits
      mfd: Use mfd cell platform_data for wm8400 cells platform bits
      regulator: Use device platform_data to retrieve db8500 platform bits
      mfd: Remove mfd_data

Trilok Soni (2):
      input: Add Qualcomm pm8xxx keypad controller driver
      input: Add support for Qualcomm PMIC8XXX power key

Vincent Palatin (1):
      mfd: Fix tps6586x GPIO value setting

Wanlong Gao (1):
      mfd: Fix wl1273 warning

 MAINTAINERS                                  |    2 +
 arch/arm/mach-omap2/board-rx51-peripherals.c |    2 +-
 drivers/dma/timb_dma.c                       |    3 +-
 drivers/gpio/janz-ttl.c                      |    3 +-
 drivers/gpio/rdc321x-gpio.c                  |    3 +-
 drivers/gpio/timbgpio.c                      |    6 +-
 drivers/i2c/busses/i2c-ocores.c              |    3 +-
 drivers/i2c/busses/i2c-xiic.c                |    3 +-
 drivers/input/keyboard/Kconfig               |   11 +
 drivers/input/keyboard/Makefile              |    1 +
 drivers/input/keyboard/pmic8xxx-keypad.c     |  799 ++++++++++++++++++++++++++
 drivers/input/misc/Kconfig                   |   11 +
 drivers/input/misc/Makefile                  |    1 +
 drivers/input/misc/pmic8xxx-pwrkey.c         |  231 ++++++++
 drivers/input/misc/twl4030-vibra.c           |    3 +-
 drivers/leds/Kconfig                         |   10 +
 drivers/leds/Makefile                        |    1 +
 drivers/leds/leds-88pm860x.c                 |    7 +-
 drivers/leds/leds-asic3.c                    |  165 ++++++
 drivers/leds/leds-mc13783.c                  |    7 +-
 drivers/media/radio/radio-timb.c             |    3 +-
 drivers/media/radio/radio-wl1273.c           |    2 +-
 drivers/media/video/timblogiw.c              |    3 +-
 drivers/mfd/88pm860x-core.c                  |  155 +++---
 drivers/mfd/Kconfig                          |   84 ++-
 drivers/mfd/Makefile                         |    2 +
 drivers/mfd/ab3100-core.c                    |    6 +-
 drivers/mfd/ab3550-core.c                    |    6 +-
 drivers/mfd/ab8500-core.c                    |   32 +-
 drivers/mfd/ab8500-gpadc.c                   |   34 ++-
 drivers/mfd/asic3.c                          |   83 +++-
 drivers/mfd/davinci_voicecodec.c             |    6 +-
 drivers/mfd/htc-pasic3.c                     |    5 +-
 drivers/mfd/janz-cmodio.c                    |    3 +-
 drivers/mfd/max8925-core.c                   |    2 +-
 drivers/mfd/mc13xxx-core.c                   |   12 +-
 drivers/mfd/mfd-core.c                       |    7 +
 drivers/mfd/omap-usb-host.c                  |  152 +----
 drivers/mfd/pm8921-core.c                    |  212 +++++++
 drivers/mfd/pm8xxx-irq.c                     |  371 ++++++++++++
 drivers/mfd/rdc321x-southbridge.c            |    6 +-
 drivers/mfd/t7l66xb.c                        |    6 +-
 drivers/mfd/tc6387xb.c                       |    3 +-
 drivers/mfd/tc6393xb.c                       |   10 +-
 drivers/mfd/timberdale.c                     |   81 ++-
 drivers/mfd/tps6105x.c                       |    3 +-
 drivers/mfd/tps6586x.c                       |    4 +-
 drivers/mfd/twl-core.c                       |  252 +++++++--
 drivers/mfd/twl4030-codec.c                  |   10 +-
 drivers/mfd/twl4030-power.c                  |    6 +-
 drivers/mfd/twl6030-irq.c                    |    4 +-
 drivers/mfd/wl1273-core.c                    |    7 +-
 drivers/mfd/wm831x-core.c                    |   13 +-
 drivers/mfd/wm831x-irq.c                     |   27 +-
 drivers/mfd/wm8400-core.c                    |    3 +-
 drivers/mmc/host/tmio_mmc.c                  |    2 +-
 drivers/mtd/nand/tmio_nand.c                 |    2 +-
 drivers/net/can/janz-ican3.c                 |    3 +-
 drivers/net/ks8842.c                         |    3 +-
 drivers/power/max8925_power.c                |   10 +-
 drivers/regulator/88pm8607.c                 |   30 +-
 drivers/regulator/ab3100.c                   |    3 +-
 drivers/regulator/db8500-prcmu.c             |    4 +-
 drivers/regulator/max8925-regulator.c        |   11 +-
 drivers/regulator/mc13783-regulator.c        |    7 +-
 drivers/regulator/mc13892-regulator.c        |    7 +-
 drivers/regulator/tps6105x-regulator.c       |    4 +-
 drivers/rtc/Kconfig                          |   10 +
 drivers/rtc/Makefile                         |    1 +
 drivers/rtc/rtc-88pm860x.c                   |  427 ++++++++++++++
 drivers/spi/xilinx_spi.c                     |    3 +-
 drivers/video/backlight/88pm860x_bl.c        |    7 +-
 drivers/video/tmiofb.c                       |   12 +-
 drivers/w1/masters/ds1wm.c                   |   12 +-
 drivers/watchdog/rdc321x_wdt.c               |    3 +-
 include/linux/i2c/twl.h                      |   54 ++-
 include/linux/input/pmic8xxx-keypad.h        |   52 ++
 include/linux/input/pmic8xxx-pwrkey.h        |   31 +
 include/linux/mfd/88pm860x.h                 |    6 +
 include/linux/mfd/abx500.h                   |    8 +
 include/linux/mfd/asic3.h                    |   23 +-
 include/linux/mfd/core.h                     |   23 +-
 include/linux/mfd/pm8xxx/core.h              |   81 +++
 include/linux/mfd/pm8xxx/irq.h               |   59 ++
 include/linux/mfd/pm8xxx/pm8921.h            |   31 +
 include/linux/mfd/twl4030-codec.h            |    2 +-
 include/linux/mfd/wm831x/core.h              |   26 -
 include/linux/mfd/wm831x/pdata.h             |    4 +
 sound/soc/codecs/cq93vc.c                    |    3 +-
 sound/soc/codecs/twl4030.c                   |    6 +-
 sound/soc/codecs/wl1273.c                    |    3 +-
 sound/soc/codecs/wm8400.c                    |    2 +-
 sound/soc/davinci/davinci-vcif.c             |    2 +-
 93 files changed, 3330 insertions(+), 534 deletions(-)
 create mode 100644 drivers/input/keyboard/pmic8xxx-keypad.c
 create mode 100644 drivers/input/misc/pmic8xxx-pwrkey.c
 create mode 100644 drivers/leds/leds-asic3.c
 create mode 100644 drivers/mfd/pm8921-core.c
 create mode 100644 drivers/mfd/pm8xxx-irq.c
 create mode 100644 drivers/rtc/rtc-88pm860x.c
 create mode 100644 include/linux/input/pmic8xxx-keypad.h
 create mode 100644 include/linux/input/pmic8xxx-pwrkey.h
 create mode 100644 include/linux/mfd/pm8xxx/core.h
 create mode 100644 include/linux/mfd/pm8xxx/irq.h
 create mode 100644 include/linux/mfd/pm8xxx/pm8921.h
-- 
Intel Open Source Technology Centre
http://oss.intel.com/
