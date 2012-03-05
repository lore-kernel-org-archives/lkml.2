Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756028Ab2CEAcD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Mar 2012 19:32:03 -0500
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:47669 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752516Ab2CEAcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Mar 2012 19:32:01 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of mturquette@ti.com designates 10.14.99.204 as permitted sender) smtp.mail=mturquette@ti.com
MIME-Version: 1.0
In-Reply-To: <20120304203359.GE11546@lunn.ch>
References: <1330763341-3437-1-git-send-email-mturquette@linaro.org>
 <1330763341-3437-5-git-send-email-mturquette@linaro.org> <20120304203359.GE11546@lunn.ch>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 4 Mar 2012 16:31:31 -0800
Message-ID: <CAJOA=zNcyvfEmYtbSKFwyLniFbOnQvG4YPb9wbh1ajNATGoPsQ@mail.gmail.com>
Subject: Re: [PATCH] clk: Fix compile errors in DEFINE_CLK_GATE
To: Andrew Lunn <andrew@lunn.ch>
Cc: Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        linaro-dev@lists.linaro.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnd Bergman <arnd.bergmann@linaro.org>,
        Paul Walmsley <paul@pwsan.com>, Shawn Guo <shawn.guo@freescale.com>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Jamie Iles <jamie@jamieiles.com>,
        Richard Zhao <richard.zhao@linaro.org>,
        Saravana Kannan <skannan@codeaurora.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Rob Herring <rob.herring@calxeda.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Deepak Saxena <dsaxena@linaro.org>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q250W9vG028704

On Sun, Mar 4, 2012 at 12:33 PM, Andrew Lunn <andrew@lunn.ch> wrote:
> From 71e9a676b2b2f0dc2bb0cc395e8325cf38f4808b Mon Sep 17 00:00:00 2001
> From: Andrew Lunn <andrew@lunn.ch>
> Date: Sun, 4 Mar 2012 16:31:14 +0100
> Subject: [PATCH] [clk] Fix compile errors in DEFINE_CLK_GATE()
>
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Thanks Andrew.  Will roll this fix in.

Regards,
Mike

> ---
>  include/linux/clk-private.h |    4 ++--
>  1 files changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/clk-private.h b/include/linux/clk-private.h
> index d06e6fb..9d5c4b1 100644
> --- a/include/linux/clk-private.h
> +++ b/include/linux/clk-private.h
> @@ -95,7 +95,7 @@ extern struct clk_ops clk_gate_ops;
>                },                                              \
>                .reg = _reg,                                    \
>                .bit_idx = _bit_idx,                            \
> -               .flags = _gate_flags                            \
> +               .flags = _gate_flags,                           \
>                .lock = _lock,                                  \
>        };                                                      \
>        static struct clk _name = {                             \
> @@ -104,7 +104,7 @@ extern struct clk_ops clk_gate_ops;
>                .hw = &_name##_hw.hw,                           \
>                .parent_names = _name##_parent_names,           \
>                .num_parents =                                  \
> -                       ARRAY_SIZE(_name##parent_names),        \
> +                       ARRAY_SIZE(_name##_parent_names),       \
>                .parents = _name##_parents,                     \
>                .flags = _flags,                                \
>        };
> --
> 1.7.2.5
>
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
