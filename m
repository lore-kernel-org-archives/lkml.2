Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234Ab1HYPMO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Aug 2011 11:12:14 -0400
Received: from wolverine01.qualcomm.com ([199.106.114.254]:24221 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753975Ab1HYPML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Aug 2011 11:12:11 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6448"; a="112892858"
Date: Thu, 25 Aug 2011 08:12:10 -0700
From: David Brown <davidb@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>, rvaswani@codeaurora.org,
        gbean@codeaurora.org
Cc: Stephen Warren <swarren@nvidia.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Lee Jones <lee.jones@linaro.org>, Joe Perches <joe@perches.com>,
        Russell King <linux@arm.linux.org.uk>,
        Linaro Dev <linaro-dev@lists.linaro.org>,
        ext Tony Lindgren <tony@atomide.com>,
        David Brown <davidb@codeaurora.org>,
        Sascha Hauer <kernel@pengutronix.de>
Subject: Re: [PATCH 1/4 v4] drivers: create a pin control subsystem
Message-ID: <20110825151210.GC31331@huya.qualcomm.com>
References: <1313747630-32258-1-git-send-email-linus.walleij@stericsson.com>
 <74CDBE0F657A3D45AFBB94109FB122FF04B24A3BC0@HQMAIL01.nvidia.com>
 <CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdaZfG4hiGf8vug3EGMRMc0c92xbj=L_HAQcS27DAXYc4Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 25, 2011 at 12:12:59PM +0200, Linus Walleij wrote:

> mach-msm:
> ----------------
> 
> Hard to tell how this works and what's available, support
> seems to be incomplete. Currently it seems to be wired
> to do either a dedicated function (like some UART pin)
> or GPIO, like each pin can be used for two specific
> things, and not phone-exchange type.

There are some pins on MSMs that can be connected to different hw
blocks, we just haven't gotten the support into the kernel yet.

There are some things where two devices share pins, and you have to
choose one or the other.

I believe there are also configurations where something such as the SD
controller can either be configured in 8-bit data mode, or in 4-bit
data mode, and those 4 pins connected to something else.

Much of the current pin configuration in our product kernel seems to
be about current and pull up/down configuration.

I've added Rohit Vaswani, and Greg Bean to this thread who should have
a bit better understanding of this.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
