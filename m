Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757364Ab2ILKo0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 06:44:26 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:39742 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756741Ab2ILKoV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 06:44:21 -0400
From: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: "Hilman, Kevin" <khilman@ti.com>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Chris Ball <cjb@laptop.org>, Russell King <linux@arm.linux.org.uk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Balbi, Felipe" <balbi@ti.com>, Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Stern <stern@rowland.harvard.edu>,
        Ben Dooks <ben-linux@fluff.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        David Woodhouse <dwmw2@infradead.org>, "Girdwood, Liam" <lrg@ti.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH 02/16] ARM: davinci: move platform_data definitions
Thread-Topic: [PATCH 02/16] ARM: davinci: move platform_data definitions
Thread-Index: AQHNkB2hDdV0QnjnwEunK47bS7LbDpeGhaVg
Date: Wed, 12 Sep 2012 10:42:46 +0000
Message-ID: <1BAFE6F6C881BF42822005164F1491C33EA802EC@DBDE01.ent.ti.com>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
	<1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-2-git-send-email-arnd@arndb.de>
In-Reply-To: <1347368390-31252-2-git-send-email-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-cr-puzzleid: {2D1022DB-A91E-446D-932A-D2C6173728EB}
x-cr-hashedpuzzle: =?Windows-1252?Q?ACCG_BW88_i0Sh_wytZ_AB4oiA=3D=3D_AD+JtQ=3D=3D_AFd4mw=3D?=
 =?Windows-1252?B?PSBBSUdIekE9PSBBSW9OaHc9PSBBSTFWaEE9PSBBTk51bWc9PSBBVHlr?=
 =?Windows-1252?B?bXc9PSBBWE1MZGc9PSBBWUIvcVE9PSBBWUQ3YWc9PSBBWjlWZ2c9PTsx?=
 =?Windows-1252?Q?5;YQByAG4AZABAAGEAcgBuAGQAYgAuAGQAZQA7AGIAZQBuAC0AbABpAG?=
 =?Windows-1252?Q?4AdQB4AEAAZgBsAHUAZgBmAC4AbwByAGcAOwBiAHIAbwBvAG4AaQBlAE?=
 =?Windows-1252?Q?AAbwBwAGUAbgBzAG8AdQByAGMAZQAuAHcAbwBsAGYAcwBvAG4AbQBpAG?=
 =?Windows-1252?Q?MAcgBvAC4AYwBvAG0AOwBjAGoAYgBAAGwAYQBwAHQAbwBwAC4AbwByAG?=
 =?Windows-1252?Q?cAOwBkAGEAdgBpAG4AYwBpAC0AbABpAG4AdQB4AC0AbwBwAGUAbgAtAH?=
 =?Windows-1252?Q?MAbwB1AHIAYwBlAEAAbABpAG4AdQB4AC4AZABhAHYAaQBuAGMAaQBkAH?=
 =?Windows-1252?Q?MAcAAuAGMAbwBtADsAZABtAGkAdAByAHkALgB0AG8AcgBvAGsAaABvAH?=
 =?Windows-1252?Q?YAQABnAG0AYQBpAGwALgBjAG8AbQA7AGQAdwBtAHcAMgBAAGkAbgBmAH?=
 =?Windows-1252?Q?IAYQBkAGUAYQBkAC4AbwByAGcAOwBnAHIAYQBuAHQALgBsAGkAawBlAG?=
 =?Windows-1252?Q?wAeQBAAHMAZQBjAHIAZQB0AGwAYQBiAC4AYwBhADsAZwByAGUAZwBrAG?=
 =?Windows-1252?Q?gAQABsAGkAbgB1AHgAZgBvAHUAbgBkAGEAdABpAG8AbgAuAG8AcgBnAD?=
 =?Windows-1252?Q?sAbABpAG4AdQB4AC0AYQByAG0ALQBrAGUAcgBuAGUAbABAAGwAaQBzAH?=
 =?Windows-1252?Q?QAcwAuAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAOwBsAGkAbgB1AH?=
 =?Windows-1252?Q?gALQBrAGUAcgBuAGUAbABAAHYAZwBlAHIALgBrAGUAcgBuAGUAbAAuAG?=
 =?Windows-1252?Q?8AcgBnADsAbABpAG4AdQB4AEAAYQByAG0ALgBsAGkAbgB1AHgALgBvAH?=
 =?Windows-1252?Q?IAZwAuAHUAawA7AG0AYwBoAGUAaABhAGIAQABpAG4AZgByAGEAZABlAG?=
 =?Windows-1252?Q?EAZAAuAG8AcgBnADsAcwB0AGUAcgBuAEAAcgBvAHcAbABhAG4AZAAuAG?=
 =?Windows-1252?Q?gAYQByAHYAYQByAGQALgBlAGQAdQA7AHcALgBzAGEAbgBnAEAAcABlAG?=
 =?Windows-1252?Q?4AZwB1AHQAcgBvAG4AaQB4AC4AZABlAA=3D=3D;Sosha1=5Fv1;7;{2D?=
 =?Windows-1252?Q?1022DB-A91E-446D-932A-D2C6173728EB};ZwB1AHIAdQByAGEAagBh?=
 =?Windows-1252?Q?AC4AaABlAGIAYgBhAHIAQAB0AGkALgBjAG8AbQA=3D;Wed,_12_Sep_2?=
 =?Windows-1252?Q?012_10:42:02_GMT;UgBFADoAIABbAFAAQQBUAEMASAAgADAAMgAvADE?=
 =?Windows-1252?Q?ANgBdACAAQQBSAE0AOgAgAGQAYQB2AGkAbgBjAGkAOgAgAG0AbwB2AGU?=
 =?Windows-1252?Q?AIABwAGwAYQB0AGYAbwByAG0AXwBkAGEAdABhACAAZABlAGYAaQBuAGk?=
 =?Windows-1252?Q?AdABpAG8AbgBzAA=3D=3D?=
x-originating-ip: [172.24.170.142]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 18:29:36, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the davinci include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>

[..snip..]
[..snip]]

>  drivers/usb/musb/da8xx.c                                     |    2 +-


>  .../asp.h => include/linux/platform_data/asoc-davinci-evm.h  |    0


This will clash with patch "ASoC/ARM: Davinci: McASP: split asp header into 
platform and audio specific" queued in ASoC tree by Mark


>  .../mach/i2c.h => include/linux/platform_data/i2c-davinci.h  |    0
>  .../linux/platform_data/keyscan-davinci.h                    |    0
>  .../mach/mmc.h => include/linux/platform_data/mmc-davinci.h  |    0
>  .../linux/platform_data/mtd-davinci-aemif.h                  |    0
>  .../mach/nand.h => include/linux/platform_data/mtd-davinci.h |    0
>  .../mach/spi.h => include/linux/platform_data/spi-davinci.h  |    0
>  .../mach/usb.h => include/linux/platform_data/usb-davinci.h  |    0
>  sound/soc/davinci/davinci-evm.c                              |    2 +-
>  sound/soc/davinci/davinci-i2s.c                              |    2 +-
>  sound/soc/davinci/davinci-mcasp.h                            |    2 +-
>  sound/soc/davinci/davinci-pcm.h                              |    2 +-
>  40 files changed, 68 insertions(+), 68 deletions(-)
>  rename arch/arm/mach-davinci/include/mach/asp.h => include/linux/platform_data/asoc-davinci-evm.h (100%)
>  rename arch/arm/mach-davinci/include/mach/i2c.h => include/linux/platform_data/i2c-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/keyscan.h => include/linux/platform_data/keyscan-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/mmc.h => include/linux/platform_data/mmc-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/aemif.h => include/linux/platform_data/mtd-davinci-aemif.h (100%)
>  rename arch/arm/mach-davinci/include/mach/nand.h => include/linux/platform_data/mtd-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/spi.h => include/linux/platform_data/spi-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/usb.h => include/linux/platform_data/usb-davinci.h (100%)
> 
> diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
> index 1ce70a9..f091a90 100644
> --- a/arch/arm/mach-davinci/aemif.c
> +++ b/arch/arm/mach-davinci/aemif.c
> @@ -15,7 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/time.h>
>  
> -#include <mach/aemif.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>  
>  /* Timing value configuration */
>  
> diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davinci/board-da830-evm.c
> index 0031864..95b5e10 100644
> --- a/arch/arm/mach-davinci/board-da830-evm.c
> +++ b/arch/arm/mach-davinci/board-da830-evm.c
> @@ -28,11 +28,11 @@
>  
>  #include <mach/cp_intc.h>
>  #include <mach/mux.h>
> -#include <mach/nand.h>
> +#include <linux/platform_data/mtd-davinci.h>
>  #include <mach/da8xx.h>
> -#include <mach/usb.h>
> -#include <mach/aemif.h>
> -#include <mach/spi.h>
> +#include <linux/platform_data/usb-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
> +#include <linux/platform_data/spi-davinci.h>
>  
>  #define DA830_EVM_PHY_ID		""
>  /*
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davinci/board-da850-evm.c
> index 0149fb4..1295e61 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -40,10 +40,10 @@
>  
>  #include <mach/cp_intc.h>
>  #include <mach/da8xx.h>
> -#include <mach/nand.h>
> +#include <linux/platform_data/mtd-davinci.h>
>  #include <mach/mux.h>
> -#include <mach/aemif.h>
> -#include <mach/spi.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
> +#include <linux/platform_data/spi-davinci.h>
>  
>  #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
>  #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davinci/board-dm355-evm.c
> index 1c7b1f4..88ebea8 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -26,11 +26,11 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
> -#include <mach/nand.h>
> -#include <mach/mmc.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/usb-davinci.h>
>  
>  #include "davinci.h"
>  
> diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-davinci/board-dm355-leopard.c
> index 8e77032..2f88103 100644
> --- a/arch/arm/mach-davinci/board-dm355-leopard.c
> +++ b/arch/arm/mach-davinci/board-dm355-leopard.c
> @@ -23,11 +23,11 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
>  
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
> -#include <mach/nand.h>
> -#include <mach/mmc.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/usb-davinci.h>
>  
>  #include "davinci.h"
>  
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davinci/board-dm365-evm.c
> index 688a9c5..1b4a8ad 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -33,11 +33,11 @@
>  
>  #include <mach/mux.h>
>  #include <mach/common.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
> -#include <mach/mmc.h>
> -#include <mach/nand.h>
> -#include <mach/keyscan.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/keyscan-davinci.h>
>  
>  #include <media/tvp514x.h>
>  
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-davinci/board-dm644x-evm.c
> index d34ed55..ca72fc4 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -31,13 +31,13 @@
>  #include <asm/mach/arch.h>
>  
>  #include <mach/common.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
>  #include <mach/mux.h>
> -#include <mach/nand.h>
> -#include <mach/mmc.h>
> -#include <mach/usb.h>
> -#include <mach/aemif.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/usb-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>  
>  #include "davinci.h"
>  
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-davinci/board-dm646x-evm.c
> index 958679a..9944367 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -38,11 +38,11 @@
>  
>  #include <mach/common.h>
>  #include <mach/serial.h>
> -#include <mach/i2c.h>
> -#include <mach/nand.h>
> +#include <linux/platform_data/i2c-davinci.h>
> +#include <linux/platform_data/mtd-davinci.h>
>  #include <mach/clock.h>
>  #include <mach/cdce949.h>
> -#include <mach/aemif.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>  
>  #include "davinci.h"
>  #include "clock.h"
> diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-davinci/board-mityomapl138.c
> index beecde3..43e4a0d 100644
> --- a/arch/arm/mach-davinci/board-mityomapl138.c
> +++ b/arch/arm/mach-davinci/board-mityomapl138.c
> @@ -26,9 +26,9 @@
>  #include <mach/common.h>
>  #include <mach/cp_intc.h>
>  #include <mach/da8xx.h>
> -#include <mach/nand.h>
> +#include <linux/platform_data/mtd-davinci.h>
>  #include <mach/mux.h>
> -#include <mach/spi.h>
> +#include <linux/platform_data/spi-davinci.h>
>  
>  #define MITYOMAPL138_PHY_ID		""
>  
> diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-davinci/board-neuros-osd2.c
> index f6b9fc7..144bf31 100644
> --- a/arch/arm/mach-davinci/board-neuros-osd2.c
> +++ b/arch/arm/mach-davinci/board-neuros-osd2.c
> @@ -31,12 +31,12 @@
>  #include <asm/mach/arch.h>
>  
>  #include <mach/common.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
>  #include <mach/mux.h>
> -#include <mach/nand.h>
> -#include <mach/mmc.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/usb-davinci.h>
>  
>  #include "davinci.h"
>  
> diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci/board-sffsdr.c
> index 9078acf..6957787 100644
> --- a/arch/arm/mach-davinci/board-sffsdr.c
> +++ b/arch/arm/mach-davinci/board-sffsdr.c
> @@ -36,10 +36,10 @@
>  #include <asm/mach/flash.h>
>  
>  #include <mach/common.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
>  #include <mach/mux.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-davinci.h>
>  
>  #include "davinci.h"
>  
> diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davinci.h
> index 8db0fc6..43ddf87 100644
> --- a/arch/arm/mach-davinci/davinci.h
> +++ b/arch/arm/mach-davinci/davinci.h
> @@ -23,8 +23,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/spi/spi.h>
>  
> -#include <mach/asp.h>
> -#include <mach/keyscan.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
> +#include <linux/platform_data/keyscan-davinci.h>
>  #include <mach/hardware.h>
>  
>  #include <media/davinci/vpfe_capture.h>
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devices.c
> index d2f96662..3a42b6f 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -15,12 +15,12 @@
>  #include <linux/io.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/irqs.h>
>  #include <mach/cputype.h>
>  #include <mach/mux.h>
>  #include <mach/edma.h>
> -#include <mach/mmc.h>
> +#include <linux/platform_data/mmc-davinci.h>
>  #include <mach/time.h>
>  
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/dm355.c b/arch/arm/mach-davinci/dm355.c
> index 678cd99..612e403 100644
> --- a/arch/arm/mach-davinci/dm355.c
> +++ b/arch/arm/mach-davinci/dm355.c
> @@ -26,8 +26,8 @@
>  #include <mach/time.h>
>  #include <mach/serial.h>
>  #include <mach/common.h>
> -#include <mach/asp.h>
> -#include <mach/spi.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
> +#include <linux/platform_data/spi-davinci.h>
>  #include <mach/gpio-davinci.h>
>  
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/dm365.c b/arch/arm/mach-davinci/dm365.c
> index a50d49de..ee4b0b0 100644
> --- a/arch/arm/mach-davinci/dm365.c
> +++ b/arch/arm/mach-davinci/dm365.c
> @@ -29,9 +29,9 @@
>  #include <mach/time.h>
>  #include <mach/serial.h>
>  #include <mach/common.h>
> -#include <mach/asp.h>
> -#include <mach/keyscan.h>
> -#include <mach/spi.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
> +#include <linux/platform_data/keyscan-davinci.h>
> +#include <linux/platform_data/spi-davinci.h>
>  #include <mach/gpio-davinci.h>
>  
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644x.c
> index c8b8666..9018a44 100644
> --- a/arch/arm/mach-davinci/dm644x.c
> +++ b/arch/arm/mach-davinci/dm644x.c
> @@ -23,7 +23,7 @@
>  #include <mach/time.h>
>  #include <mach/serial.h>
>  #include <mach/common.h>
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  #include <mach/gpio-davinci.h>
>  
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646x.c
> index 9eb87c1..56f8e6e 100644
> --- a/arch/arm/mach-davinci/dm646x.c
> +++ b/arch/arm/mach-davinci/dm646x.c
> @@ -24,7 +24,7 @@
>  #include <mach/time.h>
>  #include <mach/serial.h>
>  #include <mach/common.h>
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  #include <mach/gpio-davinci.h>
>  
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-davinci/include/mach/da8xx.h
> index a2f1f27..a273d06 100644
> --- a/arch/arm/mach-davinci/include/mach/da8xx.h
> +++ b/arch/arm/mach-davinci/include/mach/da8xx.h
> @@ -19,12 +19,12 @@
>  
>  #include <mach/serial.h>
>  #include <mach/edma.h>
> -#include <mach/i2c.h>
> -#include <mach/asp.h>
> -#include <mach/mmc.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/i2c-davinci.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/usb-davinci.h>
>  #include <mach/pm.h>
> -#include <mach/spi.h>
> +#include <linux/platform_data/spi-davinci.h>
>  
>  extern void __iomem *da8xx_syscfg0_base;
>  extern void __iomem *da8xx_syscfg1_base;
> diff --git a/arch/arm/mach-davinci/include/mach/tnetv107x.h b/arch/arm/mach-davinci/include/mach/tnetv107x.h
> index 83e5926..1656a02 100644
> --- a/arch/arm/mach-davinci/include/mach/tnetv107x.h
> +++ b/arch/arm/mach-davinci/include/mach/tnetv107x.h
> @@ -36,8 +36,8 @@
>  #include <linux/input/matrix_keypad.h>
>  #include <linux/mfd/ti_ssp.h>
>  
> -#include <mach/mmc.h>
> -#include <mach/nand.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/mtd-davinci.h>
>  #include <mach/serial.h>
>  
>  struct tnetv107x_device_info {
> diff --git a/arch/arm/mach-davinci/usb.c b/arch/arm/mach-davinci/usb.c
> index 23d2b6d..f77b953 100644
> --- a/arch/arm/mach-davinci/usb.c
> +++ b/arch/arm/mach-davinci/usb.c
> @@ -10,7 +10,7 @@
>  #include <mach/common.h>
>  #include <mach/irqs.h>
>  #include <mach/cputype.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-davinci.h>
>  
>  #define DAVINCI_USB_OTG_BASE	0x01c64000
>  
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-davinci.c
> index 79b4bcb..79a2542 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -40,7 +40,7 @@
>  #include <linux/gpio.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  
>  /* ----- global defines ----------------------------------------------- */
>  
> diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/keyboard/davinci_keyscan.c
> index 9d82b3a..d5bacbb 100644
> --- a/drivers/input/keyboard/davinci_keyscan.c
> +++ b/drivers/input/keyboard/davinci_keyscan.c
> @@ -36,7 +36,7 @@
>  
>  #include <mach/hardware.h>
>  #include <mach/irqs.h>
> -#include <mach/keyscan.h>
> +#include <linux/platform_data/keyscan-davinci.h>
>  
>  /* Key scan registers */
>  #define DAVINCI_KEYSCAN_KEYCTRL		0x0000
> diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/video/davinci/vpbe_venc.c
> index b21ecc8..0302669 100644
> --- a/drivers/media/video/davinci/vpbe_venc.c
> +++ b/drivers/media/video/davinci/vpbe_venc.c
> @@ -27,7 +27,7 @@
>  
>  #include <mach/hardware.h>
>  #include <mach/mux.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  
>  #include <linux/io.h>
>  
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mmc.c
> index 7cf6c62..3dfd347 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -33,7 +33,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/mmc/mmc.h>
>  
> -#include <mach/mmc.h>
> +#include <linux/platform_data/mmc-davinci.h>
>  #include <mach/edma.h>
>  
>  /*
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_nand.c
> index d94b03c..f1deb1e 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -34,8 +34,8 @@
>  #include <linux/mtd/partitions.h>
>  #include <linux/slab.h>
>  
> -#include <mach/nand.h>
> -#include <mach/aemif.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
>  
>  /*
>   * This is a device driver for the NAND flash controller found on the
> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
> index 9b2901f..3afe2f4 100644
> --- a/drivers/spi/spi-davinci.c
> +++ b/drivers/spi/spi-davinci.c
> @@ -30,7 +30,7 @@
>  #include <linux/spi/spi_bitbang.h>
>  #include <linux/slab.h>
>  
> -#include <mach/spi.h>
> +#include <linux/platform_data/spi-davinci.h>
>  #include <mach/edma.h>
>  
>  #define SPI_NO_RESOURCE		((resource_size_t)-1)
> diff --git a/drivers/usb/host/ohci-da8xx.c b/drivers/usb/host/ohci-da8xx.c
> index 269b1e0..0b815a8 100644
> --- a/drivers/usb/host/ohci-da8xx.c
> +++ b/drivers/usb/host/ohci-da8xx.c
> @@ -17,7 +17,7 @@
>  #include <linux/clk.h>
>  
>  #include <mach/da8xx.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-davinci.h>
>  
>  #ifndef CONFIG_ARCH_DAVINCI_DA8XX
>  #error "This file is DA8xx bus glue.  Define CONFIG_ARCH_DAVINCI_DA8XX."
> diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
> index 0f9fcec..15a2627 100644
> --- a/drivers/usb/musb/da8xx.c
> +++ b/drivers/usb/musb/da8xx.c
> @@ -35,7 +35,7 @@
>  #include <linux/dma-mapping.h>
>  
>  #include <mach/da8xx.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-davinci.h>
>  
>  #include "musb_core.h"
>  
> diff --git a/arch/arm/mach-davinci/include/mach/asp.h b/include/linux/platform_data/asoc-davinci-evm.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/asp.h
> rename to include/linux/platform_data/asoc-davinci-evm.h
> diff --git a/arch/arm/mach-davinci/include/mach/i2c.h b/include/linux/platform_data/i2c-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/i2c.h
> rename to include/linux/platform_data/i2c-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/keyscan.h b/include/linux/platform_data/keyscan-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/keyscan.h
> rename to include/linux/platform_data/keyscan-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/mmc.h b/include/linux/platform_data/mmc-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/mmc.h
> rename to include/linux/platform_data/mmc-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/aemif.h b/include/linux/platform_data/mtd-davinci-aemif.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/aemif.h
> rename to include/linux/platform_data/mtd-davinci-aemif.h
> diff --git a/arch/arm/mach-davinci/include/mach/nand.h b/include/linux/platform_data/mtd-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/nand.h
> rename to include/linux/platform_data/mtd-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/spi.h b/include/linux/platform_data/spi-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/spi.h
> rename to include/linux/platform_data/spi-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/usb.h b/include/linux/platform_data/usb-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/usb.h
> rename to include/linux/platform_data/usb-davinci.h
> diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-evm.c
> index 10a2d8c..5717bed 100644
> --- a/sound/soc/davinci/davinci-evm.c
> +++ b/sound/soc/davinci/davinci-evm.c
> @@ -22,7 +22,7 @@
>  #include <asm/dma.h>
>  #include <asm/mach-types.h>
>  
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  #include <mach/edma.h>
>  #include <mach/mux.h>
>  
> diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-i2s.c
> index 0a74b95..6e58828 100644
> --- a/sound/soc/davinci/davinci-i2s.c
> +++ b/sound/soc/davinci/davinci-i2s.c
> @@ -23,7 +23,7 @@
>  #include <sound/initval.h>
>  #include <sound/soc.h>
>  
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  
>  #include "davinci-pcm.h"
>  #include "davinci-i2s.h"
> diff --git a/sound/soc/davinci/davinci-mcasp.h b/sound/soc/davinci/davinci-mcasp.h
> index 4681acc..302aab2 100644
> --- a/sound/soc/davinci/davinci-mcasp.h
> +++ b/sound/soc/davinci/davinci-mcasp.h
> @@ -19,7 +19,7 @@
>  #define DAVINCI_MCASP_H
>  
>  #include <linux/io.h>
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  #include "davinci-pcm.h"
>  
>  #define DAVINCI_MCASP_RATES	SNDRV_PCM_RATE_8000_96000
> diff --git a/sound/soc/davinci/davinci-pcm.h b/sound/soc/davinci/davinci-pcm.h
> index c0d6c9b..36d31cd 100644
> --- a/sound/soc/davinci/davinci-pcm.h
> +++ b/sound/soc/davinci/davinci-pcm.h
> @@ -13,7 +13,7 @@
>  #define _DAVINCI_PCM_H
>  
>  #include <mach/edma.h>
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  
>  
>  struct davinci_pcm_dma_params {
> -- 
> 1.7.10
> 
> _______________________________________________
> Davinci-linux-open-source mailing list
> Davinci-linux-open-source@linux.davincidsp.com
> http://linux.davincidsp.com/mailman/listinfo/davinci-linux-open-source
> 


Regards, 
Gururaja
