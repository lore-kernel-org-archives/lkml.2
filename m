Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753845Ab2I0RyF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 13:54:05 -0400
Received: from mga01.intel.com ([192.55.52.88]:42425 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab2I0RyD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 13:54:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,496,1344236400"; 
   d="scan'208";a="227749583"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86/mce allow bios to set per-bank CMCI threshold
Date: Thu, 27 Sep 2012 10:54:03 -0700
Message-Id: <506492bb2170819722@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 961ebea4ae68075bb5a0acc19f5852bed82bb877:

  Merge tag 'ras_queue_for_3.7' of git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras into x86/mce (2012-09-19 17:01:50 +0200)

are available in the git repository at:


  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-naveen

for you to fetch changes up to 450cc201038f31bd496e1b3a44a49790b8827a06:

  x86/mce: Provide boot argument to honour bios-set CMCI threshold (2012-09-27 10:08:00 -0700)

----------------------------------------------------------------
Option to let the bios set per-bank CMCI thresholds so they can
filter noisy error sources at a fine grained level based on platform
specific knowledge.

----------------------------------------------------------------
Naveen N. Rao (1):
      x86/mce: Provide boot argument to honour bios-set CMCI threshold

 Documentation/x86/x86_64/boot-options.txt |  7 +++++++
 arch/x86/include/asm/mce.h                |  1 +
 arch/x86/kernel/cpu/mcheck/mce.c          | 10 +++++++++
 arch/x86/kernel/cpu/mcheck/mce_intel.c    | 35 ++++++++++++++++++++++++++++---
 4 files changed, 50 insertions(+), 3 deletions(-)
