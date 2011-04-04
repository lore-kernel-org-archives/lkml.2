Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab1DDTHJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 15:07:09 -0400
Received: from www.linutronix.de ([62.245.132.108]:51901 "EHLO linutronix.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754862Ab1DDTHI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 15:07:08 -0400
Date: Mon, 4 Apr 2011 21:07:03 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: john stultz <johnstul@us.ibm.com>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make clocksource name const
In-Reply-To: <1301941373.2319.28.camel@work-vm>
Message-ID: <alpine.LFD.2.00.1104042106160.19945@localhost6.localdomain6>
References: <20110219153450.GI29493@n2100.arm.linux.org.uk>  <20110402141134.GA23324@n2100.arm.linux.org.uk>  <1301938920.2319.2.camel@work-vm>  <alpine.LFD.2.00.1104041943580.19945@localhost6.localdomain6> <1301941373.2319.28.camel@work-vm>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 4 Apr 2011, john stultz wrote:

> On Mon, 2011-04-04 at 19:44 +0200, Thomas Gleixner wrote:
> > On Mon, 4 Apr 2011, john stultz wrote:
> > 
> > > On Sat, 2011-04-02 at 15:11 +0100, Russell King - ARM Linux wrote:
> > > > Has this patch been rejected?
> > > 
> > > No, just my clocksource cleanups tree didn't get pulled for 2.6.39.
> > 
> > Crap.
> 
> Sorry, I probably should have nagged you a bit more.
> 
> 
> > > Thomas: The commit can be found here:
> > > http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commit;h=36d8593ec74dc04d3bd7c1c897a7b7cfbd0b0dc6
> > 
> > Is there more stuff pending ?
> 
> Just clocksource_register_hz/khz bits, but those aren't critical, and
> can be moved in slowly via arch maintainers if you're not comfortable
> with them. I also need to refresh some of them, as there were some
> collisions in the merge window.

Just tried merging linus head into it, but that does not show any
conflicts.

Thanks,

	tglx
