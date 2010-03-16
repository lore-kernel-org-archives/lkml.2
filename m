Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965906Ab0CPGS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 02:18:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:55437 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S964977Ab0CPGSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 02:18:55 -0400
Message-ID: <4B9F22C8.6070702@cn.fujitsu.com>
Date: Tue, 16 Mar 2010 14:18:48 +0800
From: Lai Jiangshan <laijs@cn.fujitsu.com>
User-Agent: Thunderbird 2.0.0.6 (Windows/20070728)
MIME-Version: 1.0
To: paulmck@linux.vnet.ibm.com
CC: linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
       akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
       josh@joshtriplett.org, dvhltc@us.ibm.com, niv@us.ibm.com,
       tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
       Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
       arnd@arndb.de
Subject: Re: [PATCH tip/core/rcu] rcu: make rcu_read_lock_bh_held() allow
 for	disabled BH
References: <20100316000343.GA25857@linux.vnet.ibm.com>
In-Reply-To: <20100316000343.GA25857@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul E. McKenney wrote:
> Disabling BH can stand in for rcu_read_lock_bh(), and this patch updates
> rcu_read_lock_bh_held() to allow for this.  In order to avoid include-file
> hell, this function is moved out of line to kernel/rcupdate.c.
> 
> Reported-by: Arnd Bergmann <arnd@arndb.de>
> Reported-by: Eric Dumazet <eric.dumazet@gmail.com>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

Acked-by: Lai Jiangshan <laijs@cn.fujitsu.com>
