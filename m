Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756436Ab1BYTkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 14:40:15 -0500
Received: from e2.ny.us.ibm.com ([32.97.182.142]:48045 "EHLO e2.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756303Ab1BYTkN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 14:40:13 -0500
Date: Fri, 25 Feb 2011 11:40:07 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com
Subject: Re: [PATCH RFC tip/core/rcu 01/11] rcu: call __rcu_read_unlock()
 in exit_rcu for tiny RCU
Message-ID: <20110225194007.GC2269@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20110223013917.GA20996@linux.vnet.ibm.com>
 <1298425183-21265-1-git-send-email-paulmck@linux.vnet.ibm.com>
 <4D67687A.6010906@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D67687A.6010906@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 25, 2011 at 04:29:46PM +0800, Lai Jiangshan wrote:
> On 02/23/2011 09:39 AM, Paul E. McKenney wrote:
> > 
> > diff --git a/kernel/rcutiny_plugin.h b/kernel/rcutiny_plugin.h
> > index 015abae..3cb8e36 100644
> > --- a/kernel/rcutiny_plugin.h
> > +++ b/kernel/rcutiny_plugin.h
> 
> My original patch was just for tree RCU. It is not merged.
> I forgot the tiny RCU case then, this change is needed for tree & tiny RCU.

Good catch, I have applied the TREE_RCU patch.  I intend to submit
both for the next merge window.

Thank you for checking!

							Thanx, Paul
