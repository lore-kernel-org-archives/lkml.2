Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753340Ab1ECWra (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 May 2011 18:47:30 -0400
Received: from mga02.intel.com ([134.134.136.20]:39653 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1ECWr3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 May 2011 18:47:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.64,312,1301900400"; 
   d="scan'208";a="741871649"
From: "Fenghua Yu" <fenghua.yu@intel.com>
To: "Ingo Molnar" <mingo@elte.hu>, "Thomas Gleixner" <tglx@linutronix.de>,
        "H Peter Anvin" <hpa@zytor.com>, "Tony Luck" <tony.luck@intel.com>
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        "Fenghua Yu" <fenghua.yu@intel.com>
Subject: [PATCH 0/2] Enable mce inject driver exit
Date: Tue,  3 May 2011 15:34:38 -0700
Message-Id: <1304462080-3358-1-git-send-email-fenghua.yu@intel.com>
X-Mailer: git-send-email 1.7.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Fenghua Yu <fenghua.yu@intel.com>

This patch set enables mce inject driver exit. So mce inject driver can be
removed like other drivers. This makes the driver more useful in debugging mce
issues or debugging issues in the driver itself.

Fenghua Yu (2):
  x86/kernel/cpu/mcheck/mce-inject.c: Add mce inject driver exit
  x86/kernel/cpu/mcheck/mce.c: Interfaces for mce inject driver exit

 arch/x86/include/asm/mce.h              |    3 +-
 arch/x86/kernel/cpu/mcheck/mce-inject.c |   14 +++++++++--
 arch/x86/kernel/cpu/mcheck/mce.c        |   35 +++++++++++++++++++++++++++++-
 3 files changed, 46 insertions(+), 6 deletions(-)

-- 
1.7.2

