Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753159Ab2EaQzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 12:55:37 -0400
Received: from mga03.intel.com ([143.182.124.21]:31962 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752560Ab2EaQzf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 12:55:35 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="150014539"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] One more x86/mce cleanup for 3.5
Date: Thu, 31 May 2012 09:55:34 -0700
Message-Id: <4fc7a286168635a9b@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 37c3459b67dd5a396a968e819cf4a86d24ac9ace:

  x86/mce: Add instruction recovery signatures to mce-severity table (2012-05-23 14:24:11 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce

for you to fetch changes up to 82f7af09e6fb58fb725c850d725d5e8780a9bec2:

  x86/mce: Cleanup timer mess (2012-05-30 14:40:01 -0700)

----------------------------------------------------------------
One more mce cleanup before the 3.5 merge window closes

----------------------------------------------------------------
Thomas Gleixner (1):
      x86/mce: Cleanup timer mess

 arch/x86/kernel/cpu/mcheck/mce.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)
