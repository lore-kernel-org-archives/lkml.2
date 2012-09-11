Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2IKQ1L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 12:27:11 -0400
Received: from mail127.messagelabs.com ([216.82.250.115]:37000 "EHLO
	mail127.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754040Ab2IKQ1G convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 12:27:06 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-4.tower-127.messagelabs.com!1347380825!7433225!1
X-Originating-IP: [216.166.12.69]
X-StarScan-Received: 
X-StarScan-Version: 6.6.1.3; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>,
        Grant Likely <grant.likely@secretlab.ca>,
        Ryan Mallon <rmallon@gmail.com>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        Axel Lin <axel.lin@gmail.com>
Date: Tue, 11 Sep 2012 11:26:55 -0500
Subject: RE: [PATCH 03/16] ARM: ep93xx: move platform_data definitions
Thread-Topic: [PATCH 03/16] ARM: ep93xx: move platform_data definitions
Thread-Index: Ac2QHWDWQ0uA0PxuSN6WoAjCza1e+wAHD7OA
Message-ID: <ADE657CA350FB648AAC2C43247A983F00206B1EB884D@AUSP01VMBX24.collaborationhost.net>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-3-git-send-email-arnd@arndb.de>
In-Reply-To: <1347368390-31252-3-git-send-email-arnd@arndb.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, September 11, 2012 6:00 AM, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
>
> This moves such data out of the ep93xx include directories
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Hartley Sweeten <hsweeten@visionengravers.com>
> Cc: Ryan Mallon <rmallon@gmail.com>
> Cc: Jeff Garzik <jgarzik@pobox.com> (supporter:SERIAL ATA
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com> (maintainer:INPUT
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Jaroslav Kysela <perex@perex.cz>
> Cc: Takashi Iwai <tiwai@suse.de>
> Cc: Mika Westerberg <mika.westerberg@iki.fi>
> Cc: Axel Lin <axel.lin@gmail.com>
> ---
>  Documentation/spi/ep93xx_spi                                     |    2 +-
>  arch/arm/mach-ep93xx/core.c                                      |    6 +++---
>  arch/arm/mach-ep93xx/dma.c                                       |    2 +-
>  arch/arm/mach-ep93xx/edb93xx.c                                   |    4 ++--
>  arch/arm/mach-ep93xx/simone.c                                    |    2 +-
>  arch/arm/mach-ep93xx/snappercl15.c                               |    2 +-
>  arch/arm/mach-ep93xx/vision_ep9307.c                             |    4 ++--
>  drivers/ata/pata_ep93xx.c                                        |    2 +-
>  drivers/dma/ep93xx_dma.c                                         |    2 +-
>  drivers/input/keyboard/ep93xx_keypad.c                           |    2 +-
>  drivers/spi/spi-ep93xx.c                                         |    4 ++--
>  drivers/video/ep93xx-fb.c                                        |    2 +-
>  .../mach/dma.h => include/linux/platform_data/dma-ep93xx.h       |    0
>  .../linux/platform_data/keypad-ep93xx.h                          |    0
>  .../ep93xx_spi.h => include/linux/platform_data/spi-ep93xx.h     |    0
>  .../mach/fb.h => include/linux/platform_data/video-ep93xx.h      |    0
>  sound/soc/ep93xx/ep93xx-ac97.c                                   |    2 +-
>  sound/soc/ep93xx/ep93xx-i2s.c                                    |    2 +-
>  sound/soc/ep93xx/ep93xx-pcm.c                                    |    2 +-
>  19 files changed, 20 insertions(+), 20 deletions(-)
>  rename arch/arm/mach-ep93xx/include/mach/dma.h => include/linux/platform_data/dma-ep93xx.h (100%)
>  rename arch/arm/mach-ep93xx/include/mach/ep93xx_keypad.h => include/linux/platform_data/keypad-ep93xx.h (100%)
>  rename arch/arm/mach-ep93xx/include/mach/ep93xx_spi.h => include/linux/platform_data/spi-ep93xx.h (100%)
>  rename arch/arm/mach-ep93xx/include/mach/fb.h => include/linux/platform_data/video-ep93xx.h (100%)

Acked-by: H Hartley Sweeten <hsweeten@visionengravers.com>

Arnd,

What about gpio-ep93xx.h? It does not have any platform_data in
it but the gpio driver (driver/gpio/gpio-ep93xx.c) does include it
from the mach-* directory.

Regards,
Hartley

