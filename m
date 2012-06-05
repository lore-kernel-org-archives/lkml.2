Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752200Ab2FEWGt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 18:06:49 -0400
Received: from mga02.intel.com ([134.134.136.20]:45471 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750764Ab2FEWGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 18:06:48 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="153375205"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86/mce regression fix
Date: Tue, 05 Jun 2012 15:06:48 -0700
Message-Id: <4fce82f8371247cc@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 82f7af09e6fb58fb725c850d725d5e8780a9bec2:

  x86/mce: Cleanup timer mess (2012-05-30 14:40:01 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-mce

for you to fetch changes up to c2238f10e0c34a85a2a555c8a197316d1ca3fb7e:

  x86/mce: Fix the MCE poll timer logic (2012-06-05 10:15:07 -0700)

----------------------------------------------------------------
Typo/thinko in a cleanup caused a semantic change. Fix it.

----------------------------------------------------------------
Chen Gong (1):
      x86/mce: Fix the MCE poll timer logic

 arch/x86/kernel/cpu/mcheck/mce.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
