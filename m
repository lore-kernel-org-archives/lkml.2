Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752578Ab1GTWyj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 18:54:39 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60807 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab1GTWyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 18:54:38 -0400
Date: Wed, 20 Jul 2011 23:54:06 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: David Brown <davidb@codeaurora.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MSM fix
Message-ID: <20110720225406.GB20310@n2100.arm.linux.org.uk>
References: <20110720203703.GA4495@huya.qualcomm.com> <1989166.1WcWHOXyl7@wuerfel> <20110720225010.GA18381@huya.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720225010.GA18381@huya.qualcomm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 03:50:10PM -0700, David Brown wrote:
> On Wed, Jul 20, 2011 at 11:06:15PM +0200, Arnd Bergmann wrote:
> > On Wednesday 20 July 2011 13:37:03 David Brown wrote:
> > > I seem to have missed this fix when it was sent out in April.
> > > 
> > > The following changes since commit 620917de59eeb934b9f8cf35cc2d95c1ac8ed0fc:
> > > 
> > >   Linux 3.0-rc7 (2011-07-11 16:51:52 -0700)
> > > 
> > > are available in the git repository at:
> > >   git://codeaurora.org/quic/kernel/davidb/linux-msm.git msm-fix
> > > 
> > > Jeff Ohlstein (1):
> > >       msm: platsmp: actually read core count in get_core_count
> > > 
> > 
> > Hmm, this one seems like it really applies to older kernels as well, so
> > we can just as well add a cc:stable@kernel.org tag and put it into the
> > arm-soc/next/fixes branch, right?
> 
> It looks like it would apply to 2.6.38 and 39 as well.  I'm not sure
> it qualifies under the "It must fix a real bug that bothers people".
> It would only apply if someone had set NR_CPUS to more than 2.

Err, this makes no sense.  MSM doesn't have a get_core_count function
and as far as I can see never has done in mainline.

And where is the patch?

We shouldn't be pulling git requests into arm-soc without having seen
the patches on LAKML.
