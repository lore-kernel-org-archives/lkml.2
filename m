Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757422Ab2IKNq0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 09:46:26 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:60084 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753406Ab2IKNqY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 09:46:24 -0400
Date: Tue, 11 Sep 2012 15:45:27 +0200
From: Sascha Hauer <s.hauer@pengutronix.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org,
        "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Alan Stern <stern@rowland.harvard.edu>, Chris Ball <cjb@laptop.org>,
        Liam Girdwood <lrg@ti.com>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Alan Cox <alan@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Javier Martin <javier.martin@vista-silicon.com>,
        Sascha Hauer <kernel@pengutronix.de>, Dan Williams <djbw@fb.com>,
        Shawn Guo <shawn.guo@linaro.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: [PATCH 04/16] ARM: imx: move platform_data definitions
Message-ID: <20120911134527.GB27244@pengutronix.de>
References: <1347368350-31212-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-1-git-send-email-arnd@arndb.de>
 <1347368390-31252-4-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347368390-31252-4-git-send-email-arnd@arndb.de>
X-Sent-From: Pengutronix Hildesheim
X-URL: http://www.pengutronix.de/
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 15:42:32 up 80 days,  4:54, 90 users,  load average: 29.33, 24.38,
 13.92
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: sha@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 02:59:38PM +0200, Arnd Bergmann wrote:
> Platform data for device drivers should be defined in
> include/linux/platform_data/*.h, not in the architecture
> and platform specific directories.
> 
> This moves such data out of the imx include directories
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Sascha Hauer <kernel@pengutronix.de>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Vinod Koul <vinod.koul@intel.com>
> Cc: Dan Williams <djbw@fb.com>
> Cc: "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>
> Cc: "Wolfram Sang (embedded platforms)" <w.sang@pengutronix.de>
> Cc: Mauro Carvalho Chehab <mchehab@infradead.org>
> Cc: Chris Ball <cjb@laptop.org>
> Cc: David Woodhouse <dwmw2@infradead.org>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: Felipe Balbi <balbi@ti.com>
> Cc: Alan Stern <stern@rowland.harvard.edu>
> Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
> Cc: Liam Girdwood <lrg@ti.com>
> Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Cc: Javier Martin <javier.martin@vista-silicon.com>
> Cc: Shawn Guo <shawn.guo@linaro.org>
> Cc: Guennadi Liakhovetski <g.liakhovetski@gmx.de>

Acked-by: Sascha Hauer <s.hauer@pengutronix.de>

Both i.MX defconfigs still compile.

Sascha

> ---
>  arch/arm/mach-imx/ehci-imx25.c                     |    2 +-
>  arch/arm/mach-imx/ehci-imx27.c                     |    2 +-
>  arch/arm/mach-imx/ehci-imx31.c                     |    2 +-
>  arch/arm/mach-imx/ehci-imx35.c                     |    2 +-
>  arch/arm/mach-imx/ehci-imx5.c                      |    2 +-
>  arch/arm/mach-imx/mach-mx31moboard.c               |    2 +-
>  arch/arm/mach-imx/mx1-camera-fiq-ksym.c            |    2 +-
>  .../plat-mxc/devices/platform-sdhci-esdhc-imx.c    |    2 +-
>  arch/arm/plat-mxc/include/mach/devices-common.h    |   32 ++++++++++----------
>  arch/arm/plat-mxc/ssi-fiq-ksym.c                   |    2 +-
>  drivers/dma/imx-dma.c                              |    2 +-
>  drivers/dma/imx-sdma.c                             |    4 +--
>  drivers/i2c/busses/i2c-imx.c                       |    2 +-
>  drivers/media/video/mx1_camera.c                   |    2 +-
>  drivers/media/video/mx2_camera.c                   |    2 +-
>  drivers/media/video/mx3_camera.c                   |    4 +--
>  drivers/mmc/host/mxcmmc.c                          |    4 +--
>  drivers/mmc/host/sdhci-esdhc-imx.c                 |    2 +-
>  drivers/mtd/nand/mxc_nand.c                        |    2 +-
>  drivers/spi/spi-imx.c                              |    2 +-
>  drivers/tty/serial/imx.c                           |    2 +-
>  drivers/usb/gadget/imx_udc.c                       |    2 +-
>  drivers/usb/host/ehci-mxc.c                        |    2 +-
>  drivers/usb/host/imx21-hcd.h                       |    2 +-
>  drivers/video/imxfb.c                              |    2 +-
>  drivers/video/mx3fb.c                              |    4 +--
>  .../linux/platform_data/asoc-imx-ssi.h             |    0
>  .../linux/platform_data/camera-mx1.h               |    0
>  .../linux/platform_data/camera-mx2.h               |    0
>  .../linux/platform_data/camera-mx3.h               |    0
>  .../linux/platform_data/dma-imx-sdma.h             |    0
>  .../dma.h => include/linux/platform_data/dma-imx.h |    0
>  .../i2c.h => include/linux/platform_data/i2c-imx.h |    0
>  .../linux/platform_data/mmc-esdhc-imx.h            |    0
>  .../linux/platform_data/mmc-mxcmmc.h               |    0
>  .../linux/platform_data/mtd-mxc_nand.h             |    0
>  .../linux/platform_data/serial-imx.h               |    0
>  .../spi.h => include/linux/platform_data/spi-imx.h |    0
>  .../linux/platform_data/usb-ehci-mxc.h             |    0
>  .../linux/platform_data/usb-imx_udc.h              |    0
>  .../linux/platform_data/usb-mx2.h                  |    0
>  .../linux/platform_data/video-imxfb.h              |    0
>  .../linux/platform_data/video-mx3fb.h              |    0
>  sound/soc/fsl/imx-pcm-dma.c                        |    2 +-
>  sound/soc/fsl/imx-pcm-fiq.c                        |    2 +-
>  sound/soc/fsl/imx-ssi.c                            |    2 +-
>  sound/soc/fsl/imx-ssi.h                            |    2 +-
>  47 files changed, 49 insertions(+), 49 deletions(-)
>  rename arch/arm/plat-mxc/include/mach/ssi.h => include/linux/platform_data/asoc-imx-ssi.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mx1_camera.h => include/linux/platform_data/camera-mx1.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mx2_cam.h => include/linux/platform_data/camera-mx2.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mx3_camera.h => include/linux/platform_data/camera-mx3.h (100%)
>  rename arch/arm/plat-mxc/include/mach/sdma.h => include/linux/platform_data/dma-imx-sdma.h (100%)
>  rename arch/arm/plat-mxc/include/mach/dma.h => include/linux/platform_data/dma-imx.h (100%)
>  rename arch/arm/plat-mxc/include/mach/i2c.h => include/linux/platform_data/i2c-imx.h (100%)
>  rename arch/arm/plat-mxc/include/mach/esdhc.h => include/linux/platform_data/mmc-esdhc-imx.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mmc.h => include/linux/platform_data/mmc-mxcmmc.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mxc_nand.h => include/linux/platform_data/mtd-mxc_nand.h (100%)
>  rename arch/arm/plat-mxc/include/mach/imx-uart.h => include/linux/platform_data/serial-imx.h (100%)
>  rename arch/arm/plat-mxc/include/mach/spi.h => include/linux/platform_data/spi-imx.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mxc_ehci.h => include/linux/platform_data/usb-ehci-mxc.h (100%)
>  rename arch/arm/plat-mxc/include/mach/usb.h => include/linux/platform_data/usb-imx_udc.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mx21-usbhost.h => include/linux/platform_data/usb-mx2.h (100%)
>  rename arch/arm/plat-mxc/include/mach/imxfb.h => include/linux/platform_data/video-imxfb.h (100%)
>  rename arch/arm/plat-mxc/include/mach/mx3fb.h => include/linux/platform_data/video-mx3fb.h (100%)
> 
> diff --git a/arch/arm/mach-imx/ehci-imx25.c b/arch/arm/mach-imx/ehci-imx25.c
> index 05bb41d..412c583 100644
> --- a/arch/arm/mach-imx/ehci-imx25.c
> +++ b/arch/arm/mach-imx/ehci-imx25.c
> @@ -17,7 +17,7 @@
>  #include <linux/io.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/mxc_ehci.h>
> +#include <linux/platform_data/usb-ehci-mxc.h>
>  
>  #define USBCTRL_OTGBASE_OFFSET	0x600
>  
> diff --git a/arch/arm/mach-imx/ehci-imx27.c b/arch/arm/mach-imx/ehci-imx27.c
> index fa69419..cd6e1f8 100644
> --- a/arch/arm/mach-imx/ehci-imx27.c
> +++ b/arch/arm/mach-imx/ehci-imx27.c
> @@ -17,7 +17,7 @@
>  #include <linux/io.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/mxc_ehci.h>
> +#include <linux/platform_data/usb-ehci-mxc.h>
>  
>  #define USBCTRL_OTGBASE_OFFSET	0x600
>  
> diff --git a/arch/arm/mach-imx/ehci-imx31.c b/arch/arm/mach-imx/ehci-imx31.c
> index faad0f1..9a880c7 100644
> --- a/arch/arm/mach-imx/ehci-imx31.c
> +++ b/arch/arm/mach-imx/ehci-imx31.c
> @@ -17,7 +17,7 @@
>  #include <linux/io.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/mxc_ehci.h>
> +#include <linux/platform_data/usb-ehci-mxc.h>
>  
>  #define USBCTRL_OTGBASE_OFFSET	0x600
>  
> diff --git a/arch/arm/mach-imx/ehci-imx35.c b/arch/arm/mach-imx/ehci-imx35.c
> index 73574c3..779e16e 100644
> --- a/arch/arm/mach-imx/ehci-imx35.c
> +++ b/arch/arm/mach-imx/ehci-imx35.c
> @@ -17,7 +17,7 @@
>  #include <linux/io.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/mxc_ehci.h>
> +#include <linux/platform_data/usb-ehci-mxc.h>
>  
>  #define USBCTRL_OTGBASE_OFFSET	0x600
>  
> diff --git a/arch/arm/mach-imx/ehci-imx5.c b/arch/arm/mach-imx/ehci-imx5.c
> index a6a4afb..cf8d00e 100644
> --- a/arch/arm/mach-imx/ehci-imx5.c
> +++ b/arch/arm/mach-imx/ehci-imx5.c
> @@ -17,7 +17,7 @@
>  #include <linux/io.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/mxc_ehci.h>
> +#include <linux/platform_data/usb-ehci-mxc.h>
>  
>  #define MXC_OTG_OFFSET			0
>  #define MXC_H1_OFFSET			0x200
> diff --git a/arch/arm/mach-imx/mach-mx31moboard.c b/arch/arm/mach-imx/mach-mx31moboard.c
> index d46290b..459e754 100644
> --- a/arch/arm/mach-imx/mach-mx31moboard.c
> +++ b/arch/arm/mach-imx/mach-mx31moboard.c
> @@ -47,7 +47,7 @@
>  #include <mach/hardware.h>
>  #include <mach/iomux-mx3.h>
>  #include <mach/ulpi.h>
> -#include <mach/ssi.h>
> +#include <linux/platform_data/asoc-imx-ssi.h>
>  
>  #include "devices-imx31.h"
>  
> diff --git a/arch/arm/mach-imx/mx1-camera-fiq-ksym.c b/arch/arm/mach-imx/mx1-camera-fiq-ksym.c
> index b09ee12..fb38436 100644
> --- a/arch/arm/mach-imx/mx1-camera-fiq-ksym.c
> +++ b/arch/arm/mach-imx/mx1-camera-fiq-ksym.c
> @@ -11,7 +11,7 @@
>  #include <linux/platform_device.h>
>  #include <linux/module.h>
>  
> -#include <mach/mx1_camera.h>
> +#include <linux/platform_data/camera-mx1.h>
>  
>  /* IMX camera FIQ handler */
>  EXPORT_SYMBOL(mx1_camera_sof_fiq_start);
> diff --git a/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c b/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c
> index 5955f5d..3793e47 100644
> --- a/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c
> +++ b/arch/arm/plat-mxc/devices/platform-sdhci-esdhc-imx.c
> @@ -8,7 +8,7 @@
>  
>  #include <mach/hardware.h>
>  #include <mach/devices-common.h>
> -#include <mach/esdhc.h>
> +#include <linux/platform_data/mmc-esdhc-imx.h>
>  
>  #define imx_sdhci_esdhc_imx_data_entry_single(soc, _devid, _id, hwid) \
>  	{								\
> diff --git a/arch/arm/plat-mxc/include/mach/devices-common.h b/arch/arm/plat-mxc/include/mach/devices-common.h
> index a7f5bb1..9e3e3d8 100644
> --- a/arch/arm/plat-mxc/include/mach/devices-common.h
> +++ b/arch/arm/plat-mxc/include/mach/devices-common.h
> @@ -9,7 +9,7 @@
>  #include <linux/kernel.h>
>  #include <linux/platform_device.h>
>  #include <linux/init.h>
> -#include <mach/sdma.h>
> +#include <linux/platform_data/dma-imx-sdma.h>
>  
>  extern struct device mxc_aips_bus;
>  extern struct device mxc_ahb_bus;
> @@ -74,7 +74,7 @@ struct platform_device *__init imx_add_fsl_usb2_udc(
>  struct platform_device *__init imx_add_gpio_keys(
>  		const struct gpio_keys_platform_data *pdata);
>  
> -#include <mach/mx21-usbhost.h>
> +#include <linux/platform_data/usb-mx2.h>
>  struct imx_imx21_hcd_data {
>  	resource_size_t iobase;
>  	resource_size_t irq;
> @@ -98,7 +98,7 @@ struct imx_imxdi_rtc_data {
>  struct platform_device *__init imx_add_imxdi_rtc(
>  		const struct imx_imxdi_rtc_data *data);
>  
> -#include <mach/imxfb.h>
> +#include <linux/platform_data/video-imxfb.h>
>  struct imx_imx_fb_data {
>  	resource_size_t iobase;
>  	resource_size_t iosize;
> @@ -108,7 +108,7 @@ struct platform_device *__init imx_add_imx_fb(
>  		const struct imx_imx_fb_data *data,
>  		const struct imx_fb_platform_data *pdata);
>  
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-imx.h>
>  struct imx_imx_i2c_data {
>  	int id;
>  	resource_size_t iobase;
> @@ -129,7 +129,7 @@ struct platform_device *__init imx_add_imx_keypad(
>  		const struct imx_imx_keypad_data *data,
>  		const struct matrix_keymap_data *pdata);
>  
> -#include <mach/ssi.h>
> +#include <linux/platform_data/asoc-imx-ssi.h>
>  struct imx_imx_ssi_data {
>  	int id;
>  	resource_size_t iobase;
> @@ -144,7 +144,7 @@ struct platform_device *__init imx_add_imx_ssi(
>  		const struct imx_imx_ssi_data *data,
>  		const struct imx_ssi_platform_data *pdata);
>  
> -#include <mach/imx-uart.h>
> +#include <linux/platform_data/serial-imx.h>
>  struct imx_imx_uart_3irq_data {
>  	int id;
>  	resource_size_t iobase;
> @@ -167,7 +167,7 @@ struct platform_device *__init imx_add_imx_uart_1irq(
>  		const struct imx_imx_uart_1irq_data *data,
>  		const struct imxuart_platform_data *pdata);
>  
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-imx_udc.h>
>  struct imx_imx_udc_data {
>  	resource_size_t iobase;
>  	resource_size_t iosize;
> @@ -183,8 +183,8 @@ struct platform_device *__init imx_add_imx_udc(
>  		const struct imx_imx_udc_data *data,
>  		const struct imxusb_platform_data *pdata);
>  
> -#include <mach/mx3fb.h>
> -#include <mach/mx3_camera.h>
> +#include <linux/platform_data/video-mx3fb.h>
> +#include <linux/platform_data/camera-mx3.h>
>  struct imx_ipu_core_data {
>  	resource_size_t iobase;
>  	resource_size_t synirq;
> @@ -199,7 +199,7 @@ struct platform_device *__init imx_add_mx3_sdc_fb(
>  		const struct imx_ipu_core_data *data,
>  		struct mx3fb_platform_data *pdata);
>  
> -#include <mach/mx1_camera.h>
> +#include <linux/platform_data/camera-mx1.h>
>  struct imx_mx1_camera_data {
>  	resource_size_t iobase;
>  	resource_size_t iosize;
> @@ -209,7 +209,7 @@ struct platform_device *__init imx_add_mx1_camera(
>  		const struct imx_mx1_camera_data *data,
>  		const struct mx1_camera_pdata *pdata);
>  
> -#include <mach/mx2_cam.h>
> +#include <linux/platform_data/camera-mx2.h>
>  struct imx_mx2_camera_data {
>  	resource_size_t iobasecsi;
>  	resource_size_t iosizecsi;
> @@ -224,7 +224,7 @@ struct platform_device *__init imx_add_mx2_camera(
>  struct platform_device *__init imx_add_mx2_emmaprp(
>  		const struct imx_mx2_camera_data *data);
>  
> -#include <mach/mxc_ehci.h>
> +#include <linux/platform_data/usb-ehci-mxc.h>
>  struct imx_mxc_ehci_data {
>  	int id;
>  	resource_size_t iobase;
> @@ -234,7 +234,7 @@ struct platform_device *__init imx_add_mxc_ehci(
>  		const struct imx_mxc_ehci_data *data,
>  		const struct mxc_usbh_platform_data *pdata);
>  
> -#include <mach/mmc.h>
> +#include <linux/platform_data/mmc-mxcmmc.h>
>  struct imx_mxc_mmc_data {
>  	int id;
>  	resource_size_t iobase;
> @@ -246,7 +246,7 @@ struct platform_device *__init imx_add_mxc_mmc(
>  		const struct imx_mxc_mmc_data *data,
>  		const struct imxmmc_platform_data *pdata);
>  
> -#include <mach/mxc_nand.h>
> +#include <linux/platform_data/mtd-mxc_nand.h>
>  struct imx_mxc_nand_data {
>  	/*
>  	 * id is traditionally 0, but -1 is more appropriate.  We use -1 for new
> @@ -295,7 +295,7 @@ struct imx_mxc_w1_data {
>  struct platform_device *__init imx_add_mxc_w1(
>  		const struct imx_mxc_w1_data *data);
>  
> -#include <mach/esdhc.h>
> +#include <linux/platform_data/mmc-esdhc-imx.h>
>  struct imx_sdhci_esdhc_imx_data {
>  	const char *devid;
>  	int id;
> @@ -306,7 +306,7 @@ struct platform_device *__init imx_add_sdhci_esdhc_imx(
>  		const struct imx_sdhci_esdhc_imx_data *data,
>  		const struct esdhc_platform_data *pdata);
>  
> -#include <mach/spi.h>
> +#include <linux/platform_data/spi-imx.h>
>  struct imx_spi_imx_data {
>  	const char *devid;
>  	int id;
> diff --git a/arch/arm/plat-mxc/ssi-fiq-ksym.c b/arch/arm/plat-mxc/ssi-fiq-ksym.c
> index b5fad45..792090f 100644
> --- a/arch/arm/plat-mxc/ssi-fiq-ksym.c
> +++ b/arch/arm/plat-mxc/ssi-fiq-ksym.c
> @@ -10,7 +10,7 @@
>  
>  #include <linux/module.h>
>  
> -#include <mach/ssi.h>
> +#include <linux/platform_data/asoc-imx-ssi.h>
>  
>  EXPORT_SYMBOL(imx_ssi_fiq_tx_buffer);
>  EXPORT_SYMBOL(imx_ssi_fiq_rx_buffer);
> diff --git a/drivers/dma/imx-dma.c b/drivers/dma/imx-dma.c
> index 5084975..b90aaec 100644
> --- a/drivers/dma/imx-dma.c
> +++ b/drivers/dma/imx-dma.c
> @@ -28,7 +28,7 @@
>  #include <linux/module.h>
>  
>  #include <asm/irq.h>
> -#include <mach/dma.h>
> +#include <linux/platform_data/dma-imx.h>
>  #include <mach/hardware.h>
>  
>  #include "dmaengine.h"
> diff --git a/drivers/dma/imx-sdma.c b/drivers/dma/imx-sdma.c
> index 1dc2a4a..1b781d6 100644
> --- a/drivers/dma/imx-sdma.c
> +++ b/drivers/dma/imx-sdma.c
> @@ -38,8 +38,8 @@
>  #include <linux/of_device.h>
>  
>  #include <asm/irq.h>
> -#include <mach/sdma.h>
> -#include <mach/dma.h>
> +#include <linux/platform_data/dma-imx-sdma.h>
> +#include <linux/platform_data/dma-imx.h>
>  #include <mach/hardware.h>
>  
>  #include "dmaengine.h"
> diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
> index 0722f86..b7907ba7 100644
> --- a/drivers/i2c/busses/i2c-imx.c
> +++ b/drivers/i2c/busses/i2c-imx.c
> @@ -54,7 +54,7 @@
>  #include <linux/pinctrl/consumer.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/i2c.h>
> +#include <linux/platform_data/i2c-imx.h>
>  
>  /** Defines ********************************************************************
>  *******************************************************************************/
> diff --git a/drivers/media/video/mx1_camera.c b/drivers/media/video/mx1_camera.c
> index 560a65a..bbe7099 100644
> --- a/drivers/media/video/mx1_camera.c
> +++ b/drivers/media/video/mx1_camera.c
> @@ -44,7 +44,7 @@
>  #include <mach/dma-mx1-mx2.h>
>  #include <mach/hardware.h>
>  #include <mach/irqs.h>
> -#include <mach/mx1_camera.h>
> +#include <linux/platform_data/camera-mx1.h>
>  
>  /*
>   * CSI registers
> diff --git a/drivers/media/video/mx2_camera.c b/drivers/media/video/mx2_camera.c
> index ac17540..965427f 100644
> --- a/drivers/media/video/mx2_camera.c
> +++ b/drivers/media/video/mx2_camera.c
> @@ -40,7 +40,7 @@
>  
>  #include <linux/videodev2.h>
>  
> -#include <mach/mx2_cam.h>
> +#include <linux/platform_data/camera-mx2.h>
>  #include <mach/hardware.h>
>  
>  #include <asm/dma.h>
> diff --git a/drivers/media/video/mx3_camera.c b/drivers/media/video/mx3_camera.c
> index af2297d..1481b0d 100644
> --- a/drivers/media/video/mx3_camera.c
> +++ b/drivers/media/video/mx3_camera.c
> @@ -25,8 +25,8 @@
>  #include <media/soc_mediabus.h>
>  
>  #include <mach/ipu.h>
> -#include <mach/mx3_camera.h>
> -#include <mach/dma.h>
> +#include <linux/platform_data/camera-mx3.h>
> +#include <linux/platform_data/dma-imx.h>
>  
>  #define MX3_CAM_DRV_NAME "mx3-camera"
>  
> diff --git a/drivers/mmc/host/mxcmmc.c b/drivers/mmc/host/mxcmmc.c
> index 28ed52d..7b1161d 100644
> --- a/drivers/mmc/host/mxcmmc.c
> +++ b/drivers/mmc/host/mxcmmc.c
> @@ -38,9 +38,9 @@
>  #include <asm/dma.h>
>  #include <asm/irq.h>
>  #include <asm/sizes.h>
> -#include <mach/mmc.h>
> +#include <linux/platform_data/mmc-mxcmmc.h>
>  
> -#include <mach/dma.h>
> +#include <linux/platform_data/dma-imx.h>
>  #include <mach/hardware.h>
>  
>  #define DRIVER_NAME "mxc-mmc"
> diff --git a/drivers/mmc/host/sdhci-esdhc-imx.c b/drivers/mmc/host/sdhci-esdhc-imx.c
> index e23f813..c4c504c 100644
> --- a/drivers/mmc/host/sdhci-esdhc-imx.c
> +++ b/drivers/mmc/host/sdhci-esdhc-imx.c
> @@ -25,7 +25,7 @@
>  #include <linux/of_device.h>
>  #include <linux/of_gpio.h>
>  #include <linux/pinctrl/consumer.h>
> -#include <mach/esdhc.h>
> +#include <linux/platform_data/mmc-esdhc-imx.h>
>  #include "sdhci-pltfm.h"
>  #include "sdhci-esdhc.h"
>  
> diff --git a/drivers/mtd/nand/mxc_nand.c b/drivers/mtd/nand/mxc_nand.c
> index 6acc790..5683604 100644
> --- a/drivers/mtd/nand/mxc_nand.c
> +++ b/drivers/mtd/nand/mxc_nand.c
> @@ -36,7 +36,7 @@
>  #include <linux/of_mtd.h>
>  
>  #include <asm/mach/flash.h>
> -#include <mach/mxc_nand.h>
> +#include <linux/platform_data/mtd-mxc_nand.h>
>  #include <mach/hardware.h>
>  
>  #define DRIVER_NAME "mxc_nand"
> diff --git a/drivers/spi/spi-imx.c b/drivers/spi/spi-imx.c
> index e834ff8..63e7fc9 100644
> --- a/drivers/spi/spi-imx.c
> +++ b/drivers/spi/spi-imx.c
> @@ -39,7 +39,7 @@
>  #include <linux/of_gpio.h>
>  #include <linux/pinctrl/consumer.h>
>  
> -#include <mach/spi.h>
> +#include <linux/platform_data/spi-imx.h>
>  
>  #define DRIVER_NAME "spi_imx"
>  
> diff --git a/drivers/tty/serial/imx.c b/drivers/tty/serial/imx.c
> index d5c689d6..fc65ba2 100644
> --- a/drivers/tty/serial/imx.c
> +++ b/drivers/tty/serial/imx.c
> @@ -51,7 +51,7 @@
>  
>  #include <asm/io.h>
>  #include <asm/irq.h>
> -#include <mach/imx-uart.h>
> +#include <linux/platform_data/serial-imx.h>
>  
>  /* Register definitions */
>  #define URXD0 0x0  /* Receiver Register */
> diff --git a/drivers/usb/gadget/imx_udc.c b/drivers/usb/gadget/imx_udc.c
> index dc53348..a0eb857 100644
> --- a/drivers/usb/gadget/imx_udc.c
> +++ b/drivers/usb/gadget/imx_udc.c
> @@ -35,7 +35,7 @@
>  #include <linux/usb/ch9.h>
>  #include <linux/usb/gadget.h>
>  
> -#include <mach/usb.h>
> +#include <linux/platform_data/usb-imx_udc.h>
>  #include <mach/hardware.h>
>  
>  #include "imx_udc.h"
> diff --git a/drivers/usb/host/ehci-mxc.c b/drivers/usb/host/ehci-mxc.c
> index 3420137..a6e2ea4 100644
> --- a/drivers/usb/host/ehci-mxc.c
> +++ b/drivers/usb/host/ehci-mxc.c
> @@ -25,7 +25,7 @@
>  #include <linux/slab.h>
>  
>  #include <mach/hardware.h>
> -#include <mach/mxc_ehci.h>
> +#include <linux/platform_data/usb-ehci-mxc.h>
>  
>  #include <asm/mach-types.h>
>  
> diff --git a/drivers/usb/host/imx21-hcd.h b/drivers/usb/host/imx21-hcd.h
> index 87b29fd..c005770 100644
> --- a/drivers/usb/host/imx21-hcd.h
> +++ b/drivers/usb/host/imx21-hcd.h
> @@ -24,7 +24,7 @@
>  #ifndef __LINUX_IMX21_HCD_H__
>  #define __LINUX_IMX21_HCD_H__
>  
> -#include <mach/mx21-usbhost.h>
> +#include <linux/platform_data/usb-mx2.h>
>  
>  #define NUM_ISO_ETDS 	2
>  #define USB_NUM_ETD	32
> diff --git a/drivers/video/imxfb.c b/drivers/video/imxfb.c
> index caad368..53ffdfc 100644
> --- a/drivers/video/imxfb.c
> +++ b/drivers/video/imxfb.c
> @@ -32,7 +32,7 @@
>  #include <linux/io.h>
>  #include <linux/math64.h>
>  
> -#include <mach/imxfb.h>
> +#include <linux/platform_data/video-imxfb.h>
>  #include <mach/hardware.h>
>  
>  /*
> diff --git a/drivers/video/mx3fb.c b/drivers/video/mx3fb.c
> index c89f8a8..d738108 100644
> --- a/drivers/video/mx3fb.c
> +++ b/drivers/video/mx3fb.c
> @@ -27,10 +27,10 @@
>  #include <linux/clk.h>
>  #include <linux/mutex.h>
>  
> -#include <mach/dma.h>
> +#include <linux/platform_data/dma-imx.h>
>  #include <mach/hardware.h>
>  #include <mach/ipu.h>
> -#include <mach/mx3fb.h>
> +#include <linux/platform_data/video-mx3fb.h>
>  
>  #include <asm/io.h>
>  #include <asm/uaccess.h>
> diff --git a/arch/arm/plat-mxc/include/mach/ssi.h b/include/linux/platform_data/asoc-imx-ssi.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/ssi.h
> rename to include/linux/platform_data/asoc-imx-ssi.h
> diff --git a/arch/arm/plat-mxc/include/mach/mx1_camera.h b/include/linux/platform_data/camera-mx1.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mx1_camera.h
> rename to include/linux/platform_data/camera-mx1.h
> diff --git a/arch/arm/plat-mxc/include/mach/mx2_cam.h b/include/linux/platform_data/camera-mx2.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mx2_cam.h
> rename to include/linux/platform_data/camera-mx2.h
> diff --git a/arch/arm/plat-mxc/include/mach/mx3_camera.h b/include/linux/platform_data/camera-mx3.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mx3_camera.h
> rename to include/linux/platform_data/camera-mx3.h
> diff --git a/arch/arm/plat-mxc/include/mach/sdma.h b/include/linux/platform_data/dma-imx-sdma.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/sdma.h
> rename to include/linux/platform_data/dma-imx-sdma.h
> diff --git a/arch/arm/plat-mxc/include/mach/dma.h b/include/linux/platform_data/dma-imx.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/dma.h
> rename to include/linux/platform_data/dma-imx.h
> diff --git a/arch/arm/plat-mxc/include/mach/i2c.h b/include/linux/platform_data/i2c-imx.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/i2c.h
> rename to include/linux/platform_data/i2c-imx.h
> diff --git a/arch/arm/plat-mxc/include/mach/esdhc.h b/include/linux/platform_data/mmc-esdhc-imx.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/esdhc.h
> rename to include/linux/platform_data/mmc-esdhc-imx.h
> diff --git a/arch/arm/plat-mxc/include/mach/mmc.h b/include/linux/platform_data/mmc-mxcmmc.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mmc.h
> rename to include/linux/platform_data/mmc-mxcmmc.h
> diff --git a/arch/arm/plat-mxc/include/mach/mxc_nand.h b/include/linux/platform_data/mtd-mxc_nand.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mxc_nand.h
> rename to include/linux/platform_data/mtd-mxc_nand.h
> diff --git a/arch/arm/plat-mxc/include/mach/imx-uart.h b/include/linux/platform_data/serial-imx.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/imx-uart.h
> rename to include/linux/platform_data/serial-imx.h
> diff --git a/arch/arm/plat-mxc/include/mach/spi.h b/include/linux/platform_data/spi-imx.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/spi.h
> rename to include/linux/platform_data/spi-imx.h
> diff --git a/arch/arm/plat-mxc/include/mach/mxc_ehci.h b/include/linux/platform_data/usb-ehci-mxc.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mxc_ehci.h
> rename to include/linux/platform_data/usb-ehci-mxc.h
> diff --git a/arch/arm/plat-mxc/include/mach/usb.h b/include/linux/platform_data/usb-imx_udc.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/usb.h
> rename to include/linux/platform_data/usb-imx_udc.h
> diff --git a/arch/arm/plat-mxc/include/mach/mx21-usbhost.h b/include/linux/platform_data/usb-mx2.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mx21-usbhost.h
> rename to include/linux/platform_data/usb-mx2.h
> diff --git a/arch/arm/plat-mxc/include/mach/imxfb.h b/include/linux/platform_data/video-imxfb.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/imxfb.h
> rename to include/linux/platform_data/video-imxfb.h
> diff --git a/arch/arm/plat-mxc/include/mach/mx3fb.h b/include/linux/platform_data/video-mx3fb.h
> similarity index 100%
> rename from arch/arm/plat-mxc/include/mach/mx3fb.h
> rename to include/linux/platform_data/video-mx3fb.h
> diff --git a/sound/soc/fsl/imx-pcm-dma.c b/sound/soc/fsl/imx-pcm-dma.c
> index 48f9d88..89a7755 100644
> --- a/sound/soc/fsl/imx-pcm-dma.c
> +++ b/sound/soc/fsl/imx-pcm-dma.c
> @@ -30,7 +30,7 @@
>  #include <sound/soc.h>
>  #include <sound/dmaengine_pcm.h>
>  
> -#include <mach/dma.h>
> +#include <linux/platform_data/dma-imx.h>
>  
>  #include "imx-pcm.h"
>  
> diff --git a/sound/soc/fsl/imx-pcm-fiq.c b/sound/soc/fsl/imx-pcm-fiq.c
> index ee27ba3..22c6130 100644
> --- a/sound/soc/fsl/imx-pcm-fiq.c
> +++ b/sound/soc/fsl/imx-pcm-fiq.c
> @@ -30,7 +30,7 @@
>  #include <asm/fiq.h>
>  
>  #include <mach/irqs.h>
> -#include <mach/ssi.h>
> +#include <linux/platform_data/asoc-imx-ssi.h>
>  
>  #include "imx-ssi.h"
>  
> diff --git a/sound/soc/fsl/imx-ssi.c b/sound/soc/fsl/imx-ssi.c
> index 81d7728..e6a17ba 100644
> --- a/sound/soc/fsl/imx-ssi.c
> +++ b/sound/soc/fsl/imx-ssi.c
> @@ -47,7 +47,7 @@
>  #include <sound/pcm_params.h>
>  #include <sound/soc.h>
>  
> -#include <mach/ssi.h>
> +#include <linux/platform_data/asoc-imx-ssi.h>
>  #include <mach/hardware.h>
>  
>  #include "imx-ssi.h"
> diff --git a/sound/soc/fsl/imx-ssi.h b/sound/soc/fsl/imx-ssi.h
> index 5744e86..dc114bd 100644
> --- a/sound/soc/fsl/imx-ssi.h
> +++ b/sound/soc/fsl/imx-ssi.h
> @@ -186,7 +186,7 @@
>  #define DRV_NAME "imx-ssi"
>  
>  #include <linux/dmaengine.h>
> -#include <mach/dma.h>
> +#include <linux/platform_data/dma-imx.h>
>  #include "imx-pcm.h"
>  
>  struct imx_ssi {
> -- 
> 1.7.10
> 
> 
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
> 

-- 
Pengutronix e.K.                           |                             |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
