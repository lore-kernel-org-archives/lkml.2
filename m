Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213Ab0KSIKp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Nov 2010 03:10:45 -0500
Received: from mga03.intel.com ([143.182.124.21]:59974 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750933Ab0KSIKo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Nov 2010 03:10:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,221,1288594800"; 
   d="scan'208";a="350764260"
From: Huang Ying <ying.huang@intel.com>
To: Len Brown <lenb@kernel.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
        ying.huang@intel.com, linux-acpi@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 0/2] Generic hardware error reporting support
Date: Fri, 19 Nov 2010 16:10:31 +0800
Message-Id: <1290154233-28695-1-git-send-email-ying.huang@intel.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Len,

This is used by APEI ERST and GEHS. But it is a generic hardware
error reporting mechanism and can be used by other hardware error
reporting mechanisms such as EDAC, PCIe AER, Machine Check, etc.

The patchset is split from the original APEI patchset to make it
explicit that this is a generic mechanism, not APEI specific bits.

[PATCH 1/2] Generic hardware error reporting mechanism
[PATCH 2/2] Hardware error record persistent support

Best Regards,
Huang Ying
