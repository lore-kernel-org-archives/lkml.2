Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753994Ab2GNWSO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 18:18:14 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:40014 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751310Ab2GNWSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 18:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <1342175967-10087-5-git-send-email-ldewangan@nvidia.com>
References: <1342175967-10087-1-git-send-email-ldewangan@nvidia.com>
	<1342175967-10087-5-git-send-email-ldewangan@nvidia.com>
Date: Sun, 15 Jul 2012 00:18:05 +0200
Message-ID: <CACRpkdadrHaH0kCfn22T+GnO=TKNvexcup+TsajPgnQgkiQ9Gw@mail.gmail.com>
Subject: Re: [PATCH 4/5] gpio: tps6586x: add gpio support through platform driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, linus.walleij@stericsson.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org,
        swarren@nvidia.com, broonie@opensource.wolfsonmicro.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 13, 2012 at 12:39 PM, Laxman Dewangan <ldewangan@nvidia.com> wrote:

> Converting the gpio driver of tps6586x to a platform
> driver in place of registering the gpio through core
> driver.
> The motivation of the change is:
> - This is inline with the mfd drivers implementation.
> - This will move the related gpio support to gpio driver
>   folder where all gpio related drivers are available.
>   This will be easy the maintenance and enhancement is
>   anything done for gpio.
> - The gpio functionality can be selected through config
>   variable.
>
> Signed-off-by: Laxman Dewangan <ldewangan@nvidia.com>

Overall this is very, very good and you're doing the right thing.

> --- /dev/null
> +++ b/drivers/gpio/gpio-tps6586x.c

> +#include <linux/i2c.h>

Why?

Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
