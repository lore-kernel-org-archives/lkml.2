Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752195Ab0K3Cvr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 21:51:47 -0500
Received: from mga14.intel.com ([143.182.124.37]:23185 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751716Ab0K3Cvq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 21:51:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,278,1288594800"; 
   d="scan'208";a="354765000"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        Tony Luck <tony.luck@intel.com>, ying.huang@intel.com,
        linux-acpi@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: [PATCH -v2 0/3] Report APEI GHES error information via printk
Date: Tue, 30 Nov 2010 10:51:38 +0800
Message-Id: <1291085501-31494-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len,

Although we have no consensus on whether we need a hardware error specific
reporting interface. We have the consensus that we need to report hardware
error information via printk. This patchset adds that to APEI GHES.

v2:

- Some minor adjustment of PCIe error section definition and printk format

[PATCH -v2 1/3] Add CPER PCIe error section structure and constants definition
[PATCH -v2 2/3] ACPI, APEI, Add APEI generic error status print support
[PATCH -v2 3/3] ACPI, APEI, report GHES error information via printk

Best Regards,
Huang Ying
