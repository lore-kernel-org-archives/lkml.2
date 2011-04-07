Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757239Ab1DGB3T (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 21:29:19 -0400
Received: from mga01.intel.com ([192.55.52.88]:40761 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755887Ab1DGB3R (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 21:29:17 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,313,1299484800"; 
   d="scan'208";a="676182816"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org
Subject: [PATCH	-v2 0/4] ACPI, APEI, GHES, printk support for recoverable error via NMI
Date: Thu,  7 Apr 2011 09:29:02 +0800
Message-Id: <1302139746-1030-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

v2:

- Update some comments of llist per Mathieu's comments


[PATCH -v2 1/4] Add Kconfig option ARCH_HAVE_NMI_SAFE_CMPXCHG
[PATCH -v2 2/4] lib, Add lock-less NULL terminated single list
[PATCH -v2 3/4] lib, Make gen_pool memory allocator lockless
[PATCH -v2 4/4] ACPI, APEI, GHES, printk support for recoverable error via NMI
