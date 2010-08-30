Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755481Ab0H3MBF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:01:05 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:36812 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab0H3MBD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:01:03 -0400
Date: Mon, 30 Aug 2010 21:01:15 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
Subject: RE: [PATCH 1/3] ARM: Samsung S5P: Move the common Samsung S5P series
	GPIO level type
In-reply-to: <20100830114708.GA13140@july>
To: "'Kyungmin Park'" <kmpark@infradead.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: jy0922.shim@samsung.com, m.szyprowski@samsung.com, ben-linux@fluff.org
Message-id: <006201cb483b$0e1727e0$2a4577a0$%kim@samsung.com>
MIME-version: 1.0
X-Mailer: Microsoft Office Outlook 12.0
Content-type: text/plain; charset=us-ascii
Content-language: ko
Content-transfer-encoding: 7BIT
Thread-index: ActIORkAru7FRcpnRBaE7+2CVE8KUQAATHZA
References: <20100830114708.GA13140@july>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park wrote:
> 
> From: Kyungmin Park <kyungmin.park@samsung.com>
> 
> Samsung S5P series has common level type. It's different from S3C series.
> 
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> ---
>  arch/arm/plat-samsung/include/plat/gpio-core.h |    6 ++++++
>  1 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h
b/arch/arm/plat-
> samsung/include/plat/gpio-core.h
> index e358c7d..c8681e0 100644
> --- a/arch/arm/plat-samsung/include/plat/gpio-core.h
> +++ b/arch/arm/plat-samsung/include/plat/gpio-core.h
> @@ -14,6 +14,12 @@
>  #define GPIOCON_OFF	(0x00)
>  #define GPIODAT_OFF	(0x04)
> 
> +#define S5P_GPIO_LEVEL_LOW		(0x00)
> +#define S5P_GPIO_LEVEL_HIGH		(0x01)
> +#define S5P_GPIO_EDGE_FALLING		(0x02)
> +#define S5P_GPIO_EDGE_RISING		(0x03)
> +#define S5P_GPIO_EDGE_BOTH		(0x04)

Why should we change the name of definition from S5P_EXTINT_XXX?
If we use that, we don't need to change other files.

> +
>  #define con_4bit_shift(__off) ((__off) * 4)
> 
>  /* Define the core gpiolib support functions that the s3c platforms may
> --

Thanks.

Best regards,
Kgene.
--
Kukjin Kim <kgene.kim@samsung.com>, Senior Engineer,
SW Solution Development Team, Samsung Electronics Co., Ltd.

