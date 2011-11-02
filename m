Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab1KBPTq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 11:19:46 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:37362 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932378Ab1KBPTn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 11:19:43 -0400
Date: Wed, 2 Nov 2011 08:14:49 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Carsten Emde <cbe@osadl.org>
Subject: Re: linux-next 20111025: warnings in
 rcu_idle_exit_common()/rcu_idle_enter_common()
Message-ID: <20111102151449.GO2287@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20111031114142.GA32555@localhost>
 <20111031121951.GM6160@linux.vnet.ibm.com>
 <1320075882.4793.4.camel@gandalf.stny.rr.com>
 <20111101003434.GR6160@linux.vnet.ibm.com>
 <20111101070720.GA22936@localhost>
 <20111101160014.GH2287@linux.vnet.ibm.com>
 <20111101163212.GA19501@localhost>
 <20111102144403.GA22445@linux.vnet.ibm.com>
 <1320245786.4793.32.camel@gandalf.stny.rr.com>
 <20111102150146.GA3648@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111102150146.GA3648@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
x-cbid: 11110215-9360-0000-0000-00000043098C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 02, 2011 at 11:01:46PM +0800, Wu Fengguang wrote:
> On Wed, Nov 02, 2011 at 10:56:26PM +0800, Steven Rostedt wrote:
> > On Wed, 2011-11-02 at 07:44 -0700, Paul E. McKenney wrote:
> > 
> > > rcu: Fix idle-task checks
> > > 
> > > RCU has traditionally relied on idle_cpu() to determine whether a given
> > > CPU is running in the context of an idle task, but recent changes have
> > > invalidated this approach.
> > 
> > Correct. idle_cpu() returns if the CPU is idle or not, not if the CPU is
> > running the idle thread. If the CPU wakes up on the idle thread and
> > there's tasks on the run queue, then idle_cpu() will return false, even
> > though the task running is the idle thread. But the CPU itself is not
> > technically idle.
> > 
> > Acked-by: Steven Rostedt <rostedt@goodmis.org>
> 
> With the patch I no longer see the RCU warnings. Below is the full dmesg.
> 
> Tested-by: Wu Fengguang <fengguang.wu@intel.com>

... and your Tested-by.

Thank you all!!!

							Thanx, Paul

