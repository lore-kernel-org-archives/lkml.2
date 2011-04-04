Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755603Ab1DDU0S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Apr 2011 16:26:18 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:58838 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755502Ab1DDU0Q (ORCPT
	<rfc822;<linux-kernel@vger.kernel.org>>);
	Mon, 4 Apr 2011 16:26:16 -0400
Date: Mon, 4 Apr 2011 16:25:44 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: john stultz <johnstul@us.ibm.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Make clocksource name const... RTC: Fix early irqs
 caused by calling rtc_set_alarm too early
Message-ID: <20110404202544.GB15070@dumpdata.com>
References: <20110219153450.GI29493@n2100.arm.linux.org.uk>
 <20110402141134.GA23324@n2100.arm.linux.org.uk>
 <1301938920.2319.2.camel@work-vm>
 <alpine.LFD.2.00.1104041943580.19945@localhost6.localdomain6>
 <1301941373.2319.28.camel@work-vm>
 <alpine.LFD.2.00.1104042106160.19945@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1104042106160.19945@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt357.oracle.com [141.146.40.157]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4D9A294C.0114:SCFSTAT5015188,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 04, 2011 at 09:07:03PM +0200, Thomas Gleixner wrote:
> On Mon, 4 Apr 2011, john stultz wrote:
> 
> > On Mon, 2011-04-04 at 19:44 +0200, Thomas Gleixner wrote:
> > > On Mon, 4 Apr 2011, john stultz wrote:
> > > 
> > > > On Sat, 2011-04-02 at 15:11 +0100, Russell King - ARM Linux wrote:
> > > > > Has this patch been rejected?
> > > > 
> > > > No, just my clocksource cleanups tree didn't get pulled for 2.6.39.
> > > 
> > > Crap.
> > 
> > Sorry, I probably should have nagged you a bit more.
> > 
> > 
> > > > Thomas: The commit can be found here:
> > > > http://git.linaro.org/gitweb?p=people/jstultz/linux.git;a=commit;h=36d8593ec74dc04d3bd7c1c897a7b7cfbd0b0dc6
> > > 
> > > Is there more stuff pending ?

How about the 'RTC: Fix early irqs caused by calling rtc_set_alarm too early'?
I tried to search by the git commit dc6b812d1cde06df5c1acba394a79ca80785c776
but didn't find it anymore?

It fixes a regression which inhibits Xen guests booting in 2.6.39.
