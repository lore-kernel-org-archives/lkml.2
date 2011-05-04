Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752513Ab1EDItF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 04:49:05 -0400
Received: from mga14.intel.com ([143.182.124.37]:34671 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751922Ab1EDItC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 04:49:02 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,313,1301900400"; 
   d="scan'208";a="430199594"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH -v5 0/4] ACPI, APEI, GHES, printk support for recoverable error via NMI
Date: Wed,  4 May 2011 16:48:48 +0800
Message-Id: <1304498932-30127-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v5:

- Change gen_pool_for_each_chunk interface
- Remove unlock in loop in gen_pool_alloc

v4:

- Add rcu_read_lock/unlock in lockless gen_pool implementation, at least we
 need that for future pool shrinking support.

v3:

- Some changes to lock-less list based on Mathieu's comments

v2:

- Update some comments of llist per Mathieu's comments


[PATCH -v5 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH -v5 2/4] lib, Add lock-less NULL terminated single list
[PATCH -v5 3/4] lib, Make gen_pool memory allocator lockless
[PATCH -v5 4/4] ACPI, APEI, GHES, printk support for recoverable error via NMI
