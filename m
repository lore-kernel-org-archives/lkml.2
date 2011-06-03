Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754538Ab1FCLyQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 07:54:16 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53107 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab1FCLyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 07:54:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=gnmqxA7hxcYUVdwSjFJ2SFlRBg5b4wxXh2L9sm1OcIOZDz6IEmbQQd5da0xcwz4xvI
         nmEhfqT2Xr1jElIP/R+zDPoeIH/6hub+FiX+7nm6I2WqwHgPbAKvXxGb/q78AqTMosG9
         8/SsRA5fbjSq4SU4sQdJuq1bjWpyyll6rnt/4=
MIME-Version: 1.0
In-Reply-To: <1306985632-18820-4-git-send-email-shawn.guo@linaro.org>
References: <1306985632-18820-1-git-send-email-shawn.guo@linaro.org>
	<1306985632-18820-4-git-send-email-shawn.guo@linaro.org>
Date: Fri, 3 Jun 2011 08:54:14 -0300
Message-ID: <BANLkTikUnDN81f3cv-buqsKUgdqXsRcYhQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] ARM: mxc: migrate mach-imx gpio driver to gpio-mxc
From: Fabio Estevam <festevam@gmail.com>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org, arnd@arndb.de, patches@linaro.org,
        grant.likely@secretlab.ca, kernel@pengutronix.de, olof@lixom.net,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Shawn,

On Thu, Jun 2, 2011 at 12:33 AM, Shawn Guo <shawn.guo@linaro.org> wrote:
...

> +void __init imx1_soc_init(void)
> +{
> +       mxc_register_gpio(0, MX1_GPIO1_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTA, 0);
> +       mxc_register_gpio(1, MX1_GPIO2_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTB, 0);
> +       mxc_register_gpio(2, MX1_GPIO3_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTC, 0);
> +       mxc_register_gpio(3, MX1_GPIO4_BASE_ADDR, SZ_4K, MX1_GPIO_INT_PORTD, 0);

By just reading the function names like "imx1_soc_init" we have really
no clue of what it actually does.

"soc_init" is too vague IMHO. Could´t you change the names to
something like "imx1_gpio_init" or "imx1_gpio_register".

It would be nice at least are dealing with gpio.

Regards,

Fabio Estevam
