Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755740Ab0JRNiz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 09:38:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:59283 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754955Ab0JRNiy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 09:38:54 -0400
Date: Mon, 18 Oct 2010 22:39:13 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 4/9] ARM: S3C64XX: add USB host support for mach-real6410
In-reply-to: <20100929193346.25307.75373.stgit@darius-desktop>
To: "'Darius Augulis'" <augulis.darius@gmail.com>,
        linux-arm-kernel@lists.infradead.org
Cc: paulius.zaleckas@gmail.com, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org
Message-id: <04a601cb6ec9$db82dee0$92889ca0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=utf-8
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActgDUWtatvFAYmbS9+voEty7+7okgOu8VBg
References: <20100929192354.25307.40197.stgit@darius-desktop>
 <20100929193346.25307.75373.stgit@darius-desktop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Darius Augulis wrote:
> 
> Add USB host device support for mach-real6410
> 
> Signed-off-by: Darius Augulis <augulis.darius@gmail.com>
> ---
>  arch/arm/mach-s3c64xx/Kconfig         |    1 +
>  arch/arm/mach-s3c64xx/mach-real6410.c |    1 +
>  2 files changed, 2 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c64xx/Kconfig b/arch/arm/mach-s3c64xx/Kconfig
> index b706b80..c05ae12 100644
> --- a/arch/arm/mach-s3c64xx/Kconfig
> +++ b/arch/arm/mach-s3c64xx/Kconfig
> @@ -109,6 +109,7 @@ config MACH_REAL6410
>  	select S3C_DEV_NAND
>  	select SAMSUNG_DEV_ADC
>  	select SAMSUNG_DEV_TS
> +	select S3C_DEV_USB_HOST
>  	help
>  	  Machine support for the CoreWind REAL6410
> 
> diff --git a/arch/arm/mach-s3c64xx/mach-real6410.c b/arch/arm/mach-
> s3c64xx/mach-real6410.c
> index bad6990..00e7d7e 100644
> --- a/arch/arm/mach-s3c64xx/mach-real6410.c
> +++ b/arch/arm/mach-s3c64xx/mach-real6410.c
> @@ -195,6 +195,7 @@ static struct platform_device *real6410_devices[]
> __initdata = {
>  	&s3c_device_nand,
>  	&s3c_device_adc,
>  	&s3c_device_ts,
> +	&s3c_device_ohci,
>  };
> 
>  static struct s3c2410_ts_mach_info s3c_ts_platform __initdata = {

No need any gpio configuration for it?

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

