Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752583Ab0IMGs4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 02:48:56 -0400
Received: from mga03.intel.com ([143.182.124.21]:58258 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751867Ab0IMGsz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 02:48:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,358,1280732400"; 
   d="scan'208";a="323825481"
From: Feng Tang <feng.tang@intel.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, alan@linux.intel.com, greg@kroah.com,
        Feng Tang <feng.tang@intel.com>
Subject: [PATCH v3 0/4] Enabling patches of 2 early consoles for Intel MID platforms 
Date: Mon, 13 Sep 2010 15:08:52 +0800
Message-Id: <1284361736-23011-1-git-send-email-feng.tang@intel.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This serie mainly enables 2 early consoles named mrst and hsu for
Intel MID platforms. please help to review, thanks,

- Feng

Changelog:
	v3:
	     * Fix a warning for mrst.h
	     * Add 2 helper funcs for fixed address mapping as
	       suggested by Ingo
	     * Rename the mrst_earlyprintk.c to early_printk_mrst.c
	     * Clean the code and fix typoes upon Ingo's comments
	v2:
	     * Code clean as suggested by Ingo 
----------------------------------------------------------------

Feng Tang (4):
  x86, mrst: make mrst_identify_cpu() inlne inside mrst.h
  x86: add two helper macros for fixed address mapping
  x86, earlyprintk: add earlyprintk for Intel Moorestown platform
  x86, earlyprintk: add hsu early console for Intel Medfield platform

 arch/x86/Kconfig.debug              |    4 +
 arch/x86/include/asm/fixmap.h       |   15 ++
 arch/x86/include/asm/mrst.h         |   10 +-
 arch/x86/kernel/Makefile            |    1 +
 arch/x86/kernel/early_printk.c      |   13 ++
 arch/x86/kernel/early_printk_mrst.c |  319 +++++++++++++++++++++++++++++++++++
 6 files changed, 361 insertions(+), 1 deletions(-)
 mode change 100644 => 100755 arch/x86/include/asm/fixmap.h
 create mode 100644 arch/x86/kernel/early_printk_mrst.c

