Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756591Ab2HGU0W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:26:22 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:45726 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755891Ab2HGU0V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:26:21 -0400
Message-ID: <502179EA.30301@wwwdotorg.org>
Date: Tue, 07 Aug 2012 14:26:18 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>,
        Patrice Chotard <patrice.chotard@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl/nomadik: add ASIC DB8450 pinctrl driver
References: <1344341538-32223-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1344341538-32223-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/07/2012 06:12 AM, Linus Walleij wrote:
> From: Patrice Chotard <patrice.chotard@stericsson.com>
> 
> This implements a subdriver for the DB8540 ASIC for the
> Nomadik pin controller.

> diff --git a/drivers/pinctrl/pinctrl-nomadik.c b/drivers/pinctrl/pinctrl-nomadik.c

> @@ -1722,6 +1722,8 @@ static int __devinit nmk_pinctrl_probe(struct platform_device *pdev)
>  	/* Poke in other ASIC variants here */
>  	if (version == PINCTRL_NMK_DB8500)
>  		nmk_pinctrl_db8500_init(&npct->soc);
> +	if (platid->driver_data == PINCTRL_NMK_DB8540)
> +		nmk_pinctrl_db8540_init(&npct->soc);

I'm surprised one of those checks "version" and the other
"platid->driver_data".

Aside from that, this looks fine.
