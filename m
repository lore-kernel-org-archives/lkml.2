Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670Ab0CSUxk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Mar 2010 16:53:40 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:45439 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752612Ab0CSUxf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Mar 2010 16:53:35 -0400
Message-Id: <20100319204739.574593298@efficios.com>
User-Agent: quilt/0.46-1
Date: Fri, 19 Mar 2010 16:47:39 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: akpm@linux-foundation.org, Ingo Molnar <mingo@elte.hu>,
       linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
       laijs@cn.fujitsu.com, dipankar@in.ibm.com, josh@joshtriplett.org,
       dvhltc@us.ibm.com, niv@us.ibm.com, tglx@linutronix.de,
       peterz@infradead.org, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
       dhowells@redhat.com, eric.dumazet@gmail.com, adobriyan@gmail.com
Subject: [RFC patch 0/3] RCU head debug objects
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Fri, 19 Mar 2010 20:52:33 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patchset introduces a debugobjects-based rcu list head debugging
infrastructure. The first patch adds the ability to keep track of a "state
machine" into debugobjects. The state machine logic is all contained in the
type-aware caller. Debugobjects only keep track of the current state (a single
integer). A state validation/transition API is provided to debugobjects users.

This patchset is based on 2.6.33.1.

Comments are welcome,

Mathieu

-- 
Mathieu Desnoyers
OpenPGP key fingerprint: 8CD5 52C3 8E3C 4140 715F  BA06 3F25 A8FE 3BAE 9A68
