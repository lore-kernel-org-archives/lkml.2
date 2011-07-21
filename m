Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500Ab1GUPnB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 11:43:01 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43146 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752357Ab1GUPnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 11:43:00 -0400
Date: Thu, 21 Jul 2011 16:41:52 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: David Brown <davidb@codeaurora.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] MSM fix
Message-ID: <20110721154152.GP26574@n2100.arm.linux.org.uk>
References: <20110720203703.GA4495@huya.qualcomm.com> <20110720225010.GA18381@huya.qualcomm.com> <20110720225406.GB20310@n2100.arm.linux.org.uk> <201107211649.39902.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201107211649.39902.arnd@arndb.de>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 21, 2011 at 04:49:39PM +0200, Arnd Bergmann wrote:
> On Thursday 21 July 2011, Russell King - ARM Linux wrote:
> > > It looks like it would apply to 2.6.38 and 39 as well.  I'm not sure
> > > it qualifies under the "It must fix a real bug that bothers people".
> > > It would only apply if someone had set NR_CPUS to more than 2.
> > 
> > Err, this makes no sense.  MSM doesn't have a get_core_count function
> > and as far as I can see never has done in mainline.
> 
> I've committed the version below now, with a clarified title.
> The patch looks reasonable to me, but there may be some issue
> I'm missing of course. The other platforms that used to have
> a get_core_count function no longer have that because you changed
> them to use scu_get_core_count, but that doesn't seem to apply
> to mach-msm.

That patch description helps a lot to clarify what's going on.
