Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752175Ab1BIH1j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 02:27:39 -0500
Received: from mga02.intel.com ([134.134.136.20]:17707 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944Ab1BIH1h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 02:27:37 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,446,1291622400"; 
   d="scan'208";a="705663177"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>
Subject: [RFC 0/2] ACPI, APEI, GHES, printk support for recoverable error via NMI
Date: Wed,  9 Feb 2011 15:27:29 +0800
Message-Id: <1297236451-11331-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patchset is based on the lockless list patchset.

[RFC 1/2] lib, Make gen_pool memory allocator lockless
[RFC 2/2] ACPI, APEI, GHES, printk support for recoverable error via NMI
