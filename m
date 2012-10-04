Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965593Ab2JDIxB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 04:53:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:61530 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965535Ab2JDIw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 04:52:59 -0400
MIME-Version: 1.0
In-Reply-To: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
References: <1349340644-13937-1-git-send-email-sboyd@codeaurora.org>
Date: Thu, 4 Oct 2012 14:22:58 +0530
X-Google-Sender-Auth: uAnEqXvzffPQKLKcU9AbycqZVSA
Message-ID: <CAOh2x=k3aX2VOsNTjgCT8r1Re5T66emvhSmA_MBfS0JmSN9Uqg@mail.gmail.com>
Subject: Re: [PATCH] ARM: Push selects for TWD/SCU into machine entries
From: viresh kumar <viresh.kumar@linaro.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        David Brown <davidb@codeaurora.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <rob.herring@calxeda.com>,
        Russell King <linux@arm.linux.org.uk>,
        Sascha Hauer <kernel@pengutronix.de>,
        Shiraz Hashim <shiraz.hashim@st.com>,
        Simon Horman <horms@verge.net.au>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Tony Lindgren <tony@atomide.com>,
        spear-devel <spear-devel@list.st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 4, 2012 at 2:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
>  arch/arm/plat-spear/Kconfig    | 2 ++

> diff --git a/arch/arm/plat-spear/Kconfig b/arch/arm/plat-spear/Kconfig
> index 4404f82..a090ea3 100644
> --- a/arch/arm/plat-spear/Kconfig
> +++ b/arch/arm/plat-spear/Kconfig
> @@ -14,6 +14,8 @@ config ARCH_SPEAR13XX
>         select CPU_V7
>         select USE_OF
>         select HAVE_SMP
> +       select HAVE_ARM_SCU if SMP
> +       select HAVE_ARM_TWD if LOCAL_TIMERS
>         select MIGHT_HAVE_CACHE_L2X0
>         select PINCTRL
>         help

For SPEAr:
Acked-by: Viresh Kumar <viresh.kumar@linaro.org>
