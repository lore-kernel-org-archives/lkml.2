Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756992Ab0DQMwH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Apr 2010 08:52:07 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:52203 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab0DQMvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Apr 2010 08:51:46 -0400
Message-Id: <20100417124837.536020244@efficios.com>
User-Agent: quilt/0.46-1
Date: Sat, 17 Apr 2010 08:48:37 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com,
       "David S. Miller" <davem@davemloft.net>
Subject: [patch 0/5] rcu head debugobjects
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 17 Apr 2010 12:50:50 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here is a repost of the rcu head debugobjects patchset, with updated changelogs.

Paul, this would be ready to be integrated with the RCU patches.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
