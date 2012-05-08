Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755504Ab2EHOFH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 10:05:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:35908 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754810Ab2EHOFG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 10:05:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="140343352"
From: Alex Shi <alex.shi@intel.com>
To: mgorman@suse.de, npiggin@gmail.com, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, gregkh@linuxfoundation.org, glommer@redhat.com,
        riel@redhat.com, luto@mit.edu, alex.shi@intel.com, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        borislav.petkov@amd.com, yinghai@kernel.org, ak@linux.intel.com,
        cpw@sgi.com, steiner@sgi.com, akpm@linux-foundation.org,
        penberg@kernel.org, hughd@google.com, rientjes@google.com,
        kosaki.motohiro@jp.fujitsu.com, n-horiguchi@ah.jp.nec.com,
        paul.gortmaker@windriver.com, trenn@suse.de, tj@kernel.org,
        oleg@redhat.com, axboe@kernel.dk, a.p.zijlstra@chello.nl,
        kamezawa.hiroyu@jp.fujitsu.com, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: [PATCH v3] TLB flush optimization 
Date: Tue,  8 May 2012 22:03:03 +0800
Message-Id: <1336485790-30902-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This version just added 2 patches, the 6th and 7th. The first 5 patches are 
same as v2.

Seems it is a little hard for me to find a real case to show performance gain.
But the advantage is there ture.

Any comments are appreciated!

Alex

[PATCH v3 1/7] x86/tlb_info: get last level TLB entry number of CPU
[PATCH v3 2/7] x86/flush_tlb: try flush_tlb_single one by one in
[PATCH v3 3/7] x86/tlb: fall back to flush all when meet a THP large
[PATCH v3 4/7] x86/tlb: add tlb flush all factor for specific CPUs
[PATCH v3 5/7] x86/tlb: remove comments for tlb_flush_range
[PATCH v3 6/7] x86/tlb: optimizing flush_tlb_mm
[PATCH v3 7/7] x86/tlb: add tlb_flushall_factor into sysfs for user
