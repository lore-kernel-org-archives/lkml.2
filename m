Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752283Ab0LGCWk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 21:22:40 -0500
Received: from mga01.intel.com ([192.55.52.88]:39156 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750888Ab0LGCWj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 21:22:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,308,1288594800"; 
   d="scan'208";a="865237954"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v4 0/3] ACPI, APEI, Report GHES error information via printk
Date: Tue,  7 Dec 2010 10:22:28 +0800
Message-Id: <1291688551-14395-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The recent consensus is that hardware error should be reported via printk.
This patch adds printk support to APEI GHES.

v4:

- Remove pr_pfx, use printk directly

v3:

- Add document for output format per Andrew's comments
- Move pr_pfx into printk.h, hope it is useful for others too
- Fixes some issues according to comments

v2:

- Some minor adjustment of PCIe error section definition and printk format

[PATCH -v4 1/3] Add CPER PCIe error section structure and constants definition
[PATCH -v4 2/3] ACPI, APEI, Add APEI generic error status printing support
[PATCH -v4 3/3] ACPI, APEI, Report GHES error information via printk
