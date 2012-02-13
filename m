Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab2BMRmQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 12:42:16 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:59660 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755598Ab2BMRmP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 12:42:15 -0500
X-Authority-Analysis: v=2.0 cv=HeuWv148 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=RlPbyBo6Jk8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=QyXUC8HyAAAA:8 a=pGLkceISAAAA:8 a=aEFmuOA79UuxNKwCW3oA:9 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1329154933.25686.5.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v3] printk: add console output tracing
From: Steven Rostedt <rostedt@goodmis.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>
Date: Mon, 13 Feb 2012 12:42:13 -0500
In-Reply-To: <1329154424.3365.8.camel@jlt3.sipsolutions.net>
References: <20111117145502.GA18437@somewhere>
	 <1321541877.3997.31.camel@jlt3.sipsolutions.net>
	 <20111117150040.GB18437@somewhere>
	 <1321543268.3997.40.camel@jlt3.sipsolutions.net>
	 <20111118184401.GA24787@somewhere.redhat.com>
	 <1321641975.10266.73.camel@jlt3.sipsolutions.net>
	 <20111118185449.GB24787@somewhere.redhat.com>
	 <1321642752.10266.75.camel@jlt3.sipsolutions.net>
	 <20111123131622.GA10669@somewhere.redhat.com>
	 <1322140919.5366.17.camel@jlt3.sipsolutions.net>
	 <20111124154519.GB18579@somewhere.redhat.com>
	 (sfid-20111124_164601_383201_AB72557F) <1322161388.5366.54.camel@jlt3.sipsolutions.net>
	 <1329154226.25686.4.camel@gandalf.stny.rr.com>
	 <1329154424.3365.8.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-13 at 18:33 +0100, Johannes Berg wrote:
> On Mon, 2012-02-13 at 12:30 -0500, Steven Rostedt wrote:
> > On Thu, 2011-11-24 at 20:03 +0100, Johannes Berg wrote:
> > > From: Johannes Berg <johannes.berg@intel.com>
> > > 
> > > Add a printk.console trace point to record any printk
> > > messages into the trace, regardless of the current
> > > console loglevel. This can help correlate (existing)
> > > printk debugging with other tracing.
> > > 
> > 
> > Looks like this patch got lost in the x-mas parade.
> > 
> > Is this the last version of the patch?
> > 
> > In the thread I also see:
> > 
> > Acked-by: Frederic Weisbecker <fweisbec@gmail.com>
> > Acked-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
> > Acked-by-me (Thomas Gleixner)
> 
> I don't think I made a newer version, in fact, I dropped it from my
> local tree already :)

Well, then, I'll add it to my current queue then. I'll include the above
acked-bys too if no one is against it. Speak now if you are! ;-)

-- Steve


