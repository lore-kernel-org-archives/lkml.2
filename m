Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754992Ab2FYGLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 02:11:38 -0400
Received: from mga02.intel.com ([134.134.136.20]:6414 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754929Ab2FYGLg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 02:11:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="162132812"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, alex.shi@intel.com, luto@mit.edu, yinghai@kernel.org,
        riel@redhat.com, avi@redhat.com, len.brown@intel.com, tj@kernel.org,
        akpm@linux-foundation.org, cl@gentwo.org, borislav.petkov@amd.com,
        ak@linux.intel.com, jbeulich@suse.com, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, vapier@gentoo.org, cpw@sgi.com,
        steiner@sgi.com, viro@zeniv.linux.org.uk,
        kamezawa.hiroyu@jp.fujitsu.com, rientjes@google.com,
        aarcange@redhat.com, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v9 0/9] x86 tlb optimisation and clean up
Date: Mon, 25 Jun 2012 14:08:18 +0800
Message-Id: <1340604507-11214-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update to V9 version. This version is mainly for commit change.

1, It split the 6th patch into 6th and 7th for one patch to one issue.

2, update commit log for the 7th patch to include Yongjie's testing
results, I don't know why lkml can not show the e-mail, maybe some
words make it looks as spam?, Anyway I believe guys in to/cc list
have the data. So, attached the e-mail contents into log.

3, change commit log for 8th, 9th to include most clear explaination
and detailed testing result.


This patch set has clear performance gain, and clean up IDT table.

It is also quite safe after many review comments from Peter Anvin,
PeterZ, Nick Piggin, Steven Rostedt, Andi Kleen and Borislav etc. 
And it runs well with my long time performance testing...

Anyone like to give the reason if it is not readly for upstream?

Best Regards!
Alex


[PATCH v9 1/9] x86/tlb_info: get last level TLB entry number of CPU
[PATCH v9 2/9] x86/flush_tlb: try flush_tlb_single one by one in
[PATCH v9 3/9] x86/tlb: fall back to flush all when meet a THP large
[PATCH v9 4/9] x86/tlb: add tlb_flushall_shift for specific CPU
[PATCH v9 5/9] x86/tlb: add tlb_flushall_shift knob into debugfs
[PATCH v9 6/9] mm/mmu_gather: enable tlb flush range in generic
[PATCH v9 7/9] x86/tlb: enable tlb flush range support for x86
[PATCH v9 8/9] x86/tlb: replace INVALIDATE_TLB_VECTOR by
[PATCH v9 9/9] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
