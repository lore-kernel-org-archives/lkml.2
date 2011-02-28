Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752548Ab1B1Giz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 01:38:55 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:59692 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751698Ab1B1Giy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 01:38:54 -0500
Date: Mon, 28 Feb 2011 15:38:48 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 02/09] ARM: s3c2440: gta02: Register PCM device
In-reply-to: <1297043521-21903-2-git-send-email-lars@metafoo.de>
To: "'Lars-Peter Clausen'" <lars@metafoo.de>,
        "'Ben Dooks'" <ben-linux@fluff.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Message-id: <000701cbd712$2a32da30$7e988e90$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: AcvGalqomh8TwekKS4Wvyno1ozlyegQp8AlQ
References: <1297043521-21903-1-git-send-email-lars@metafoo.de>
 <1297043521-21903-2-git-send-email-lars@metafoo.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars-Peter Clausen wrote:
> 
> The ASoC multi-component patch introduced a new pcm platform device, which
> needs
> to be registered by board files in order for sound to work.
> This patch does this for the gta02 board.
> 
> Signed-off-by: Lars-Peter Clausen <lars@metafoo.de>
> ---
>  arch/arm/mach-s3c2440/mach-gta02.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-s3c2440/mach-gta02.c
b/arch/arm/mach-s3c2440/mach-
> gta02.c
> index 9f2c14e..e83062b 100644
> --- a/arch/arm/mach-s3c2440/mach-gta02.c
> +++ b/arch/arm/mach-s3c2440/mach-gta02.c
> @@ -509,6 +509,7 @@ static struct platform_device *gta02_devices[]
__initdata
> = {
>  	&gta02_nor_flash,
>  	&s3c24xx_pwm_device,
>  	&s3c_device_iis,
> +	&samsung_asoc_dma,
>  	&s3c_device_i2c0,
>  };
> 
> --

Ok, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

