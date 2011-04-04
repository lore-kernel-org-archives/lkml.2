Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755759Ab1DDVHV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 17:07:21 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:53488 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab1DDVHT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Apr 2011 17:07:19 -0400
Subject: Re: [PATCH] Make clocksource name const... RTC: Fix early irqs
 caused by calling rtc_set_alarm too early
From: john stultz <johnstul@us.ibm.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Thomas Gleixner <tglx@linutronix.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
In-Reply-To: <20110404202544.GB15070@dumpdata.com>
References: <20110219153450.GI29493@n2100.arm.linux.org.uk>
	 <20110402141134.GA23324@n2100.arm.linux.org.uk>
	 <1301938920.2319.2.camel@work-vm>
	 <alpine.LFD.2.00.1104041943580.19945@localhost6.localdomain6>
	 <1301941373.2319.28.camel@work-vm>
	 <alpine.LFD.2.00.1104042106160.19945@localhost6.localdomain6>
	 <20110404202544.GB15070@dumpdata.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Apr 2011 14:07:11 -0700
Message-ID: <1301951231.2319.45.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-04 at 16:25 -0400, Konrad Rzeszutek Wilk wrote:
> On Mon, Apr 04, 2011 at 09:07:03PM +0200, Thomas Gleixner wrote:
> > On Mon, 4 Apr 2011, john stultz wrote:
> > 
> > > On Mon, 2011-04-04 at 19:44 +0200, Thomas Gleixner wrote:
> > > > On Mon, 4 Apr 2011, john stultz wrote:
> > > > 
> > > > > On Sat, 2011-04-02 at 15:11 +0100, Russell King - ARM Linux wrote:
> > > > > > Has this patch been rejected?
> > > > > 
> > > > > No, just my clocksource cleanups tree didn't get pulled for 2.6.39.
> > > > 
> > > > Crap.
> > > 
> > > Sorry, I probably should have nagged you a bit more.
> > > 
> > > 
> > > > > Thomas: The commit can be found here:
> > > > > http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commit;h=36d8593ec74dc04d3bd7c1c897a7b7cfbd0b0dc6
> > > > 
> > > > Is there more stuff pending ?
> 
> How about the 'RTC: Fix early irqs caused by calling rtc_set_alarm too early'?
> I tried to search by the git commit dc6b812d1cde06df5c1acba394a79ca80785c776
> but didn't find it anymore?
> 
> It fixes a regression which inhibits Xen guests booting in 2.6.39.

Yep. That's still pending along with other RTC fixes, but in a different
branch:
http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=shortlog;h=refs/heads/fortglx/39/tip/timers/rtc

thanks
-john


