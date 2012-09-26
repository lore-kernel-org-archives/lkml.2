Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754313Ab2IZLKv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 07:10:51 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:65151 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752809Ab2IZLKu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 07:10:50 -0400
MIME-Version: 1.0
In-Reply-To: <1348525213-18987-2-git-send-email-m-karicheri2@ti.com>
References: <1348525213-18987-1-git-send-email-m-karicheri2@ti.com>
	<1348525213-18987-2-git-send-email-m-karicheri2@ti.com>
Date: Wed, 26 Sep 2012 13:10:49 +0200
Message-ID: <CACRpkdbpZ+dxoCq7Ky=EMDR2uDX10vyn3-P+V6iN8mwWCof+HQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/12] clk: davinci - add Main PLL clock driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: mturquette@linaro.org, arnd@arndb.de, akpm@linux-foundation.org,
        shawn.guo@linaro.org, rob.herring@calxeda.com, viresh.linux@gmail.com,
        linux-kernel@vger.kernel.org, nsekhar@ti.com, khilman@ti.com,
        linux@arm.linux.org.uk, davinci-linux-open-source@linux.davincidsp.com,
        linux-arm-kernel@lists.infradead.org, linux-keystone@list.ti.com,
        linux-c6x-dev@linux-c6x.org, cyril@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 25, 2012 at 12:20 AM, Murali Karicheri <m-karicheri2@ti.com> wrote:

> +struct clk_davinci_pll_data {
> +       /* physical addresses set by platform code */
> +       u32 phy_pllm;
> +       /* if PLL has a prediv register this should be non zero */
> +       u32 phy_prediv;
> +       /* if PLL has a postdiv register this should be non zero */
> +       u32 phy_postdiv;
> +       /* mapped addresses. should be initialized by  */
> +       void __iomem *pllm;
> +       void __iomem *prediv;
> +       void __iomem *postdiv;
> +       u32 pllm_mask;
> +       u32 prediv_mask;
> +       u32 postdiv_mask;
> +       u32 num;
> +       /* framework flags */
> +       u32 flags;
> +       /* pll flags */
> +       u32 pll_flags;
> +       u32 fixed_prediv;       /* use this value for prediv */
> +       u32 pllm_multiplier;    /* multiply PLLM by this factor. By default
> +                                * most SOC set this to zero that translates
> +                                * to a multiplier of 1 and incrementer of 1.
> +                                * To override default, set this factor */
> +};

OMG this commenting style hurt my eyes ;-)

Please use good old kerneldoc above the struct instead.

Yours,
Linus Walleij
