Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759341Ab2CFWJs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 17:09:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:36341 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758988Ab2CFWJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 17:09:47 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus.walleij@linaro.org designates 10.50.41.161 as permitted sender) smtp.mail=linus.walleij@linaro.org
MIME-Version: 1.0
In-Reply-To: <4F567FE7.4020507@wwwdotorg.org>
References: <1331068552-16988-1-git-send-email-linus.walleij@stericsson.com>
	<4F567FE7.4020507@wwwdotorg.org>
Date: Tue, 6 Mar 2012 23:09:47 +0100
Message-ID: <CACRpkdYQUmPLdc-cZN80bEgfjNALDQ-gfaHy5d6Hrn_HsHMvtA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: split pincontrol states into its own header
From: Linus Walleij <linus.walleij@linaro.org>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 6, 2012 at 10:21 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:

> Sure. I'm not quite sure how many (or how many standardized) states we
> expect to have such that it warrants 'pinctrl-state.h' vs. say
> 'pinctrl-common.h', but it's probably fine.

We can just rename it as seems fit I guess...

> Acked-by: Stephen Warren <swarren@wwwdotorg.org>

I really like your new email address!

Yours,
Linus Walleij
