Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752276Ab2DBFRN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 01:17:13 -0400
Received: from na3sys009aog119.obsmtp.com ([74.125.149.246]:51104 "EHLO
	na3sys009aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750764Ab2DBFRM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 01:17:12 -0400
MIME-Version: 1.0
In-Reply-To: <1333290683-11815-1-git-send-email-broonie@opensource.wolfsonmicro.com>
References: <1333290683-11815-1-git-send-email-broonie@opensource.wolfsonmicro.com>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Sun, 1 Apr 2012 22:16:49 -0700
Message-ID: <CAJOA=zO5z=QRf4Nr8g-DmjNOC-Dta6yJtZSjhENgz528BNCLbw@mail.gmail.com>
Subject: Re: [PATCH] clk: Remove comment for end of CONFIG_COMMON_CLK section
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 1, 2012 at 7:31 AM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> The comment is inaccurate (it actually ends the CONFIG_COMMON_CLK
> section, there's no else) and given that we've just got a single level
> of ifdef isn't really needed anyway.
>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Hi Mark,

I'm happy to take this into my next-clk/fixes branch (which I'll be
sending out shortly).

Regards,
Mike

> ---
>  include/linux/clk.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index b025272..c9547d9 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -81,7 +81,7 @@ int clk_notifier_register(struct clk *clk, struct notifier_block *nb);
>
>  int clk_notifier_unregister(struct clk *clk, struct notifier_block *nb);
>
> -#endif /* !CONFIG_COMMON_CLK */
> +#endif
>
>  /**
>  * clk_get - lookup and obtain a reference to a clock producer.
> --
> 1.7.9.1
>
