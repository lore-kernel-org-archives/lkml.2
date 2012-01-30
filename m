Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab2A3Q5U (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:57:20 -0500
Received: from mail.dev.rtsoft.ru ([213.79.90.226]:49815 "HELO
	mail.dev.rtsoft.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753256Ab2A3Q5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:57:18 -0500
Message-ID: <4F26D9DC.2000008@ru.mvista.com>
Date: Mon, 30 Jan 2012 20:56:44 +0300
From: Sergei Shtylyov <sshtylyov@ru.mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:6.0) Gecko/20110812 Thunderbird/6.0
MIME-Version: 1.0
To: Roland Stigge <stigge@antcom.de>
CC: w.sang@pengutronix.de, bangaragiri.g@nxp.com, srinivas.bakki@nxp.com,
        sundarapandian.andithevar@nxp.com, linus.walleij@linaro.org,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        grant.likely@secretlab.ca, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 1/7] LPC32xx: clock.c: Missing header file
References: <1327939327-7799-1-git-send-email-stigge@antcom.de>
In-Reply-To: <1327939327-7799-1-git-send-email-stigge@antcom.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01/30/2012 07:02 PM, Roland Stigge wrote:

> This patch fixes the compiler warnings regarding the EXPORT_SYMBOL usage

> Signed-off-by: Roland Stigge<stigge@antcom.de>

> diff --git a/arch/arm/mach-lpc32xx/clock.c b/arch/arm/mach-lpc32xx/clock.c
> index 1e02751..8e79313 100644
> --- a/arch/arm/mach-lpc32xx/clock.c
> +++ b/arch/arm/mach-lpc32xx/clock.c
> @@ -82,6 +82,7 @@
>    *   will also impact the individual peripheral rates.
>    */
>
> +#include<linux/module.h>

    Shouldn't <linux/export.h> be included instead nowadays?

WBR, Sergei
