Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753719Ab0C0Pi1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Mar 2010 11:38:27 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:43382 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548Ab0C0PiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Mar 2010 11:38:25 -0400
Message-Id: <20100327153233.993367557@efficios.com>
User-Agent: quilt/0.46-1
Date: Sat, 27 Mar 2010 11:32:33 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: [patch 0/6] rcu head debugobjects
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 27 Mar 2010 15:36:18 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here is an updated version of the rcu head debugobjects, following the comments
I received in the last rounds.

It applies on top of -tip, based on 2.6.34-rc2, commit
2e958f219d2b8d192d44e2472a214b3a93c44673

Unless people have any objection, it should be ready to be merged. I think the
appropriate maintainer to perform this merge would be Paul E. McKenney, because
this patchset is RCU-related.

Thanks,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
