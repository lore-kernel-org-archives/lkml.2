Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757903Ab0D3Qwu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 12:52:50 -0400
Received: from mail.windriver.com ([147.11.1.11]:58316 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757738Ab0D3Qwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 12:52:42 -0400
From: Jason Wessel <jason.wessel@windriver.com>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, kgdb-bugreport@lists.sourceforge.net,
       stable@kernel.org
Subject: [GIT PULL] kgdb fix for 2.6.34-rc5
Date: Thu, 29 Apr 2010 21:56:36 -0500
Message-Id: <1272596197-27909-1-git-send-email-jason.wessel@windriver.com>
X-Mailer: git-send-email 1.6.4.rc1
X-OriginalArrivalTime: 30 Apr 2010 02:56:44.0983 (UTC) FILETIME=[C4A63C70:01CAE810]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus, please pull the for_linus branch for 2.6.34-rc5.  

git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git for_linus

This is a hole introduced into the powerpc booke code long before the
kgdb core was merged to the mainline dating all the way back to 2.4.
This is the fix for CVE-2010-1446.

Thanks,
Jason.


---
The following changes since commit 79dba2eaa771c3173957eccfd288e0e0d12e4d3f:
  Linus Torvalds (1):
        Merge branch 'for-linus' of git://git.kernel.org/.../jbarnes/pci-2.6

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/jwessel/linux-2.6-kgdb.git ..BRANCH.NOT.VERIFIED..

Wufei (1):
      kgdb: don't needlessly skip PAGE_USER test for Fsl booke

 arch/powerpc/mm/fsl_booke_mmu.c |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)
