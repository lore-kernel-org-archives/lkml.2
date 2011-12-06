Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933356Ab1LFLfq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 06:35:46 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:48123 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933199Ab1LFLfo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 06:35:44 -0500
X-AuditID: cbfee61a-b7b89ae000001a15-94-4eddfe0f28c2
From: Kukjin Kim <kgene.kim@samsung.com>
To: "'Denis Kuzmenko'" <linux@solonet.org.ua>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        "'Ben Dooks'" <ben-linux@fluff.org>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        linux-samsung-soc@vger.kernel.org
References: <4EC588A8.3030907@solonet.org.ua> <4EDD71C5.1090905@solonet.org.ua>
In-reply-to: <4EDD71C5.1090905@solonet.org.ua>
Subject: RE: [PATCH resend3] arm: s3c24xx: Add new LCD (W35i) support for
 Mini2440 board
Date: Tue, 06 Dec 2011 20:35:43 +0900
Message-id: <02f001ccb40b$303fa8a0$90bef9e0$%kim@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Acyzt/i2k4XXVKaGSteEjxx0C18vggAUyuKw
Content-language: ko
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Denis Kuzmenko wrote:
> 
> Add new LCD (W35i) support for Mini2440 board
> 
> Signed-off-by: Denis Kuzmenko <linux@solonet.org.ua>
> ---
> 
> diff --git a/arch/arm/mach-s3c2440/mach-mini2440.c
> b/arch/arm/mach-s3c2440/mach-mini2440.c
> index fc2dc0b..951eadd 100644
> --- a/arch/arm/mach-s3c2440/mach-mini2440.c
> +++ b/arch/arm/mach-s3c2440/mach-mini2440.c
> @@ -167,6 +167,24 @@ static struct s3c2410fb_display mini2440_lcd_cfg[]
> __initdata = {
>  		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
>  				   S3C2410_LCDCON5_HWSWP),
>  	},
> +	/* mini2440 + 3.5" TFT (LCD-W35i, LQ035Q1DG06 type) + touchscreen*/
> +	[3] = {
> +		_LCD_DECLARE(
> +			/* clock */
> +			7,
> +			/* xres, margin_right, margin_left, hsync */
> +			320, 68, 66, 4,
> +			/* yres, margin_top, margin_bottom, vsync */
> +			240, 4, 4, 9,
> +			/* refresh rate */
> +			60),
> +		.lcdcon5	= (S3C2410_LCDCON5_FRM565 |
> +				   S3C2410_LCDCON5_INVVDEN |
> +				   S3C2410_LCDCON5_INVVFRAME |
> +				   S3C2410_LCDCON5_INVVLINE |
> +				   S3C2410_LCDCON5_INVVCLK |
> +				   S3C2410_LCDCON5_HWSWP),
> +	},
>  };
>   /* todo - put into gpio header */

Looks ok, will apply.
Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

