Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760390Ab2HJXSh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 19:18:37 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:43959 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760044Ab2HJXSg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 19:18:36 -0400
Message-ID: <502596C9.4010900@wwwdotorg.org>
Date: Fri, 10 Aug 2012 17:18:33 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Patrice Chotard <patrice.chotard@stericsson.com>
Subject: Re: [PATCH 2/2] ARM: nomadik: configure Nomadik for pin control
References: <1344552220-995-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1344552220-995-1-git-send-email-linus.walleij@linaro.org>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2012 04:43 PM, Linus Walleij wrote:
> This converts the Nomadik to using pin control using the
> driver for the STN8815 ASIC.

> diff --git a/arch/arm/mach-nomadik/cpu-8815.c b/arch/arm/mach-nomadik/cpu-8815.c

> +static inline void
> +cpu8815_add_pinctrl(struct device *parent, const char *name)
> +{
> +	struct platform_device_info pdevinfo = {
> +		.parent = parent,
> +		.name = name,
> +		.id = -1,
> +	};
> +
> +	platform_device_register_full(&pdevinfo);
> +}

Out of curiosity, why platform_device_register_full() not
platform_device_register() here?

Otherwise,
Acked-by: Stephen Warren <swarren@wwwdotorg.org>

