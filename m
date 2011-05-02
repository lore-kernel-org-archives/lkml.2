Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab1EBVme (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 17:42:34 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:39165
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757524Ab1EBVma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 17:42:30 -0400
Date: Mon, 02 May 2011 14:41:56 -0700 (PDT)
Message-Id: <20110502.144156.104049895.davem@davemloft.net>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org, mingo@elte.hu, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        Valdis.Kletnieks@vt.edu, dhowells@redhat.com, eric.dumazet@gmail.com,
        darren@dvhart.com, patches@linaro.org, kaber@trash.net
Subject: Re: [PATCH tip/core/rcu 1/7] net,rcu: convert
 call_rcu(sk_filter_release_rcu) to kfree_rcu
From: David Miller <davem@davemloft.net>
In-Reply-To: <1304352824-6563-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20110502161321.GA6537@linux.vnet.ibm.com>
	<1304352824-6563-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Date: Mon,  2 May 2011 09:13:38 -0700

> The RCU callback sk_filter_release_rcu just calls kfree(), so we use
> kfree_rcu() instead of call_rcu().
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>

I'm fine with all of these net conversions:

Acked-by: David S. Miller <davem@davemloft.net>
