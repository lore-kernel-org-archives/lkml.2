Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754060Ab2JCLXZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 07:23:25 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37223 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754001Ab2JCLXV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 07:23:21 -0400
MIME-Version: 1.0
In-Reply-To: <1349195816-2225-18-git-send-email-arnd@arndb.de>
References: <1349195816-2225-1-git-send-email-arnd@arndb.de>
	<1349195816-2225-18-git-send-email-arnd@arndb.de>
Date: Wed, 3 Oct 2012 13:23:19 +0200
Message-ID: <CACRpkdYJs1NA8CUx8e551BPuvWr87LH8Lpb=nyxs9uZW4rtPAg@mail.gmail.com>
Subject: Re: [PATCH 17/17] ARM: soc: dependency warnings for errata
From: Linus Walleij <linus.walleij@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@infradead.org, arm@kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 2, 2012 at 6:36 PM, Arnd Bergmann <arnd@arndb.de> wrote:

> The PL310_ERRATA_753970 and ARM_ERRATA_764369 symbols only make sense
> when the base features for them are enabled, so select them
> conditionally in Kconfig to avoid warnings like:
>
> warning: (UX500_SOC_COMMON) selects PL310_ERRATA_753970 which has unmet direct dependencies (CACHE_PL310)
> warning: (ARCH_TEGRA_2x_SOC && ARCH_TEGRA_3x_SOC && UX500_SOC_COMMON) selects ARM_ERRATA_764369 which has unmet direct dependencies (CPU_V7 && SMP)
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Linus Walleij <linus.walleij@linaro.org>
> Cc: Stephen Warren <swarren@wwwdotorg.org>

Makes perfect sense.
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
