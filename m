Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815Ab0C2OjD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 10:39:03 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:60419 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752504Ab0C2Oi7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 10:38:59 -0400
Message-Id: <20100329143405.252313609@efficios.com>
User-Agent: quilt/0.46-1
Date: Mon, 29 Mar 2010 10:34:05 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 0/5] RCU head debug (v5)
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Mon, 29 Mar 2010 14:37:01 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an updated version of the RCU head debug. It removes all rcu head
initializations except for "on_stack" initializations. The state of rcu_head
before call_rcu() really does not matter.

The debug objects use a fixup to keep track of rcu_heads from activation
performed from call_rcu(), except for "on_stack" initialization, which needs to
be explicit.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
