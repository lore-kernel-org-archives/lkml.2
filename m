Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754354Ab0ESTIc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 15:08:32 -0400
Received: from mga06.intel.com ([134.134.136.21]:15519 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753474Ab0ESTIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 15:08:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,265,1272870000"; 
   d="scan'208";a="519453400"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Alan Cox <alan@linux.intel.com>,
       Feng Tang <feng.tang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/3] v5 Moorestown clock related patches
Date: Wed, 19 May 2010 12:01:22 -0700
Message-Id: <1274295685-6774-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Besides fixes based on review of v4, one more patches is added to
make additional CPU feature available early enough for Moorestown clock
selection code. An x86_init.oem.setup_arch functin is added for Moorestown
so that we can use boot_cpu_data earlier. Other changes are minor.

Thanks,

*** BLURB HERE ***

Jacob Pan (3):
  x86: detect scattered cpuid features earlier
  x86/mrst: add cpu type detection
  x86/mrst: add more timer config options

 arch/x86/include/asm/apb_timer.h |    1 -
 arch/x86/include/asm/mrst.h      |   20 +++++++
 arch/x86/kernel/apb_timer.c      |   37 +++----------
 arch/x86/kernel/cpu/common.c     |    2 +-
 arch/x86/kernel/mrst.c           |  110 ++++++++++++++++++++++++++++++--------
 5 files changed, 116 insertions(+), 54 deletions(-)

