Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759783Ab2CMVkr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 17:40:47 -0400
Received: from mga11.intel.com ([192.55.52.93]:46659 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2CMVkq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 17:40:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="138287136"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86/mce two miscellaneous MCE fixes
Date: Tue, 13 Mar 2012 14:40:45 -0700
Message-Id: <4f5fbedd16019e0539@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit b01543dfe67bb1d191998e90d20534dc354de059:

  Linux 3.3-rc4 (2012-02-18 15:53:33 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-for-tip

for you to fetch changes up to fadd85f16a8ec3fee8af599e79a209682dc52348:

  x86/mce: Fix return value of mce_chrdev_read() when erst is disabled (2012-02-22 13:14:16 -0800)

----------------------------------------------------------------
Two miscellaneous MCE fixes

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      x86/mce: Convert static array of pointers to per-cpu variables

Naoya Horiguchi (1):
      x86/mce: Fix return value of mce_chrdev_read() when erst is disabled

 arch/x86/include/asm/mce.h           |    2 +-
 arch/x86/kernel/cpu/mcheck/mce.c     |   14 ++++++++++----
 arch/x86/kernel/cpu/mcheck/mce_amd.c |    9 +++++----
 3 files changed, 16 insertions(+), 9 deletions(-)
