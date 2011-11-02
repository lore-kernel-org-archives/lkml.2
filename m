Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933167Ab1KBP0S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:26:18 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:35283 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932374Ab1KBP0P (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:26:15 -0400
Date: Wed, 2 Nov 2011 08:14:02 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Wu Fengguang <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111102151402.GM2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031104325.GA25808@localhost>
 <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
 <20111101003434.GR6160@linux.vnet.ibm.com>
 <20111101070720.GA22936@localhost>
 <20111101160014.GH2287@linux.vnet.ibm.com>
 <20111101163212.GA19501@localhost>
 <20111102144403.GA22445@linux.vnet.ibm.com>
 <1320245512.4793.29.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1320245512.4793.29.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110215-8974-0000-0000-000001598E15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 10:51:52AM -0400, Steven Rostedt wrote:
> On Wed, 2011-11-02 at 07:44 -0700, Paul E. McKenney wrote:
> 
> > rcu: Fix idle-task checks
> > 
> > RCU has traditionally relied on idle_cpu() to determine whether a given
> > CPU is running in the context of an idle task, but recent changes have
> > invalidated this approach.  This commit therefore switches from idle_cpu
> > to "current->pid != 0".
> > 
> > Suggested-by: Carsten Emde <C.Emde@osadl.org>
> 
> 
> 
> > Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> 
> I always knew you had a split personality Paul ;)

Ah, but which is the Good Paul and which is the Evil Paul?  ;-)

							Thanx, Paul

