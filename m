Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756843Ab2IKNJ5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:09:57 -0400
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:51362 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752737Ab2IKNJz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:09:55 -0400
Date: Tue, 11 Sep 2012 16:05:22 +0300
From: Felipe Balbi <balbi@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>, Sekhar Nori <nsekhar@ti.com>,
        Kevin Hilman <khilman@ti.com>, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        Chris Ball <cjb@laptop.org>, David Woodhouse <dwmw2@infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Felipe Balbi <balbi@ti.com>, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        davinci-linux-open-source@linux.davincidsp.com
Subject: Re: [PATCH 02/16] ARM: davinci: move platform_data definitions
Message-ID: <20120911130519.GW18907@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-2-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ByM1h5nouWwd3kz8"
Content-Disposition: inline
In-Reply-To: <1347368390-31252-2-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ByM1h5nouWwd3kz8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 11, 2012 at 02:59:36PM +0200, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
>=20
> This moves such data out of the davinci include directories
>=20
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sekhar Nori <nsekhar@ti.com>
> Cc: Kevin Hilman <khilman@ti.com>
> Cc: "Ben Dooks" <ben-linux@fluff.org>
> Cc: "Wolfram Sang" <w.sang@pengutronix.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: davinci-linux-open-source@linux.davincidsp.com

for musb:

Acked-by: Felipe Balbi <balbi@ti.com>

> ---
>  arch/arm/mach-davinci/aemif.c                                |    2 +-
>  arch/arm/mach-davinci/board-da830-evm.c                      |    8 ++++=
----
>  arch/arm/mach-davinci/board-da850-evm.c                      |    6 +++-=
--
>  arch/arm/mach-davinci/board-dm355-evm.c                      |    8 ++++=
----
>  arch/arm/mach-davinci/board-dm355-leopard.c                  |    8 ++++=
----
>  arch/arm/mach-davinci/board-dm365-evm.c                      |    8 ++++=
----
>  arch/arm/mach-davinci/board-dm644x-evm.c                     |   10 ++++=
+-----
>  arch/arm/mach-davinci/board-dm646x-evm.c                     |    6 +++-=
--
>  arch/arm/mach-davinci/board-mityomapl138.c                   |    4 ++--
>  arch/arm/mach-davinci/board-neuros-osd2.c                    |    8 ++++=
----
>  arch/arm/mach-davinci/board-sffsdr.c                         |    4 ++--
>  arch/arm/mach-davinci/davinci.h                              |    4 ++--
>  arch/arm/mach-davinci/devices.c                              |    4 ++--
>  arch/arm/mach-davinci/dm355.c                                |    4 ++--
>  arch/arm/mach-davinci/dm365.c                                |    6 +++-=
--
>  arch/arm/mach-davinci/dm644x.c                               |    2 +-
>  arch/arm/mach-davinci/dm646x.c                               |    2 +-
>  arch/arm/mach-davinci/include/mach/da8xx.h                   |   10 ++++=
+-----
>  arch/arm/mach-davinci/include/mach/tnetv107x.h               |    4 ++--
>  arch/arm/mach-davinci/usb.c                                  |    2 +-
>  drivers/i2c/busses/i2c-davinci.c                             |    2 +-
>  drivers/input/keyboard/davinci_keyscan.c                     |    2 +-
>  drivers/media/video/davinci/vpbe_venc.c                      |    2 +-
>  drivers/mmc/host/davinci_mmc.c                               |    2 +-
>  drivers/mtd/nand/davinci_nand.c                              |    4 ++--
>  drivers/spi/spi-davinci.c                                    |    2 +-
>  drivers/usb/host/ohci-da8xx.c                                |    2 +-
>  drivers/usb/musb/da8xx.c                                     |    2 +-
>  .../asp.h =3D> include/linux/platform_data/asoc-davinci-evm.h  |    0
>  .../mach/i2c.h =3D> include/linux/platform_data/i2c-davinci.h  |    0
>  .../linux/platform_data/keyscan-davinci.h                    |    0
>  .../mach/mmc.h =3D> include/linux/platform_data/mmc-davinci.h  |    0
>  .../linux/platform_data/mtd-davinci-aemif.h                  |    0
>  .../mach/nand.h =3D> include/linux/platform_data/mtd-davinci.h |    0
>  .../mach/spi.h =3D> include/linux/platform_data/spi-davinci.h  |    0
>  .../mach/usb.h =3D> include/linux/platform_data/usb-davinci.h  |    0
>  sound/soc/davinci/davinci-evm.c                              |    2 +-
>  sound/soc/davinci/davinci-i2s.c                              |    2 +-
>  sound/soc/davinci/davinci-mcasp.h                            |    2 +-
>  sound/soc/davinci/davinci-pcm.h                              |    2 +-
>  40 files changed, 68 insertions(+), 68 deletions(-)
>  rename arch/arm/mach-davinci/include/mach/asp.h =3D> include/linux/platf=
orm_data/asoc-davinci-evm.h (100%)
>  rename arch/arm/mach-davinci/include/mach/i2c.h =3D> include/linux/platf=
orm_data/i2c-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/keyscan.h =3D> include/linux/p=
latform_data/keyscan-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/mmc.h =3D> include/linux/platf=
orm_data/mmc-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/aemif.h =3D> include/linux/pla=
tform_data/mtd-davinci-aemif.h (100%)
>  rename arch/arm/mach-davinci/include/mach/nand.h =3D> include/linux/plat=
form_data/mtd-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/spi.h =3D> include/linux/platf=
orm_data/spi-davinci.h (100%)
>  rename arch/arm/mach-davinci/include/mach/usb.h =3D> include/linux/platf=
orm_data/usb-davinci.h (100%)
>=20
> diff --git a/arch/arm/mach-davinci/aemif.c b/arch/arm/mach-davinci/aemif.c
> index 1ce70a9..f091a90 100644
> --- a/arch/arm/mach-davinci/aemif.c
> +++ b/arch/arm/mach-davinci/aemif.c
> @@ -15,7 +15,7 @@
>  #include <linux/module.h>
>  #include <linux/time.h>
> =20
> -#include <mach/aemif.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
> =20
>  /* Timing value configuration */
> =20
> diff --git a/arch/arm/mach-davinci/board-da830-evm.c b/arch/arm/mach-davi=
nci/board-da830-evm.c
> index 0031864..95b5e10 100644
> --- a/arch/arm/mach-davinci/board-da830-evm.c
> +++ b/arch/arm/mach-davinci/board-da830-evm.c
> @@ -28,11 +28,11 @@
> =20
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
> =20
>  #define DA830_EVM_PHY_ID		""
>  /*
> diff --git a/arch/arm/mach-davinci/board-da850-evm.c b/arch/arm/mach-davi=
nci/board-da850-evm.c
> index 0149fb4..1295e61 100644
> --- a/arch/arm/mach-davinci/board-da850-evm.c
> +++ b/arch/arm/mach-davinci/board-da850-evm.c
> @@ -40,10 +40,10 @@
> =20
>  #include <mach/cp_intc.h>
>  #include <mach/da8xx.h>
> -#include <mach/nand.h>
> +#include <linux/platform_data/mtd-davinci.h>
>  #include <mach/mux.h>
> -#include <mach/aemif.h>
> -#include <mach/spi.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
> +#include <linux/platform_data/spi-davinci.h>
> =20
>  #define DA850_EVM_PHY_ID		"davinci_mdio-0:00"
>  #define DA850_LCD_PWR_PIN		GPIO_TO_PIN(2, 8)
> diff --git a/arch/arm/mach-davinci/board-dm355-evm.c b/arch/arm/mach-davi=
nci/board-dm355-evm.c
> index 1c7b1f4..88ebea8 100644
> --- a/arch/arm/mach-davinci/board-dm355-evm.c
> +++ b/arch/arm/mach-davinci/board-dm355-evm.c
> @@ -26,11 +26,11 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> =20
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
> -#include <mach/nand.h>
> -#include <mach/mmc.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/usb-davinci.h>
> =20
>  #include "davinci.h"
> =20
> diff --git a/arch/arm/mach-davinci/board-dm355-leopard.c b/arch/arm/mach-=
davinci/board-dm355-leopard.c
> index 8e77032..2f88103 100644
> --- a/arch/arm/mach-davinci/board-dm355-leopard.c
> +++ b/arch/arm/mach-davinci/board-dm355-leopard.c
> @@ -23,11 +23,11 @@
>  #include <asm/mach-types.h>
>  #include <asm/mach/arch.h>
> =20
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
> -#include <mach/nand.h>
> -#include <mach/mmc.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/usb-davinci.h>
> =20
>  #include "davinci.h"
> =20
> diff --git a/arch/arm/mach-davinci/board-dm365-evm.c b/arch/arm/mach-davi=
nci/board-dm365-evm.c
> index 688a9c5..1b4a8ad 100644
> --- a/arch/arm/mach-davinci/board-dm365-evm.c
> +++ b/arch/arm/mach-davinci/board-dm365-evm.c
> @@ -33,11 +33,11 @@
> =20
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
> =20
>  #include <media/tvp514x.h>
> =20
> diff --git a/arch/arm/mach-davinci/board-dm644x-evm.c b/arch/arm/mach-dav=
inci/board-dm644x-evm.c
> index d34ed55..ca72fc4 100644
> --- a/arch/arm/mach-davinci/board-dm644x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm644x-evm.c
> @@ -31,13 +31,13 @@
>  #include <asm/mach/arch.h>
> =20
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
> =20
>  #include "davinci.h"
> =20
> diff --git a/arch/arm/mach-davinci/board-dm646x-evm.c b/arch/arm/mach-dav=
inci/board-dm646x-evm.c
> index 958679a..9944367 100644
> --- a/arch/arm/mach-davinci/board-dm646x-evm.c
> +++ b/arch/arm/mach-davinci/board-dm646x-evm.c
> @@ -38,11 +38,11 @@
> =20
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
> =20
>  #include "davinci.h"
>  #include "clock.h"
> diff --git a/arch/arm/mach-davinci/board-mityomapl138.c b/arch/arm/mach-d=
avinci/board-mityomapl138.c
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
> =20
>  #define MITYOMAPL138_PHY_ID		""
> =20
> diff --git a/arch/arm/mach-davinci/board-neuros-osd2.c b/arch/arm/mach-da=
vinci/board-neuros-osd2.c
> index f6b9fc7..144bf31 100644
> --- a/arch/arm/mach-davinci/board-neuros-osd2.c
> +++ b/arch/arm/mach-davinci/board-neuros-osd2.c
> @@ -31,12 +31,12 @@
>  #include <asm/mach/arch.h>
> =20
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
> =20
>  #include "davinci.h"
> =20
> diff --git a/arch/arm/mach-davinci/board-sffsdr.c b/arch/arm/mach-davinci=
/board-sffsdr.c
> index 9078acf..6957787 100644
> --- a/arch/arm/mach-davinci/board-sffsdr.c
> +++ b/arch/arm/mach-davinci/board-sffsdr.c
> @@ -36,10 +36,10 @@
>  #include <asm/mach/flash.h>
> =20
>  #include <mach/common.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
>  #include <mach/serial.h>
>  #include <mach/mux.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-davinci.h>
> =20
>  #include "davinci.h"
> =20
> diff --git a/arch/arm/mach-davinci/davinci.h b/arch/arm/mach-davinci/davi=
nci.h
> index 8db0fc6..43ddf87 100644
> --- a/arch/arm/mach-davinci/davinci.h
> +++ b/arch/arm/mach-davinci/davinci.h
> @@ -23,8 +23,8 @@
>  #include <linux/platform_device.h>
>  #include <linux/spi/spi.h>
> =20
> -#include <mach/asp.h>
> -#include <mach/keyscan.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
> +#include <linux/platform_data/keyscan-davinci.h>
>  #include <mach/hardware.h>
> =20
>  #include <media/davinci/vpfe_capture.h>
> diff --git a/arch/arm/mach-davinci/devices.c b/arch/arm/mach-davinci/devi=
ces.c
> index d2f96662..3a42b6f 100644
> --- a/arch/arm/mach-davinci/devices.c
> +++ b/arch/arm/mach-davinci/devices.c
> @@ -15,12 +15,12 @@
>  #include <linux/io.h>
> =20
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
> =20
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
> =20
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
> =20
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/dm644x.c b/arch/arm/mach-davinci/dm644=
x.c
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
> =20
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/dm646x.c b/arch/arm/mach-davinci/dm646=
x.c
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
> =20
>  #include "davinci.h"
> diff --git a/arch/arm/mach-davinci/include/mach/da8xx.h b/arch/arm/mach-d=
avinci/include/mach/da8xx.h
> index a2f1f27..a273d06 100644
> --- a/arch/arm/mach-davinci/include/mach/da8xx.h
> +++ b/arch/arm/mach-davinci/include/mach/da8xx.h
> @@ -19,12 +19,12 @@
> =20
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
> =20
>  extern void __iomem *da8xx_syscfg0_base;
>  extern void __iomem *da8xx_syscfg1_base;
> diff --git a/arch/arm/mach-davinci/include/mach/tnetv107x.h b/arch/arm/ma=
ch-davinci/include/mach/tnetv107x.h
> index 83e5926..1656a02 100644
> --- a/arch/arm/mach-davinci/include/mach/tnetv107x.h
> +++ b/arch/arm/mach-davinci/include/mach/tnetv107x.h
> @@ -36,8 +36,8 @@
>  #include <linux/input/matrix_keypad.h>
>  #include <linux/mfd/ti_ssp.h>
> =20
> -#include <mach/mmc.h>
> -#include <mach/nand.h>
> +#include <linux/platform_data/mmc-davinci.h>
> +#include <linux/platform_data/mtd-davinci.h>
>  #include <mach/serial.h>
> =20
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
> =20
>  #define DAVINCI_USB_OTG_BASE	0x01c64000
> =20
> diff --git a/drivers/i2c/busses/i2c-davinci.c b/drivers/i2c/busses/i2c-da=
vinci.c
> index 79b4bcb..79a2542 100644
> --- a/drivers/i2c/busses/i2c-davinci.c
> +++ b/drivers/i2c/busses/i2c-davinci.c
> @@ -40,7 +40,7 @@
>  #include <linux/gpio.h>
> =20
>  #include <mach/hardware.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
> =20
>  /* ----- global defines ----------------------------------------------- =
*/
> =20
> diff --git a/drivers/input/keyboard/davinci_keyscan.c b/drivers/input/key=
board/davinci_keyscan.c
> index 9d82b3a..d5bacbb 100644
> --- a/drivers/input/keyboard/davinci_keyscan.c
> +++ b/drivers/input/keyboard/davinci_keyscan.c
> @@ -36,7 +36,7 @@
> =20
>  #include <mach/hardware.h>
>  #include <mach/irqs.h>
> -#include <mach/keyscan.h>
> +#include <linux/platform_data/keyscan-davinci.h>
> =20
>  /* Key scan registers */
>  #define DAVINCI_KEYSCAN_KEYCTRL		0x0000
> diff --git a/drivers/media/video/davinci/vpbe_venc.c b/drivers/media/vide=
o/davinci/vpbe_venc.c
> index b21ecc8..0302669 100644
> --- a/drivers/media/video/davinci/vpbe_venc.c
> +++ b/drivers/media/video/davinci/vpbe_venc.c
> @@ -27,7 +27,7 @@
> =20
>  #include <mach/hardware.h>
>  #include <mach/mux.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-davinci.h>
> =20
>  #include <linux/io.h>
> =20
> diff --git a/drivers/mmc/host/davinci_mmc.c b/drivers/mmc/host/davinci_mm=
c.c
> index 7cf6c62..3dfd347 100644
> --- a/drivers/mmc/host/davinci_mmc.c
> +++ b/drivers/mmc/host/davinci_mmc.c
> @@ -33,7 +33,7 @@
>  #include <linux/dma-mapping.h>
>  #include <linux/mmc/mmc.h>
> =20
> -#include <mach/mmc.h>
> +#include <linux/platform_data/mmc-davinci.h>
>  #include <mach/edma.h>
> =20
>  /*
> diff --git a/drivers/mtd/nand/davinci_nand.c b/drivers/mtd/nand/davinci_n=
and.c
> index d94b03c..f1deb1e 100644
> --- a/drivers/mtd/nand/davinci_nand.c
> +++ b/drivers/mtd/nand/davinci_nand.c
> @@ -34,8 +34,8 @@
>  #include <linux/mtd/partitions.h>
>  #include <linux/slab.h>
> =20
> -#include <mach/nand.h>
> -#include <mach/aemif.h>
> +#include <linux/platform_data/mtd-davinci.h>
> +#include <linux/platform_data/mtd-davinci-aemif.h>
> =20
>  /*
>   * This is a device driver for the NAND flash controller found on the
> diff --git a/drivers/spi/spi-davinci.c b/drivers/spi/spi-davinci.c
> index 9b2901f..3afe2f4 100644
> --- a/drivers/spi/spi-davinci.c
> +++ b/drivers/spi/spi-davinci.c
> @@ -30,7 +30,7 @@
>  #include <linux/spi/spi_bitbang.h>
>  #include <linux/slab.h>
> =20
> -#include <mach/spi.h>
> +#include <linux/platform_data/spi-davinci.h>
>  #include <mach/edma.h>
> =20
>  #define SPI_NO_RESOURCE		((resource_size_t)-1)
> diff --git a/drivers/usb/host/ohci-da8xx.c b/drivers/usb/host/ohci-da8xx.c
> index 269b1e0..0b815a8 100644
> --- a/drivers/usb/host/ohci-da8xx.c
> +++ b/drivers/usb/host/ohci-da8xx.c
> @@ -17,7 +17,7 @@
>  #include <linux/clk.h>
> =20
>  #include <mach/da8xx.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-davinci.h>
> =20
>  #ifndef CONFIG_ARCH_DAVINCI_DA8XX
>  #error "This file is DA8xx bus glue.  Define CONFIG_ARCH_DAVINCI_DA8XX."
> diff --git a/drivers/usb/musb/da8xx.c b/drivers/usb/musb/da8xx.c
> index 0f9fcec..15a2627 100644
> --- a/drivers/usb/musb/da8xx.c
> +++ b/drivers/usb/musb/da8xx.c
> @@ -35,7 +35,7 @@
>  #include <linux/dma-mapping.h>
> =20
>  #include <mach/da8xx.h>
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-davinci.h>
> =20
>  #include "musb_core.h"
> =20
> diff --git a/arch/arm/mach-davinci/include/mach/asp.h b/include/linux/pla=
tform_data/asoc-davinci-evm.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/asp.h
> rename to include/linux/platform_data/asoc-davinci-evm.h
> diff --git a/arch/arm/mach-davinci/include/mach/i2c.h b/include/linux/pla=
tform_data/i2c-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/i2c.h
> rename to include/linux/platform_data/i2c-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/keyscan.h b/include/linux=
/platform_data/keyscan-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/keyscan.h
> rename to include/linux/platform_data/keyscan-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/mmc.h b/include/linux/pla=
tform_data/mmc-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/mmc.h
> rename to include/linux/platform_data/mmc-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/aemif.h b/include/linux/p=
latform_data/mtd-davinci-aemif.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/aemif.h
> rename to include/linux/platform_data/mtd-davinci-aemif.h
> diff --git a/arch/arm/mach-davinci/include/mach/nand.h b/include/linux/pl=
atform_data/mtd-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/nand.h
> rename to include/linux/platform_data/mtd-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/spi.h b/include/linux/pla=
tform_data/spi-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/spi.h
> rename to include/linux/platform_data/spi-davinci.h
> diff --git a/arch/arm/mach-davinci/include/mach/usb.h b/include/linux/pla=
tform_data/usb-davinci.h
> similarity index 100%
> rename from arch/arm/mach-davinci/include/mach/usb.h
> rename to include/linux/platform_data/usb-davinci.h
> diff --git a/sound/soc/davinci/davinci-evm.c b/sound/soc/davinci/davinci-=
evm.c
> index 10a2d8c..5717bed 100644
> --- a/sound/soc/davinci/davinci-evm.c
> +++ b/sound/soc/davinci/davinci-evm.c
> @@ -22,7 +22,7 @@
>  #include <asm/dma.h>
>  #include <asm/mach-types.h>
> =20
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  #include <mach/edma.h>
>  #include <mach/mux.h>
> =20
> diff --git a/sound/soc/davinci/davinci-i2s.c b/sound/soc/davinci/davinci-=
i2s.c
> index 0a74b95..6e58828 100644
> --- a/sound/soc/davinci/davinci-i2s.c
> +++ b/sound/soc/davinci/davinci-i2s.c
> @@ -23,7 +23,7 @@
>  #include <sound/initval.h>
>  #include <sound/soc.h>
> =20
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
> =20
>  #include "davinci-pcm.h"
>  #include "davinci-i2s.h"
> diff --git a/sound/soc/davinci/davinci-mcasp.h b/sound/soc/davinci/davinc=
i-mcasp.h
> index 4681acc..302aab2 100644
> --- a/sound/soc/davinci/davinci-mcasp.h
> +++ b/sound/soc/davinci/davinci-mcasp.h
> @@ -19,7 +19,7 @@
>  #define DAVINCI_MCASP_H
> =20
>  #include <linux/io.h>
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
>  #include "davinci-pcm.h"
> =20
>  #define DAVINCI_MCASP_RATES	SNDRV_PCM_RATE_8000_96000
> diff --git a/sound/soc/davinci/davinci-pcm.h b/sound/soc/davinci/davinci-=
pcm.h
> index c0d6c9b..36d31cd 100644
> --- a/sound/soc/davinci/davinci-pcm.h
> +++ b/sound/soc/davinci/davinci-pcm.h
> @@ -13,7 +13,7 @@
>  #define _DAVINCI_PCM_H
> =20
>  #include <mach/edma.h>
> -#include <mach/asp.h>
> +#include <linux/platform_data/asoc-davinci-evm.h>
> =20
> =20
>  struct davinci_pcm_dma_params {
> --=20
> 1.7.10
>=20

--=20
balbi

--ByM1h5nouWwd3kz8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQTzcPAAoJEIaOsuA1yqREY40QAICG3q8G0DlF8u4pDV1I6NLI
nH7NI/J8nWzTxT74lcL0FFy9Vq7g8kIFdQANVrz/qRAepuBQR1Et39ulLEqc1pYz
af3LnmsaGrRdxMMKYZl+Qjb0ecX5jbVtk0dPuWAWKP1ED/oazolqy45lfoq5rD9m
mosaJXGopljQWPV26Uh9bPiHp/PZ6hSJpf3iJO+t4p/qowCeBA3Rm7Ud6Y3eoagU
7QiZz6RBciVxdB0rPil7wSoQZRMl20Ir5EecUh2KbM4RA//H6ANnYCfFdAJdtgDf
KG+ps49AeRvd1dYzcmQYWTw5LTS0Yf+2sPUfqatMOOi8/3n7HRRU64kM2+SvAOSJ
xoZgBkWkuimRT6wSa6P7tvBdrUqHPiykJVXUVtEZc6oCQwXsx0mgCFXhxxQMJzvc
EZkWG/8hEh2mBNadLXOE3f+J3rNnj1HQkqi9NzCdOPLzY07kL1DFwVgp3B7wlWVd
0xkLA+ke84FUc79j6Jfy3X+/Z9CWwYLgmFWjDbFvPNURv6XgeOSWE7SQVBFYSl09
d7GBU/S1O2iyyAtnVlIqfiOGHMvGTSpXJkgqCEFhUSY8TPbe/YRr+wt1/HP+NGOz
m5+SOifn5V5RrMm2adlpUw08oYMhNZXleNaLokn/g8J3K+CN777r36XLUwju1dhv
ckGpXqo2fIJWM2NLgBsL
=NULj
-----END PGP SIGNATURE-----

--ByM1h5nouWwd3kz8--
