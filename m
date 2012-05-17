Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754106Ab2EQFoq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 01:44:46 -0400
Received: from mga09.intel.com ([134.134.136.24]:19232 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751787Ab2EQFop (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 01:44:45 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="141548756"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, riel@redhat.com, luto@mit.edu, alex.shi@intel.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        fenghua.yu@intel.com, borislav.petkov@amd.com, yinghai@kernel.org,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, a.p.zijlstra@chello.nl,
        hughd@google.com, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        yongjie.ren@intel.com
Subject: [PATCH v6 0/7] tlb flush optimization on x86
Date: Thu, 17 May 2012 13:42:48 +0800
Message-Id: <1337233375-840-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Peter Z, Peter Anvin, Nick Piggin, and many others' comments!

The main change of this version is on generic mmu_gather code.
It was tested with arm cross-compiler.

Thanks Rongjie's testing, that show the real case performance gain.

Alex Shi

[PATCH v6 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
[PATCH v6 2/7] x86/tlb_info: get last level TLB entry number of CPU
[PATCH v6 3/7] x86/flush_tlb: try flush_tlb_single one by one in
[PATCH v6 4/7] x86/tlb: fall back to flush all when meet a THP large
[PATCH v6 5/7] x86/tlb: add tlb_flushall_shift for specific CPU
[PATCH v6 6/7] x86/tlb: enable tlb flush range support for generic
[PATCH v6 7/7] x86/tlb: add tlb_flushall_shift knob into debugfs
