Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751752Ab1GTNeu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 09:34:50 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:36906 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750979Ab1GTNet (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 09:34:49 -0400
Date: Wed, 20 Jul 2011 06:34:43 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ed Tomlinson <edt@aei.ca>, linux-kernel@vger.kernel.org, mingo@elte.hu,
        laijs@cn.fujitsu.com, dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, greearb@candelatech.com,
        edward.tomlinson@aero.bombardier.com
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads
 trainwreck
Message-ID: <20110720133443.GG2400@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110720001738.GA16369@linux.vnet.ibm.com>
 <201107192130.02080.edt@aei.ca>
 <201107192207.33813.edt@aei.ca>
 <20110720044435.GB2400@linux.vnet.ibm.com>
 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 19, 2011 at 10:03:05PM -0700, Linus Torvalds wrote:
> On Tue, Jul 19, 2011 at 9:44 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
> > On Tue, Jul 19, 2011 at 10:07:32PM -0400, Ed Tomlinson wrote:
> >> On Tuesday 19 July 2011 21:30:00 Ed Tomlinson wrote:
> >> > On Tuesday 19 July 2011 20:17:38 Paul E. McKenney wrote:
> >>
> >> Paul,
> >>
> >> Two things to add.  Its possible an eariler error is missing from the log below.  My serial console was missing
> >> entries from before '0 and 40ish' and I did think I saw a bunch of FFFFFFFs scroll by eariler...
> >>
> >> Second, booting with threadirqs and boost enabled in .config with patches 2,5,6 is ok so far.
> >
> > Patches 3 and 4 resulted in failures?  (Patch 1 certainly did.)
> 
> Gaah. Any possibility of getting this resolved soon?

I believe that we are very close.  These failures all involve unusual
configurations, which is why they showed up so late.

> I've merged the pathname lookup fix. I was hoping all the RCU issues
> were behind us..

If we have time, I would like to see what Ed gets with the most recent
fix.  If we absolutely need to release today, then I will push patches
2,5,6 which are covering Ed's particular situation.  My concern with doing
so is that other failures might pop up.

							Thanx, Paul
