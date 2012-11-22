Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030223Ab2KVTuk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:50:40 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:40432 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030199Ab2KVTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <20121122031117.GE25470@core.coreip.homeip.net>
References: <1353403339-11679-1-git-send-email-dmitry.torokhov@gmail.com>
	<1353403339-11679-2-git-send-email-dmitry.torokhov@gmail.com>
	<CAKohpo=B_7rVwePziyNe0rTMokcib_FgEN28cy4nByAzbUyaqg@mail.gmail.com>
	<20121121204324.21126.99677@nucleus>
	<20121121205424.GA25470@core.coreip.homeip.net>
	<20121121223859.GQ3290@n2100.arm.linux.org.uk>
	<20121122021750.GD25470@core.coreip.homeip.net>
	<20121122031117.GE25470@core.coreip.homeip.net>
Date: Thu, 22 Nov 2012 08:56:04 +0530
Message-ID: <CAKohpo=emfJgjm8cg0yS+qoaB-kmxHP1to9B-Krn0+_pyrWf_w@mail.gmail.com>
Subject: Re: [PATCH 1/3] CLK: uninline clk_prepare() and clk_unprepare()
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Mike Turquette <mturquette@ti.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 22 November 2012 08:41, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:

> CLK: get rid of HAVE_CLK_PREPARE
>
> From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
>
> HAVE_CLK_PREPARE is automatically selected by COMMON_CLK and the only
> platform that explicitly selects HAVE_CLK_PREPARE is MXS which has been
> switched to common clk framework, so we can delete this option now.
>
> As part of this change we move declarations of clk_prepare() and
> clk_unprepare() under HAVE_CLK and provide stubs if this option is not
> enabled.
>
> Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> ---
>  drivers/clk/Kconfig |    4 ---
>  include/linux/clk.h |   68 ++++++++++++++++++++++++---------------------------

Fix imx select line as pointed out by Mike and add:

Reviewed-by: Viresh Kumar <viresh.kumar@linaro.org>
