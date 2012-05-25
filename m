Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754137Ab2EYQmL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 12:42:11 -0400
Received: from mga09.intel.com ([134.134.136.24]:20382 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab2EYQmJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 12:42:09 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="148464393"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] x86/mce changes
Date: Fri, 25 May 2012 09:42:09 -0700
Message-Id: <4fbfb661409215304@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:

  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/x86-mce-merge

for you to fetch changes up to 37c3459b67dd5a396a968e819cf4a86d24ac9ace:

  x86/mce: Add instruction recovery signatures to mce-severity table (2012-05-23 14:24:11 -0700)

----------------------------------------------------------------
x86/mce merge window patches (including two that make error_context() checks less sucky)

----------------------------------------------------------------
Andi Kleen (1):
      MCE: Fix vm86 handling for 32bit mce handler

Chen Gong (1):
      x86/mce Add validation check before GHES error is recorded

Tony Luck (3):
      x86/mce: Avoid reading every machine check bank register twice.
      x86/mce: Fix check for processor context when machine check was taken.
      x86/mce: Add instruction recovery signatures to mce-severity table

 arch/x86/kernel/cpu/mcheck/mce-apei.c     |  3 ++-
 arch/x86/kernel/cpu/mcheck/mce-severity.c | 26 ++++++++++++++++++++------
 arch/x86/kernel/cpu/mcheck/mce.c          | 24 +++++++++++++++++++-----
 3 files changed, 41 insertions(+), 12 deletions(-)
