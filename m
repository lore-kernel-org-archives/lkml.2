Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831Ab2F1BEv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 21:04:51 -0400
Received: from mga02.intel.com ([134.134.136.20]:16525 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751985Ab2F1BEu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 21:04:50 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="159020223"
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
        aarcange@redhat.com, linux-kernel@vger.kernel.org
Subject: [PATCH v10 0/9] X86 TLB flush optimization
Date: Thu, 28 Jun 2012 09:02:15 +0800
Message-Id: <1340845344-27557-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thank for Fengguang's 0-day build system. It found 2 build errors on 
the first and 7th patch.

So this version fix them, introduce a c_detect_tlb() member into
struct cpu_dev for tlb entries detection of specific CPU vendor.

Thanks all of comments and testing on this patchset!

Alex

[PATCH v10 1/9] x86/tlb_info: get last level TLB entry number of CPU
[PATCH v10 2/9] x86/flush_tlb: try flush_tlb_single one by one in
[PATCH v10 3/9] x86/tlb: fall back to flush all when meet a THP
[PATCH v10 4/9] x86/tlb: add tlb_flushall_shift for specific CPU
[PATCH v10 5/9] x86/tlb: add tlb_flushall_shift knob into debugfs
[PATCH v10 6/9] mm/mmu_gather: enable tlb flush range in generic
[PATCH v10 7/9] x86/tlb: enable tlb flush range support for x86
[PATCH v10 8/9] x86/tlb: replace INVALIDATE_TLB_VECTOR by
[PATCH v10 9/9] x86/tlb: do flush_tlb_kernel_range by 'invlpg'
