Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754865Ab1EKTab (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 15:30:31 -0400
Received: from mga01.intel.com ([192.55.52.88]:5862 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754395Ab1EKTa3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 15:30:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,354,1301900400"; 
   d="scan'208";a="468440"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>,
        "Asit K Mallick" <asit.k.mallick@intel.com>,
        "Bruce Schlobohm" <bruce.schlobohm@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 0/3] Enable SMEP CPU Feature
Date: Wed, 11 May 2011 12:17:57 -0700
Message-Id: <1305141480-843-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

Intel new CPU supports SMEP (Supervisor Mode Execution Protection). SMEP
prevents kernel from executing code in application. Updated Intel SDM describes
this CPU feature. The document will be published soon.

Fenghua Yu (3):
  x86, cpu: Add CPU flags for SMEP
  x86, cpu: Add SMEP CPU feature in CR4
  x86, cpu: Enable/disable SMEP

 Documentation/kernel-parameters.txt    |    4 ++++
 arch/x86/include/asm/cpufeature.h      |    1 +
 arch/x86/include/asm/processor-flags.h |    1 +
 arch/x86/kernel/cpu/common.c           |   21 +++++++++++++++++++++
 arch/x86/kernel/cpu/scattered.c        |    1 +
 5 files changed, 28 insertions(+), 0 deletions(-)

-- 
1.7.2

