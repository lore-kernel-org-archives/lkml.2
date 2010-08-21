Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab0HUOXK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 10:23:10 -0400
Received: from smtp.polymtl.ca ([132.207.4.11]:36004 "EHLO smtp.polymtl.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751773Ab0HUOXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 10:23:08 -0400
Message-Id: <20100821141750.770348530@efficios.com>
User-Agent: quilt/0.48-1
Date: Sat, 21 Aug 2010 10:17:50 -0400
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: LKML <linux-kernel@vger.kernel.org>
Cc: ltt-dev@lists.casi.polymtl.ca,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: [PATCH for -tip 0/2] Generic Alignment API
X-Poly-FromMTA: (test.casi.polymtl.ca [132.207.72.60]) at Sat, 21 Aug 2010 14:22:15 +0000
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

These two patches implement a generic alignment header needed by the "Generic
Ring Buffer" patchset and by xchg() fallback implementation on some ARM
architectures.

The goal of this patch is to move pointer alignment arithmetic to one single
location in the kernel rather than spreading these all over the place as this is
currently the case in the Linux kernel (especially when an alignment on the
floor value is needed).

I submit this patch for inclusion through -tip. Meanwhile, I will pull it in a
git tree (based on -tip) on top of which I will rebase the "Generic Ring Buffer"
patchset:

 git://git.kernel.org/pub/scm/linux/kernel/git/compudj/linux-2.6-ringbuffer.git
   branch: tip-pull-queue

Ingo, to merge these patches, you can either take these 2 patches or pull from
the "tip-pull-queue", at your convenience (tip-pull-queue is based on
tip/master).

Thanks,

Mathieu

-- 
Mathieu Desnoyers
Operating System Efficiency R&D Consultant
EfficiOS Inc.
http://www.efficios.com
