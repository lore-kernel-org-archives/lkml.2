Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755051Ab0EQTaG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:30:06 -0400
Received: from mga09.intel.com ([134.134.136.24]:63153 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753398Ab0EQTaE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:30:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,248,1272870000"; 
   d="scan'208";a="622386221"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
       "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
       Alan Cox <alan@linux.intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 0/2] v3 Moorestown updated patches 2,3,4 of v2
Date: Mon, 17 May 2010 12:23:01 -0700
Message-Id: <1274124183-23431-1-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.6.3.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These two patches are the updates of the v2 series. Changes include
1. comblined two patches below per tglx suggestion
	0003-x86-mrst-add-more-timer-options-to-include-Medfield.patch
	0004-x86-apbt-support-more-timer-configurations-on-mrst.patch

	Fixes based on review comments:
	a) removed duplicated '(' in mrst_setup_secondary_clock()
	b) changed clock selection logic, trying to make it more readable
		mrst_setup_secondary_clock()

2. export mrst_identify_cpu(), removed cache copy.


*** BLURB HERE ***

Jacob Pan (2):
  x86/mrst: add cpu type detection
  x86/mrst: add more timer config options

 arch/x86/include/asm/apb_timer.h |    2 +-
 arch/x86/include/asm/mrst.h      |   20 +++++++++
 arch/x86/kernel/apb_timer.c      |   18 ++++----
 arch/x86/kernel/mrst.c           |   86 ++++++++++++++++++++++++++++++++++----
 4 files changed, 108 insertions(+), 18 deletions(-)

