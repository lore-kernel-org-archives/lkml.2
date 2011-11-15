Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932443Ab1KOVTI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 16:19:08 -0500
Received: from shards.monkeyblade.net ([198.137.202.13]:45965 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932398Ab1KOVTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 16:19:07 -0500
Date: Tue, 15 Nov 2011 16:15:51 -0500 (EST)
Message-Id: <20111115.161551.1066683225643183882.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, paul.mckenney@linaro.org
Subject: Re: [PATCH tip/core/rcu 6/9] sparc: Make SPARC use the new
 is_idle_task() API
From: David Miller <davem@davemloft.net>
In-Reply-To: <1321388885-11211-6-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20111115202736.GA11030@linux.vnet.ibm.com>
	<1321388885-11211-6-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 15 Nov 2011 13:15:54 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Tue, 15 Nov 2011 12:28:02 -0800

> From: Paul E. McKenney <paul.mckenney@linaro.org>
> 
> Change from direct comparison of ->pid with zero to is_idle_task().
> 
> Signed-off-by: Paul E. McKenney <paul.mckenney@linaro.org>
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: "David S. Miller" <davem@davemloft.net>

Acked-by: David S. Miller <davem@davemloft.net>
