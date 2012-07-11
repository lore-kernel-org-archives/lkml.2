Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2GKRpb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 13:45:31 -0400
Received: from mga09.intel.com ([134.134.136.24]:61378 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755289Ab2GKRp3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 13:45:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="164391977"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        "the arch/x86 maintainers" <x86@kernel.org>
In-Reply-To: <CA+8MBbJjhVgEM7bJzZOSFvT6+RBLUQV6KtdzShuBxBH_nDxo4w@mail.gmail.com>
Subject: [GIT PULL v2] x86/mce fix (ready for 3.6 merge window)
Date: Wed, 11 Jul 2012 10:45:29 -0700
Message-Id: <4ffdbbb9135702cfae@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following changes since commit 6887a4131da3adaab011613776d865f4bcfb5678:

  Linux 3.5-rc5 (2012-06-30 16:08:57 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-ripvfix

for you to fetch changes up to 6751ed65dc6642af64f7b8a440a75563c8aab7ae:

  x86/mce: Fix siginfo_t->si_addr value for non-recoverable memory faults (2012-07-11 10:20:47 -0700)

----------------------------------------------------------------
Fix application level machine check recovery

----------------------------------------------------------------
Tony Luck (1):
      x86/mce: Fix siginfo_t->si_addr value for non-recoverable memory faults

 arch/x86/kernel/cpu/mcheck/mce.c |  6 ++++--
 include/linux/mm.h               |  1 +
 mm/memory-failure.c              | 14 ++++++++------
 3 files changed, 13 insertions(+), 8 deletions(-)
