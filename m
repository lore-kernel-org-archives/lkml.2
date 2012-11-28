Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751177Ab2K1CE6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 21:04:58 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:45856 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750943Ab2K1CE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 21:04:57 -0500
Date: Tue, 27 Nov 2012 18:04:43 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Li Zhong <zhong@linux.vnet.ibm.com>,
        Gilad.Ben-Yossef.gilad@benyossef.com
Subject: Re: [PATCH] context_tracking: New context tracking susbsystem
Message-ID: <20121128020443.GW2474@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1354041205-6989-1-git-send-email-fweisbec@gmail.com>
 <20121128005942.GV2474@linux.vnet.ibm.com>
 <1354067438.6276.92.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354067438.6276.92.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12112802-5806-0000-0000-00001C3FF36A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 27, 2012 at 08:50:38PM -0500, Steven Rostedt wrote:
> On Tue, 2012-11-27 at 16:59 -0800, Paul E. McKenney wrote:
> > On Tue, Nov 27, 2012 at 07:33:25PM +0100, Frederic Weisbecker wrote:
> > > Create a new subsystem that probes on kernel boundaries
> > > to keep track of the transitions between level contexts
> > > with two basic initial contexts: user or kernel.
> > > 
> > > This is an abstraction of some RCU code that use such tracking
> > > to implement its userspace extended quiescent state.
> > > 
> > > We need to pull this up from RCU into this new level of indirection
> > > because this tracking is also going to be used to implement an "on
> > > demand" generic virtual cputime accounting. A necessary step to
> > > shutdown the tick while still accounting the cputime.
> > 
> > I have queued this, and if it passes tests and inspection will try
> > pushing it for 3.8.
> > 
> 
> You can add my Reviewed-by: Steven Rostedt <rostedt@goodmis.org> if you
> like.

Very happy to do so!  ;-)

							Thanx, Paul

