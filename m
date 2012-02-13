Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757742Ab2BMTsV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 14:48:21 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:64404 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab2BMTsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 14:48:20 -0500
MIME-Version: 1.0
In-Reply-To: <4F360853.3050402@nvidia.com>
References: <1328814050-22715-1-git-send-email-linus.walleij@linaro.org>
	<4F34A3EF.3070207@nvidia.com>
	<CACRpkdZ0kTXLAfdsfMjeZZX4W-fx5zyEdeGboKCmKSzCaMVw_A@mail.gmail.com>
	<4F360853.3050402@nvidia.com>
Date: Mon, 13 Feb 2012 20:48:19 +0100
Message-ID: <CACRpkdYm3sb7wbJP1M9HmjkGHq1YuT06ar6-+V1RoZ1QdoT9BA@mail.gmail.com>
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

On Sat, Feb 11, 2012 at 7:18 AM, Stephen Warren <swarren@nvidia.com> wrote:

> I'll probably want to rework the 3 patches your changes break anyway (in
> order to completely remove use of board-*-pinmux.c when booting from DT,
> once I write the DT code) and so you may as well not apply them, just
> the driver itself. It'll save some churn.

OK will that happen for this merge window or is the driver going to sit
unused for the 3.4 cycle?

I'm mainly thinking if the underlying driver may be subject to change I
could just keep it out-of-tree, unless you want it merged in for some
practical reason, then I'll just merge it.

Yours,
Linus Walleij
