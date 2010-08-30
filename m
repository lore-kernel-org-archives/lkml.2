Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755471Ab0H3MAK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 08:00:10 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:37224 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755307Ab0H3MAI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 08:00:08 -0400
Message-ID: <4C7B9D18.7090500@ru.mvista.com>
Date: Mon, 30 Aug 2010 15:59:20 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Kyungmin Park <kmpark@infradead.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kgene.kim@samsung.com, jy0922.shim@samsung.com, ben-linux@fluff.org,
        m.szyprowski@samsung.com
Subject: Re: [PATCH 1/3] ARM: Samsung S5P: Move the common Samsung S5P series
 GPIO	level type
References: <20100830114708.GA13140@july>
In-Reply-To: <20100830114708.GA13140@july>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Kyungmin Park wrote:

> From: Kyungmin Park <kyungmin.park@samsung.com>

> Samsung S5P series has common level type. It's different from S3C series.

> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

[...]

> diff --git a/arch/arm/plat-samsung/include/plat/gpio-core.h b/arch/arm/plat-samsung/include/plat/gpio-core.h
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

    The parens are useless here.

WBR, Sergei

