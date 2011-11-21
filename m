Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753629Ab1KUQjU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:39:20 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:46104 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab1KUQjT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:39:19 -0500
Date: Mon, 21 Nov 2011 08:37:45 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Josh Triplett <josh@joshtriplett.org>, LKML <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH] nohz: Remove tick_nohz_idle_enter_norcu() /
 tick_nohz_idle_exit_norcu()
Message-ID: <20111121163745.GA2323@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1321552094-20237-1-git-send-email-fweisbec@gmail.com>
 <20111117201134.GB1865@leaf>
 <20111118010344.GI2429@linux.vnet.ibm.com>
 <20111119005003.GA1791@linux.vnet.ibm.com>
 <CAFTL4hx9m546KRPZX-dH+_ETyLY+WAR5cpOKoCoyECnSX2iHkA@mail.gmail.com>
 <20111121052819.GI17982@linux.vnet.ibm.com>
 <20111121152345.GA25088@somewhere.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111121152345.GA25088@somewhere.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11112116-3534-0000-0000-0000026404E2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 04:23:51PM +0100, Frederic Weisbecker wrote:
> On Sun, Nov 20, 2011 at 09:28:19PM -0800, Paul E. McKenney wrote:
> > On Mon, Nov 21, 2011 at 02:46:58AM +0100, Frederic Weisbecker wrote:
> > > 2011/11/19 Paul E. McKenney <paulmck@linux.vnet.ibm.com>:
> > > > On Thu, Nov 17, 2011 at 05:03:44PM -0800, Paul E. McKenney wrote:
> > > >> On Thu, Nov 17, 2011 at 12:11:34PM -0800, Josh Triplett wrote:

[ . . . ]

> > 4.	Task A invokes a system call.  If the system-call entry
> > 	code were to again invoke rcu_idle_enter(), then my patch
> > 	is required.  If you check and avoid invoking rcu_idle_enter()
> > 	in this case, then my patch is not required.
> 
> You mean rcu_idle_exit()? So yeah, since we have the tick running
> and thus RCU not in extended QS, we won't call rcu_idle_exit() on syscall
> entry.

OK, then I will drop my patch.  ;-)

							Thanx, Paul

