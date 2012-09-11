Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab2IKNwK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:52:10 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:48217 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757976Ab2IKNwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:52:07 -0400
Message-ID: <504F4227.4080206@ti.com>
Date: Tue, 11 Sep 2012 16:52:39 +0300
From: Peter Ujfalusi <peter.ujfalusi@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120903 Thunderbird/15.0
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Tony Lindgren <tony@atomide.com>, Kevin Hilman <khilman@ti.com>,
        =?UTF-8?B?QmVub8OudCBDb3Vzc29u?= <b-cousson@ti.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Ohad Ben-Cohen <ohad@wizery.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Omar Ramirez Luna <omar.ramirez@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Jarkko Nikula <jarkko.nikula@bitmer.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        Jean Pihet <j-pihet@ti.com>, J Keerthy <j-keerthy@ti.com>,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 13/16] ARM: omap: move platform_data definitions
References: <1347368350-31212-1-git-send-email-arnd@arndb.de> <1347368390-31252-1-git-send-email-arnd@arndb.de> <1347368390-31252-13-git-send-email-arnd@arndb.de>
In-Reply-To: <1347368390-31252-13-git-send-email-arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On 09/11/2012 03:59 PM, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the omap include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: "Benoît Cousson" <b-cousson@ti.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Kyungmin Park <kyungmin.park@samsung.com>
> Cc: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Omar Ramirez Luna <omar.ramirez@ti.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Tomi Valkeinen <tomi.valkeinen@ti.com>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Peter Ujfalusi <peter.ujfalusi@ti.com>
> Cc: Jarkko Nikula <jarkko.nikula@bitmer.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Artem Bityutskiy <artem.bityutskiy@linux.intel.com>
> Cc: Jean Pihet <j-pihet@ti.com>
> Cc: J Keerthy <j-keerthy@ti.com>
> Cc: linux-omap@vger.kernel.org
> ---
>  arch/arm/mach-omap1/board-ams-delta.c                              |    2 +-
>  arch/arm/mach-omap1/board-fsample.c                                |    2 +-
>  arch/arm/mach-omap1/board-h2.c                                     |    2 +-
>  arch/arm/mach-omap1/board-h3.c                                     |    2 +-
>  arch/arm/mach-omap1/board-htcherald.c                              |    2 +-
>  arch/arm/mach-omap1/board-innovator.c                              |    2 +-
>  arch/arm/mach-omap1/board-nokia770.c                               |    4 ++--
>  arch/arm/mach-omap1/board-osk.c                                    |    2 +-
>  arch/arm/mach-omap1/board-palmte.c                                 |    2 +-
>  arch/arm/mach-omap1/board-palmtt.c                                 |    2 +-
>  arch/arm/mach-omap1/board-palmz71.c                                |    2 +-
>  arch/arm/mach-omap1/board-perseus2.c                               |    2 +-
>  arch/arm/mach-omap1/board-sx1.c                                    |    2 +-
>  arch/arm/mach-omap1/mcbsp.c                                        |    2 +-
>  arch/arm/mach-omap2/board-3430sdp.c                                |    2 +-
>  arch/arm/mach-omap2/board-cm-t35.c                                 |    4 ++--
>  arch/arm/mach-omap2/board-cm-t3517.c                               |    2 +-
>  arch/arm/mach-omap2/board-devkit8000.c                             |    4 ++--
>  arch/arm/mach-omap2/board-flash.c                                  |    4 ++--
>  arch/arm/mach-omap2/board-igep0020.c                               |    2 +-
>  arch/arm/mach-omap2/board-ldp.c                                    |    2 +-
>  arch/arm/mach-omap2/board-n8x0.c                                   |    4 ++--
>  arch/arm/mach-omap2/board-omap3beagle.c                            |    2 +-
>  arch/arm/mach-omap2/board-omap3evm.c                               |    4 ++--
>  arch/arm/mach-omap2/board-omap3pandora.c                           |    4 ++--
>  arch/arm/mach-omap2/board-omap3stalker.c                           |    4 ++--
>  arch/arm/mach-omap2/board-omap3touchbook.c                         |    4 ++--
>  arch/arm/mach-omap2/board-overo.c                                  |    4 ++--
>  arch/arm/mach-omap2/board-rm680.c                                  |    2 +-
>  arch/arm/mach-omap2/board-rx51-peripherals.c                       |    4 ++--
>  arch/arm/mach-omap2/board-rx51-video.c                             |    2 +-
>  arch/arm/mach-omap2/board-rx51.c                                   |    2 +-
>  arch/arm/mach-omap2/board-zoom-display.c                           |    2 +-
>  arch/arm/mach-omap2/common-board-devices.c                         |    4 ++--
>  arch/arm/mach-omap2/devices.c                                      |    2 +-
>  arch/arm/mach-omap2/dsp.c                                          |    2 +-
>  arch/arm/mach-omap2/gpmc-nand.c                                    |    2 +-
>  arch/arm/mach-omap2/gpmc-onenand.c                                 |    2 +-
>  arch/arm/mach-omap2/mcbsp.c                                        |    2 +-
>  arch/arm/mach-omap2/omap_hwmod_2420_data.c                         |    2 +-
>  arch/arm/mach-omap2/omap_hwmod_2430_data.c                         |    4 ++--
>  arch/arm/mach-omap2/omap_hwmod_2xxx_ipblock_data.c                 |    2 +-
>  arch/arm/mach-omap2/omap_hwmod_3xxx_data.c                         |    4 ++--
>  arch/arm/mach-omap2/omap_hwmod_44xx_data.c                         |    4 ++--
>  arch/arm/mach-omap2/voltage.h                                      |    2 +-
>  arch/arm/plat-omap/common.c                                        |    2 +-
>  drivers/input/keyboard/omap-keypad.c                               |    2 +-
>  drivers/mtd/nand/omap2.c                                           |    2 +-
>  drivers/mtd/onenand/omap2.c                                        |    2 +-
>  drivers/remoteproc/omap_remoteproc.c                               |    2 +-
>  drivers/spi/spi-omap2-mcspi.c                                      |    2 +-
>  drivers/staging/tidspbridge/core/dsp-clock.c                       |    2 +-
>  drivers/staging/tidspbridge/core/tiomap3430.c                      |    2 +-
>  drivers/staging/tidspbridge/core/tiomap3430_pwr.c                  |    2 +-
>  drivers/staging/tidspbridge/core/tiomap_io.c                       |    2 +-
>  drivers/staging/tidspbridge/rmgr/drv_interface.c                   |    2 +-
>  drivers/video/omap/lcd_mipid.c                                     |    2 +-
>  .../plat/mcbsp.h => include/linux/platform_data/dsp-mcbsp.h        |    0

OMAP McBSP has nothing to do with a dsp.
A better name would be: ti-mcbsp.h (or leave it as mcbsp.h)
McBSP stands for: Multichannel Buffered Serial Port and it is used for audio
connection (I2S, TDM, etc).

>  .../include/plat/dsp.h => include/linux/platform_data/dsp-omap.h   |    0
>  .../plat/keypad.h => include/linux/platform_data/keypad-omap.h     |    0
>  .../plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h    |    0
>  .../plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h    |    0
>  .../onenand.h => include/linux/platform_data/mtd-onenand-omap2.h   |    0
>  .../remoteproc.h => include/linux/platform_data/remoteproc-omap.h  |    0
>  .../voltage.h => include/linux/platform_data/smartreflex-omap.h    |    0
>  .../plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h  |    0
>  include/linux/power/smartreflex.h                                  |    2 +-

Let me see these:

This four drivers are going to be removed via sound tree.
>  sound/soc/omap/igep0020.c                                          |    2 +-
>  sound/soc/omap/omap3beagle.c                                       |    2 +-
>  sound/soc/omap/omap3evm.c                                          |    2 +-
>  sound/soc/omap/overo.c                                             |    2 +-

The new driver which replaces these (omap-twl4030.c) does not include
plat/mcbsp.h

>From these ASoC machine drivers you can just remove the <plat/mcbsp.h>
include since they should not include them (I have pending patch for this to
be sent):
>  sound/soc/omap/am3517evm.c                                         |    2 +-
>  sound/soc/omap/ams-delta.c                                         |    2 +-
>  sound/soc/omap/n810.c                                              |    2 +-
>  sound/soc/omap/omap3pandora.c                                      |    2 +-
>  sound/soc/omap/osk5912.c                                           |    2 +-
>  sound/soc/omap/rx51.c                                              |    2 +-
>  sound/soc/omap/sdp3430.c                                           |    2 +-
>  sound/soc/omap/zoom2.c                                             |    2 +-

>  sound/soc/omap/omap-mcbsp.c                                        |    2 +-
>  sound/soc/omap/mcbsp.c                                             |    2 +-

>  81 files changed, 87 insertions(+), 87 deletions(-)
>  rename arch/arm/plat-omap/include/plat/mcbsp.h => include/linux/platform_data/dsp-mcbsp.h (100%)
>  rename arch/arm/plat-omap/include/plat/dsp.h => include/linux/platform_data/dsp-omap.h (100%)
>  rename arch/arm/plat-omap/include/plat/keypad.h => include/linux/platform_data/keypad-omap.h (100%)
>  rename arch/arm/plat-omap/include/plat/lcd_mipid.h => include/linux/platform_data/lcd-mipid.h (100%)
>  rename arch/arm/plat-omap/include/plat/nand.h => include/linux/platform_data/mtd-nand-omap2.h (100%)
>  rename arch/arm/plat-omap/include/plat/onenand.h => include/linux/platform_data/mtd-onenand-omap2.h (100%)
>  rename arch/arm/plat-omap/include/plat/remoteproc.h => include/linux/platform_data/remoteproc-omap.h (100%)
>  rename arch/arm/plat-omap/include/plat/voltage.h => include/linux/platform_data/smartreflex-omap.h (100%)
>  rename arch/arm/plat-omap/include/plat/mcspi.h => include/linux/platform_data/spi-omap2-mcspi.h (100%)

-- 
Péter
