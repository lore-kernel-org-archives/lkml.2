Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab1EQIIr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 May 2011 04:08:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:64539 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751572Ab1EQIIm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 May 2011 04:08:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,224,1304319600"; 
   d="scan'208";a="2661582"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH 0/9] ACPI, APEI patches for 2.6.40
Date: Tue, 17 May 2011 16:08:30 +0800
Message-Id: <1305619719-7480-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/9] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH 2/9] lib, Add lock-less NULL terminated single list
[PATCH 3/9] lib, Make gen_pool memory allocator lockless
[PATCH 4/9] ACPI, APEI, GHES, printk support for recoverable error via NMI
[PATCH 5/9] HWPoison: add memory_failure_queue()
[PATCH 6/9] ACPI, APEI, GHES: Add hardware memory error recovery support
[PATCH 7/9] PCIe, AER, add aer_recover_queue
[PATCH 8/9] ACPI, APEI, GHES: Add PCIe AER recovery support
[PATCH 9/9] ACPI, APEI, ERST, Prevent erst_dbg from loading if ERST is disabled
