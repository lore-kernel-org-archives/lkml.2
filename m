Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760128Ab2EWOQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 10:16:53 -0400
Received: from mga11.intel.com ([192.55.52.93]:41640 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752782Ab2EWOQw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 10:16:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="156126798"
From: Alex Shi <alex.shi@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, seto.hidetoshi@jp.fujitsu.com, borislav.petkov@amd.com,
        alex.shi@intel.com, tony.luck@intel.com, luto@mit.edu, riel@redhat.com,
        avi@redhat.com, len.brown@intel.com, dhowells@redhat.com,
        yinghai@kernel.org, ak@linux.intel.com, jbeulich@suse.com,
        akpm@linux-foundation.org, eric.dumazet@gmail.com,
        akinobu.mita@gmail.com, cpw@sgi.com, steiner@sgi.com,
        penberg@kernel.org, a.p.zijlstra@chello.nl, hughd@google.com,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, yongjie.ren@intel.com
Subject: [PATCH v7 0/8] x86 tlb optimisations 
Date: Wed, 23 May 2012 22:15:47 +0800
Message-Id: <1337782555-8088-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version remove the 'x86/tlb: unify TLB_FLUSH_ALL definition', since
it was picked up by Ingo.
And combined with the 7th/8th patches. that were send out days ago.

Any comments are appreciated!

Thanks!
Alex Shi
[PATCH v7 1/8] x86/tlb_info: get last level TLB entry number of CPU
[PATCH v7 2/8] x86/flush_tlb: try flush_tlb_single one by one in
[PATCH v7 3/8] x86/tlb: fall back to flush all when meet a THP large
[PATCH v7 4/8] x86/tlb: add tlb_flushall_shift for specific CPU
[PATCH v7 5/8] x86/tlb: enable tlb flush range support for generic
[PATCH v7 6/8] x86/tlb: add tlb_flushall_shift knob into debugfs
[PATCH v7 7/8] x86/tlb: replace INVALIDATE_TLB_VECTOR by
[PATCH v7 8/8] x86/tlb: just do tlb flush on one of siblings of SMT
