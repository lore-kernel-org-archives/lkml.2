Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756441Ab1HXGY5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 02:24:57 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:60404 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756483Ab1HXGYx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 02:24:53 -0400
MIME-Version: 1.0
In-Reply-To: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 24 Aug 2011 14:24:32 +0800
Message-ID: <CAGsJ_4yCAcu3uiSuDQ13ai8tmnoDkniQymp6M7DGJi84AW4mBg@mail.gmail.com>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
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

> +int foo_list(struct pinmux_dev *pmxdev, unsigned selector)

pinctrl_dev?

> +{
> +       if (selector >= ARRAY_SIZE(myfuncs))
> +               return -EINVAL;
> +       return 0;
> +}
> +
> +const char *foo_get_fname(struct pinmux_dev *pmxdev, unsigned selector)

pinctrl_dev?

> +{
> +       if (selector >= ARRAY_SIZE(myfuncs))
> +               return NULL;
> +       return myfuncs[selector].name;
> +}
> +
> +static int foo_get_pins(struct pinmux_dev *pmxdev, unsigned selector,
> +                       unsigned ** const pins, unsigned * const num_pins)

pinctrl_dev?

> +{
> +       if (selector >= ARRAY_SIZE(myfuncs))
> +               return -EINVAL;
> +       *pins = myfuncs[selector].pins;
> +       *num_pins = myfuncs[selector].num_pins;
> +       return 0;
> +}
> +
> +int foo_enable(struct pinmux_dev *pmxdev, unsigned selector)
> +{
> +       if (selector < ARRAY_SIZE(myfuncs))
> +               write((read(MUX)|(1<<selector)), MUX)
> +               return 0;
> +       }
> +       return -EINVAL;
> +}
> +
> +int foo_disable(struct pinmux_dev *pmxdev, unsigned selector)

pinctrl_dev?

-barry
