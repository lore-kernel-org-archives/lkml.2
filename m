Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752388Ab1GTWuN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:50:13 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:27213 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1GTWuM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:50:12 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6413"; a="104759405"
Date: Wed, 20 Jul 2011 15:50:10 -0700
From: David Brown <davidb@codeaurora.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MSM fix
Message-ID: <20110720225010.GA18381@huya.qualcomm.com>
References: <20110720203703.GA4495@huya.qualcomm.com>
 <1989166.1WcWHOXyl7@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1989166.1WcWHOXyl7@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:06:15PM +0200, Arnd Bergmann wrote:
> On Wednesday 20 July 2011 13:37:03 David Brown wrote:
> > I seem to have missed this fix when it was sent out in April.
> > 
> > The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:
> > 
> >   Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)
> > 
> > are available in the git repository at:
> >   git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-fix
> > 
> > Jeff Ohlstein (1):
> >       msm: platsmp: actually read core count in get_core_count
> > 
> 
> Hmm, this one seems like it really applies to older kernels as well, so
> we can just as well add a cc:stable@kernel.org tag and put it into the
> arm-soc/next/fixes branch, right?

It looks like it would apply to 2.6.38 and 39 as well.  I'm not sure
it qualifies under the "It must fix a real bug that bothers people".
It would only apply if someone had set NR_CPUS to more than 2.

> Linus has just pulled the 'last arm-soc fixes for 3.0' branch, and I don't
> really want to follow up with 'last fix, this time for real' pull request
> unless it's for a serious regression.

It's not serious, so 3.1 is fine.

> On a related topic, what's the deal with the msm-core and msm-move-gpio
> branches in the same tree? I have the impression that they should be
> in arm-soc.git, but I never received a pull request.

I had sent a pull request for msm-move-gpio to Grant, but apparently
that didn't happen.  If more appropriate, I can send one to you for
it, or resend to Grant.

The msm-core stuff happened before the snafu about ARM, and I was
holding off on these things.  The authors of these patches say they
are working on cleaned up versions.

I'm not sure we want the dummy clocks code in the kernel.  It's
intended as a placeholder.  Stephen Boyd has a 26-series patch that
adds better clock support.  Given the size (13047 insertions), this
may need some cleanup or even device-tree work to include.

Unfortunately, a lot of the Qualcomm development seems to have moved
back to private trees.

BTW, I am planning on being at the Linaro Connect in August.

David

-- 
Sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.
