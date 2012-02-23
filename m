Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756689Ab2BWTpl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 14:45:41 -0500
Received: from mga01.intel.com ([192.55.52.88]:46184 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752177Ab2BWTpk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 14:45:40 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="128734249"
From: "Luck, Tony" <tony.luck@intel.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org
Subject: [GIT PULL] x86/mce recovery cleanup patch
Date: Thu, 23 Feb 2012 11:45:40 -0800
Message-Id: <4f46976434651797d@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo,

This is the patch to replace some hard coded constants that we discussed
here: https://lkml.org/lkml/2012/1/27/127

I'd coded it up four weeks ago, but forgot to send you a pull. This
goes on top of the previous patchset for mce recovery that is sitting
in your x86/mce branch of the tip tree waiting for the 3.4 merge window.

-Tony

The following changes since commit 5f7b88d51e89771f64c15903b96b5933dd0bc6d8:

  x86/mce: Recognise machine check bank signature for data path error (2012-01-03 12:07:07 -0800)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git mce-recovery-for-tip

for you to fetch changes up to 08dda402d60a721ac94e79efd7646b332be3e3b2:

  x86/mce: Replace hard coded hex constants with symbolic defines (2012-01-26 16:02:22 -0800)

----------------------------------------------------------------
Symbolic defines for architectural MCACOD constants

----------------------------------------------------------------
Tony Luck (1):
      x86/mce: Replace hard coded hex constants with symbolic defines

 arch/x86/kernel/cpu/mcheck/mce-severity.c |   14 ++++++++++----
 1 files changed, 10 insertions(+), 4 deletions(-)
