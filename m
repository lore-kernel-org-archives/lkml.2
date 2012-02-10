Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932510Ab2BJUve (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 15:51:34 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34551 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932399Ab2BJUvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 15:51:33 -0500
MIME-Version: 1.0
In-Reply-To: <4F34A3EF.3070207@nvidia.com>
References: <1328814050-22715-1-git-send-email-linus.walleij@linaro.org>
	<4F34A3EF.3070207@nvidia.com>
Date: Fri, 10 Feb 2012 21:51:32 +0100
Message-ID: <CACRpkdZ0kTXLAfdsfMjeZZX4W-fx5zyEdeGboKCmKSzCaMVw_A@mail.gmail.com>
Subject: Re: [PATCH 0/3] pinctrl: move the core per-device handlers to core
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@nvidia.com>
Cc: Olof Johansson <olof@lixom.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 10, 2012 at 5:58 AM, Stephen Warren <swarren@nvidia.com> wrote:

>> These three patches take the first step in this transformation by moving
>> the per-device handles over to core code, and renaming all related
>> functions with the pinctrl_* prefix.
>
> The series,
> Acked-by: Stephen Warren <swarren@nvidia.com>

Thanks, I've managed to push this to -next with the v2 version of
[2/3] and the hog patch.

> Note that this series will cause some compile breakage in the series I
> previously posted to add a pinctrl-tegra driver and convert mach-tegra
> to use it. The following patches in that series should still be OK:
>
> pinctrl: add a driver for NVIDIA Tegra
> ARM: tegra: Select PINCTRL Kconfig variables
>
> ... so you can still go ahead and apply those, but the following will be
> broken:
>
> ARM: tegra: Switch to new pinctrl driver
> ARM: tegra: Remove pre-pinctrl pinmux driver
>
> also the separately posted:
>
> ARM: tegra: Add pinmux board file for Cardhu
>
> I'll probably hold off reposting those last 3; with any luck they'll be
> eclipsed by my implementing full DT binding support in the near future,
> given our consensus on that topic following discussion at Linaro Connect.

OK, alternatively I could remove these for the time being, or I
can fix up the mess I created if you prefer, by just adding
a patch on top, so it gets changed over no matter if the
DT stuff gets sorted out for this merge window?

Thanks,
Linus Walleij
