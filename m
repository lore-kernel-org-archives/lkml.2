Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1HXGSS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:18:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52803 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750988Ab1HXGSQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:18:16 -0400
MIME-Version: 1.0
In-Reply-To: <1313747646-32294-1-git-send-email-linus.walleij@stericsson.com>
References: <1313747646-32294-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 24 Aug 2011 14:17:55 +0800
Message-ID: <CAGsJ_4w+dkzHbYBehEzgK2+Js=BmAYe2gHKQ1PtYc=ymhovnDQ@mail.gmail.com>
Subject: Re: [PATCH 2/4 v4] pinmux: add a driver for the U300 pinmux
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Russell King <linux@arm.linux.org.uk>, Joe Perches <joe@perches.com>,
        Linaro Dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,
This patch can't compile....
> +
> +/**
> + * @dev: a pointer back to containing device
> + * @virtbase: the offset to the controller in virtual memory
> + */
> +struct u300_pmx {
> +       struct device *dev;
> +       struct pinmux_dev *pmx;

no this structure in head file, now it is pinctrl_desc.

> +       u32 phybase;
> +       u32 physize;
> +       void __iomem *virtbase;
> +};

> +       /* Now register the pin controller and all pins it handles */
> +       upmx->pctl = pinctrl_register(&u300_pmx_desc, &pdev->dev, upmx);

no this field in upmx structure.

> +       if (IS_ERR(upmx->pctl)) {

Did you send the wrong version?

-barry
