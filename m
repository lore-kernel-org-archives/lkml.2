Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2EJFB5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 01:01:57 -0400
Received: from mga02.intel.com ([134.134.136.20]:13293 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750829Ab2EJFBz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 01:01:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="142177293"
From: Alex Shi <alex.shi@intel.com>
To: rob@landley.net, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, rostedt@goodmis.org, fweisbec@gmail.com
Cc: jeremy@goop.org, gregkh@linuxfoundation.org, borislav.petkov@amd.com,
        alex.shi@intel.com, riel@redhat.com, luto@mit.edu, avi@redhat.com,
        len.brown@intel.com, dhowells@redhat.com, fenghua.yu@intel.com,
        ak@linux.intel.com, cpw@sgi.com, steiner@sgi.com,
        akpm@linux-foundation.org, penberg@kernel.org, hughd@google.com,
        rientjes@google.com, kosaki.motohiro@jp.fujitsu.com,
        n-horiguchi@ah.jp.nec.com, paul.gortmaker@windriver.com, trenn@suse.de,
        tj@kernel.org, oleg@redhat.com, axboe@kernel.dk,
        a.p.zijlstra@chello.nl, kamezawa.hiroyu@jp.fujitsu.com,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org
Subject: [PATCH v4 0/7] tlb flush optimization
Date: Thu, 10 May 2012 13:00:06 +0800
Message-Id: <1336626013-28413-1-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for all of comments, the v4 patchset were changed accordingly.

and also include some code clean up to make the code more logical.

Thanks for all!

[PATCH v4 1/7] x86/tlb: unify TLB_FLUSH_ALL definition
[PATCH v4 2/7] x86/tlb_info: get last level TLB entry number of CPU
[PATCH v4 3/7] x86/flush_tlb: try flush_tlb_single one by one in
[PATCH v4 4/7] x86/tlb: fall back to flush all when meet a THP large
[PATCH v4 5/7] x86/tlb: add tlb flush all factor for specific CPU
[PATCH v4 6/7] x86/tlb: optimizing flush_tlb_mm
[PATCH v4 7/7] x86/tlb: add tlb_flushall_factor into sysfs for user
