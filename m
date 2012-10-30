Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab2J3WBz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Oct 2012 18:01:55 -0400
Received: from mga02.intel.com ([134.134.136.20]:41162 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753225Ab2J3WBx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Oct 2012 18:01:53 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,683,1344236400"; 
   d="scan'208";a="213206618"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org, tangchen@cn.fujitsu.com,
        miaox@cn.fujitsu.com, bp@alien8.de
Subject: [GIT PULL] Fix a cmci discovery problem
Date: Tue, 30 Oct 2012 15:01:53 -0700
Message-Id: <50904e5125023a741@agluck-desk.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 8f0d8163b50e01f398b14bcd4dc039ac5ab18d64:

  Linux 3.7-rc3 (2012-10-28 12:24:48 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/please-pull-tangchen

for you to fetch changes up to 85b97637bb40a9f486459dd254598759af9c3d50:

  x86/mce: Do not change worker's running cpu in cmci_rediscover(). (2012-10-30 14:38:12 -0700)

----------------------------------------------------------------
Fix problem in CMCI rediscovery code that was illegally
migrating worker threads to other cpus.

----------------------------------------------------------------
Tang Chen (1):
      x86/mce: Do not change worker's running cpu in cmci_rediscover().

 arch/x86/kernel/cpu/mcheck/mce_intel.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)
