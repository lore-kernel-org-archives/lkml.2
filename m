Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751444Ab2AXVvs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 16:51:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:34575 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751164Ab2AXVvr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 16:51:47 -0500
MIME-Version: 1.0
In-Reply-To: <20120120161722.21955.90415.stgit@kaulin.local>
References: <20120120161610.21955.25082.stgit@kaulin.local>
	<20120120161722.21955.90415.stgit@kaulin.local>
Date: Tue, 24 Jan 2012 22:51:47 +0100
Message-ID: <CACRpkdadp-0DW8kAPGvuBKsDHAtzxgwSf_fn4nAdj-tpanXHxQ@mail.gmail.com>
Subject: Re: [PATCH 1/4] pinctrl: Free debugfs entries when unloading a pinmux driver
From: Linus Walleij <linus.walleij@linaro.org>
To: Tony Lindgren <tony@atomide.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Barry Song <21cnbao@gmail.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Shawn Guo <shawn.guo@freescale.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 20, 2012 at 5:17 PM, Tony Lindgren <tony@atomide.com> wrote:

> Free debugfs entries when unloading a pinmux driver
>
> Signed-off-by: Tony Lindgren <tony@atomide.com>

Thanks, patch applied.

Yours,
Linus Walleij
