Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762203Ab2EQRKc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 13:10:32 -0400
Received: from mga11.intel.com ([192.55.52.93]:8664 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758969Ab2EQRKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 13:10:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="167699860"
From: "Luck, Tony" <tony.luck@intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [git pull] machine check recovery fix
Date: Thu, 17 May 2012 10:10:30 -0700
Message-Id: <4fb531069693a1b42@agluck-desktop.sc.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus: Sent this to you on Monday as a patch:
	https://lkml.org/lkml/2012/5/14/350
perhaps it got lost. Here it is again in handy "git pull" form:

The following changes since commit d48b97b403d23f6df0b990cee652bdf9a52337a3:

  Linux 3.4-rc6 (2012-05-06 15:07:32 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/ras/ras.git tags/linus-mce-fix

for you to fetch changes up to dad1743e5993f19b3d7e7bd0fb35dc45b5326626:

  x86/mce: Only restart instruction after machine check recovery if it is safe (2012-05-14 15:07:48 -0700)

----------------------------------------------------------------
Fix machine check recovery

----------------------------------------------------------------
Tony Luck (1):
      x86/mce: Only restart instruction after machine check recovery if it is safe

 arch/x86/kernel/cpu/mcheck/mce.c |   14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)
