Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751369Ab1KCNTb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 09:19:31 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:48589 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751038Ab1KCNTa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 09:19:30 -0400
X-Authority-Analysis: v=1.1 cv=rFxaVhpzdNKRsWyFDFmDbYx/QEtlW7L1Gw9MiLxO4aw= c=1 sm=0 a=FTm68WEYJR0A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=pGLkceISAAAA:8 a=VnNF1IyMAAAA:8 a=EynvLNx38X06vFxnQVQA:9 a=PUjeQqilurYA:10 a=MSl-tDqOz04A:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1320326366.27370.1.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH RFC tip/core/rcu 17/28] rcu: Make srcu_read_lock_held()
 call common lockdep-enabled function
From: Steven Rostedt <rostedt@goodmis.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, patches@linaro.org
Date: Thu, 03 Nov 2011 09:19:26 -0400
In-Reply-To: <20111103111413.GC8198@somewhere.redhat.com>
References: <20111102203017.GA3830@linux.vnet.ibm.com>
	 <1320265849-5744-17-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20111103034854.GD2042@leaf> <20111103111413.GC8198@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-11-03 at 12:14 +0100, Frederic Weisbecker wrote:
> On Wed, Nov 02, 2011 at 08:48:54PM -0700, Josh Triplett wrote:
> > On Wed, Nov 02, 2011 at 01:30:38PM -0700, Paul E. McKenney wrote:
> > > From: Frederic Weisbecker <fweisbec@gmail.com>
> > > 
> > > A common debug_lockdep_rcu_enabled() function is used to check whether
> > > RCU lockdep splats should be reported, but srcu_read_lock() does not
> > > use it.  This commit therefore brings srcu_read_lock_held() up to date.
> > > 
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > > Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>
> > > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> > 
> > Just how signed off does this patch need to be? ;)
> 
> Dunno but I feel uncomfortable now with that strange feeling I'm walking
> on the street with two Paul holding my hand on each side.

We already established the split Paul, but what is really scarey, is
that the Pauls on both sides of you, are the evil Pauls. ;)

-- Steve


