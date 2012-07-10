Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753850Ab2GJRux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 13:50:53 -0400
Received: from mga02.intel.com ([134.134.136.20]:54074 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753173Ab2GJRuv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 13:50:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="163888891"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86/mce fix (ready for 3.6 merge window)
Date: Tue, 10 Jul 2012 10:50:51 -0700
Message-Id: <4ffc6b7b63006ca92@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce-ripvfix

for you to fetch changes up to b99c2fc9366d4e32b8d087cd28f6dbf5f7932dae:

  x86/mce: Need to let kill_proc() send signal to doomed process (2012-07-10 10:18:29 -0700)

----------------------------------------------------------------
Fix application level machine check recovery

----------------------------------------------------------------
Tony Luck (1):
      x86/mce: Need to let kill_proc() send signal to doomed process

 arch/x86/kernel/cpu/mcheck/mce.c |  6 ++++--
 include/linux/mm.h               |  1 +
 mm/memory-failure.c              | 10 ++++++----
 3 files changed, 11 insertions(+), 6 deletions(-)
