Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756038Ab2ITQI4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 12:08:56 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:59093 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728Ab2ITQIy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 12:08:54 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6841"; a="236905564"
Date: Thu, 20 Sep 2012 09:08:53 -0700
From: David Brown <davidb@codeaurora.org>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Boyd <sboyd@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Grant Likely <grant.likely@secretlab.ca>,
        Rohit Vaswani <rvaswani@codeaurora.org>
Subject: Re: [PATCH 4/5] gpio: Make gpio-msm-v1 into a platform driver
Message-ID: <20120920160852.GA6907@codeaurora.org>
References: <1348038044-1790-1-git-send-email-sboyd@codeaurora.org>
 <1348038044-1790-5-git-send-email-sboyd@codeaurora.org>
 <CACRpkdZZ4y2TpkDAgxp38hLbsvxV3hqQ0PRjEQ1s+CXuq8TVQg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZZ4y2TpkDAgxp38hLbsvxV3hqQ0PRjEQ1s+CXuq8TVQg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 08:45:50AM +0200, Linus Walleij wrote:
> On Wed, Sep 19, 2012 at 9:00 AM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> 
> > Doing this removes the dependence of this driver on the
> > msm_iomap.h and cpu.h mach include headers provied by MSM. This
> > is necessary to support single zImage work in the future and
> > allows us to remove cpu.h entirely and brings us closer to
> > removing msm_iomap.h.
> >
> > Cc: Grant Likely <grant.likely@secretlab.ca>
> > Cc: Linus Walleij <linus.walleij@linaro.org>
> > Cc: Rohit Vaswani <rvaswani@codeaurora.org>
> > Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> This must be encouraged:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>
> 
> Stephen, do you have a mainline-based kernel tree that can boot
> on my DragonBoard? It's just sitting idle here... I pushed David
> in the past, just naggin'...

We're working on it :-)

The main thing coming that's needed are clocks.  There are some more
things (such as regulators) that will be needed to get things like
SD/MMC working, and that'll be next.

David

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
