Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933171Ab2AIXD6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 18:03:58 -0500
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:54913 "EHLO
	out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932589Ab2AIXDy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 18:03:54 -0500
X-Sasl-enc: DckS/PPByI6RhBcMYMXLAiUQJNEL3M52gAPD5VromKvx 1326150233
Date: Mon, 9 Jan 2012 15:02:29 -0800
From: Greg KH <greg@kroah.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Frank Mandarino <fmandarino@endrelia.com>, Liam Girdwood <lrg@ti.com>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org
Subject: Re: Public ridicule due to sound/soc/soc-core.c abuse of the driver
 model
Message-ID: <20120109230229.GA11470@kroah.com>
References: <20120106194052.GA7781@kroah.com>
 <20120106201458.GF2893@opensource.wolfsonmicro.com>
 <20120106205036.GB13857@n2100.arm.linux.org.uk>
 <20120106234135.GH2893@opensource.wolfsonmicro.com>
 <20120106234445.GC13857@n2100.arm.linux.org.uk>
 <20120106234923.GI2893@opensource.wolfsonmicro.com>
 <20120109095125.GG21765@n2100.arm.linux.org.uk>
 <20120109195211.GA30766@opensource.wolfsonmicro.com>
 <20120109201110.GA8377@kroah.com>
 <20120109203129.GA25743@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120109203129.GA25743@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 09, 2012 at 12:31:30PM -0800, Mark Brown wrote:
> On Mon, Jan 09, 2012 at 12:11:10PM -0800, Greg KH wrote:
> > On Mon, Jan 09, 2012 at 07:52:13PM +0000, Mark Brown wrote:
> 
> > > Trying to make any sort of modification to code this fragile is risky,
> > > especially during what's supposed to be a stabalization phase (which is
> > > what Greg is requesting).  It just seems completely irresponsible for
> > > something that isn't actually a practical problem.
> 
> > I find it hard to believe that ignoring the driver model is not a
> > "practical" problem :)
> 
> > For details as to why this is a problem, please see the kobject.txt
> > file.
> 
> Sure, I'm fully aware of the issue.  The reason this is so painful to
> work with is that AC'97 is just generally doing a really bad job of
> using the driver model.
> 
> > Please fix this up, as you have seen, people end up cutting-and-pasting
> > bad code.
> 
> In my copious free time, but like I say trying to do this for 3.3 (you
> only posted *after* the merge window opened) is just nuts and I'd rather
> hope someone who cares about AC'97 systems will come forward and work on
> it (having one would be a real bonus).  If people actually had problems
> we were fixing that'd be one thing but if they do they're being
> extremely quiet about it.

Ok, fair enough, if this is fixed by 3.4, I'll be happy.

thanks,

greg k-h
