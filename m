Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758465Ab2EOPU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:20:27 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:57523 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756421Ab2EOPUZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:20:25 -0400
Date: Tue, 15 May 2012 08:19:58 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>, smuckle@quicinc.com, khilman@ti.com,
        Robin.Randhawa@arm.com, suresh.b.siddha@intel.com,
        thebigcorporation@gmail.com, venki@google.com,
        panto@antoniou-consulting.com, mingo@elte.hu, paul.brett@intel.com,
        pdeschrijver@nvidia.com, pjt@google.com, efault@gmx.de,
        fweisbec@gmail.com, geoff@infradead.org, rostedt@goodmis.org,
        tglx@linutronix.de, amit.kucheria@linaro.org,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linaro-sched-sig@lists.linaro.org,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
        Juri Lelli <juri.lelli@gmail.com>
Subject: Re: Plumbers: Tweaking scheduler policy micro-conf RFP
Message-ID: <20120515151958.GD2461@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <CAKfTPtDSDAOAdv0GTDswZeRM7TmACrjok+5kddSaQpvy6_6xWw@mail.gmail.com>
 <CAKfTPtCfiY7A29+e50F+6awd8BjNJjg4=uNN4ReZfdS_4FbpkA@mail.gmail.com>
 <1337084609.27020.156.camel@laptop>
 <CAKfTPtDz1-fR2i5x7AVd8sGZhX2VNtz2rnQC3ePrcHO9MWK3FQ@mail.gmail.com>
 <1337086834.27020.162.camel@laptop>
 <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKfTPtDrZ-tfC81jnxwpB+DCtmxhU+VfoYbtSBr8MkFt+P8JcA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12051515-4242-0000-0000-000001AB62D8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 05:05:47PM +0200, Vincent Guittot wrote:
> On 15 May 2012 15:00, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Tue, 2012-05-15 at 14:57 +0200, Vincent Guittot wrote:
> >>
> >> Not sure that nobody cares but it's much more that scheduler,
> >> load_balance and sched_mc are sensible enough that it's difficult to
> >> ensure that a modification will not break everything for someone
> >> else.
> >
> > Thing is, its already broken, there's nothing else to break :-)
> 
> sched_mc is the only power-aware knob in the current scheduler. It's
> far from being perfect but it seems to work on some ARM platform at
> least. You mentioned at the scheduler mini-summit that we need a
> cleaner replacement and everybody has agreed on that point. Is anybody
> working on it yet ? and can we discuss at Plumber's what this
> replacement would look like ?

Hello, Vincent,

If I understand the patch from a first glance, Peter is doing what
everyone agreed to at the scheduler minisummit back in February.
>From the notes from that meeting at:

https://wiki.linaro.org/WorkingGroups/PowerManagement/Doc/HMPscheduling

See the line reading "Remove sched_mc. [Peter Zijlstra]".

Or am I confused about what Peter's patch does?

							Thanx, Paul

