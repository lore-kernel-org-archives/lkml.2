Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757738Ab0CPI7e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 04:59:34 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:39931 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751936Ab0CPI7d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 04:59:33 -0400
Date: Tue, 16 Mar 2010 09:58:47 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
       dipankar@in.ibm.com, akpm@linux-foundation.org,
       mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, dvhltc@us.ibm.com,
       niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
       rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
       eric.dumazet@gmail.com, arnd@arndb.de
Subject: Re: [PATCH tip/core/rcu] rcu: make rcu_read_lock_bh_held() allow for
	disabled BH
Message-ID: <20100316085847.GC7961@elte.hu>
References: <20100316000343.GA25857@linux.vnet.ibm.com>
 <4B9F22C8.6070702@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4B9F22C8.6070702@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: 0.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=0.0 required=5.9 tests=none autolearn=no SpamAssassin version=3.2.5
	_SUMMARY_
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Lai Jiangshan <laijs@cn.fujitsu.com> wrote:

> Paul E. McKenney wrote:
> > Disabling BH can stand in for rcu_read_lock_bh(), and this patch updates
> > rcu_read_lock_bh_held() to allow for this.  In order to avoid include-file
> > hell, this function is moved out of line to kernel/rcupdate.c.
> > 
> > Reported-by: Arnd Bergmann <arnd@arndb.de>
> > Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> > Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> 
> Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Applied, thanks!

	Ingo
