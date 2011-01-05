Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753150Ab1AEX5U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 18:57:20 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:59874 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751470Ab1AEX5T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 18:57:19 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=sez_qNLefqAA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=pGLkceISAAAA:8 a=hUkyio-TcEk3fDsoQ1EA:9 a=EWkkyjAb0p1TIZ3BwXsA:7 a=mBfVSyCR_x1KsHHDaP4r-wcgl40A:4 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC patch 3/5] ftrace trace event add missing semicolumn
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>
In-Reply-To: <20110105234021.GC1692@nowhere>
References: <20110104231629.996422888@efficios.com>
	 <20110104232419.441463699@efficios.com> <20110105000005.GE2911@nowhere>
	 <20110105001837.GA9737@Krystal> <20110105020759.GG2911@nowhere>
	 <20110105023541.GA12950@Krystal> <20110105025848.GH2911@nowhere>
	 <20110105135242.GC31831@Krystal> <20110105150245.GA1692@nowhere>
	 <20110105195612.GA9709@Krystal>  <20110105234021.GC1692@nowhere>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 05 Jan 2011 18:57:16 -0500
Message-ID: <1294271836.26623.149.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 00:40 +0100, Frederic Weisbecker wrote:
> On Wed, Jan 05, 2011 at 02:56:12PM -0500, Mathieu Desnoyers wrote:
> > * Frederic Weisbecker (fweisbec@gmail.com) wrote:
> > [...]
> > > Looks good!
> > > 
> > > I might be missing corner things but it seems this would reduce the code
> > > footprint (one function less) and turn more rw into ro datas.
> > > 
> > > So it seems to be a very valuable reason to change the semicolon requirement
> > > all over the place.
> > > 
> > > If you come up with this feature along the massive semicolon requirement
> > > change, we will probably happily apply the whole.
> > > 
> > > But coming with only the semicolon change is more like an empty shell.
> > 
> > My proposal here is to incrementally improve the tracing code, starting by
> > cleaning up what is already there. I cannot do this if you keep asking me for
> > larger changes to both Ftrace and Perf before any of the prerequisite cleanups
> > can make their way in.
> > 
> > In this thread, I demonstrated that the TRACE_EVENT cleanup I proposed opens a
> > lot of code/data size reduction cleanups for Ftrace and Perf. But let's get the
> > cleanup in there first (it does not break the current way Ftrace and Perf are
> > working), and once all the code-base has moved to the semicolumn-less semantic,
> > then we can start improving Ftrace and Perf.
> 
> Don't be suprised of my reaction. The way the things were presented was:
> 
> 1) A patch with an meaningless changelog, absolutely no idea why that new
> semicolon is useful for.

Exactly... From the original change log:

"Add a missing semicolumn at the end of a ftrace definition.

We currently are not seeing any impact of this missing semicolumn because extra
semicolumns appear all over the place in the code generated from TRACE_EVENT
within ftrace stages."

Basically you state: We add this semicolon because ftrace already pushes
out lots of semicolons, so why not add more.

This is a totally useless changelog, and worthy of a nak because it has
no basis.

Yes, if there is a reason for doing this then state it.


> > As we say in French, "il ne faut pas mettre la charrue devant les boeufs"
> > (roughly: don't put the cart before the horse)
> 
> As we say in French, "oui mais il a fallu te tirer les vers du nez"
> (roughly: right, but still I had to worm it out of you)

As we say in English: "If it ain't broke, don't fix it!"

(roughly: Si ce n'est pas cassé, ne le correctif)

-- Steve


