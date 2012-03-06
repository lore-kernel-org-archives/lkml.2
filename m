Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756107Ab2CFVVt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 16:21:49 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:49946 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754910Ab2CFVVs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 16:21:48 -0500
Message-ID: <4F567FE7.4020507@wwwdotorg.org>
Date: Tue, 06 Mar 2012 14:21:43 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@stericsson.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Stephen Warren <swarren@nvidia.com>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: Re: [PATCH] pinctrl: split pincontrol states into its own header
References: <1331068552-16988-1-git-send-email-linus.walleij@stericsson.com>
In-Reply-To: <1331068552-16988-1-git-send-email-linus.walleij@stericsson.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/06/2012 02:15 PM, Linus Walleij wrote:
> From: Linus Walleij <linus.walleij@linaro.org>
> 
> Move the pin control state defines into its own header file,
> since it is used both by machine.h which is facing the platform
> and by consumer.h which is facing the drivers, and pinctrl.h
> which is pinctrl-driver internal, let's not have each and every
> .h file include all others, then isolation is moot.
> 
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Sure. I'm not quite sure how many (or how many standardized) states we
expect to have such that it warrants 'pinctrl-state.h' vs. say
'pinctrl-common.h', but it's probably fine.

Acked-by: Stephen Warren <swarren@wwwdotorg.org>
