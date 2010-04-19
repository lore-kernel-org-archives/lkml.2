Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0DSNeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 09:34:12 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:43610 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751494Ab0DSNeK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 09:34:10 -0400
Date: Mon, 19 Apr 2010 06:34:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 5/5] tree/tiny rcu: Add debug RCU head objects (v5)
Message-ID: <20100419133404.GC2564@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20100417124837.536020244@efficios.com>
 <20100417125052.236240763@efficios.com>
 <4BCBAF46.4010603@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BCBAF46.4010603@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 19, 2010 at 09:17:58AM +0800, Lai Jiangshan wrote:
> 
> Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Thank you, Lai!!!  I have added your Reviewed-by.

							Thanx, Paul

> Mathieu Desnoyers wrote:
> > Helps finding racy users of call_rcu(), which results in hangs because list
> > entries are overwritten and/or skipped.
> > 
> > Changelog since v4:
> > - Bissectability is now OK
> > - Now generate a WARN_ON_ONCE() for non-initialized rcu_head passed to
> >   call_rcu(). Statically initialized objects are detected with
> >   object_is_static().
> > - Rename rcu_head_init_on_stack to init_rcu_head_on_stack.
> > - Remove init_rcu_head() completely.
> > 
> > Changelog since v3:
> > - Include comments from Lai Jiangshan
> > 
