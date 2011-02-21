Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753856Ab1BUFyv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 00:54:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:60137 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750765Ab1BUFyt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 00:54:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,198,1297065600"; 
   d="scan'208";a="889598775"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 0/7] ACPI, APEI patches for 2.6.39
Date: Mon, 21 Feb 2011 13:54:38 +0800
Message-Id: <1298267685-7357-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[PATCH 1/7] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH 2/7] lib, Add lock-less NULL terminated single list
[PATCH 3/7] ACPI, APEI, Add ERST record ID cache
[PATCH 4/7] PCIe, AER, use pre-generated prefix in error information printing
[PATCH 5/7] ACPI, APEI, Add PCIe AER error information printing support
[PATCH 6/7] lib, Make gen_pool memory allocator lockless
[PATCH 7/7] ACPI, APEI, GHES, printk support for recoverable error via NMI
