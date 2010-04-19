Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0DSBRp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Apr 2010 21:17:45 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55716 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754208Ab0DSBRo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Apr 2010 21:17:44 -0400
Message-ID: <4BCBAF46.4010603@cn.fujitsu.com>
Date: Mon, 19 Apr 2010 09:17:58 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
       akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, dipankar@in.ibm.com,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       adobriyan@gmail.com, "David S. Miller" <davem@davemloft.net>
Subject: Re: [patch 5/5] tree/tiny rcu: Add debug RCU head objects (v5)
References: <20100417124837.536020244@efficios.com> <20100417125052.236240763@efficios.com>
In-Reply-To: <20100417125052.236240763@efficios.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Reviewed-by: Lai Jiangshan <laijs@cn.fujitsu.com>

Mathieu Desnoyers wrote:
> Helps finding racy users of call_rcu(), which results in hangs because list
> entries are overwritten and/or skipped.
> 
> Changelog since v4:
> - Bissectability is now OK
> - Now generate a WARN_ON_ONCE() for non-initialized rcu_head passed to
>   call_rcu(). Statically initialized objects are detected with
>   object_is_static().
> - Rename rcu_head_init_on_stack to init_rcu_head_on_stack.
> - Remove init_rcu_head() completely.
> 
> Changelog since v3:
> - Include comments from Lai Jiangshan
> 
