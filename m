Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751977Ab1HaEgT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Aug 2011 00:36:19 -0400
Received: from gate.crashing.org ([63.228.1.57]:52335 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750931Ab1HaEgQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Aug 2011 00:36:16 -0400
From: Kumar Gala <galak@kernel.crashing.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linuxppc-dev@ozlabs.org, linux-kernel@vger.kernel.org
Subject: [PATCH] powerpc: Remove linkage for sys_nfsservctl system call
Date: Tue, 30 Aug 2011 23:36:09 -0500
Message-Id: <1314765369-14486-1-git-send-email-galak@kernel.crashing.org>
X-Mailer: git-send-email 1.5.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The following commit didn't actually remove it from powerpc:

commit f5b940997397229975ea073679b03967932a541b
Author: NeilBrown <neilb@suse.de>
Date:   Fri Aug 26 18:03:11 2011 -0400

    All Arch: remove linkage for sys_nfsservctl system call

    The nfsservctl system call is now gone, so we should remove all
    linkage for it.

Signed-off-by: Kumar Gala <galak@kernel.crashing.org>
---
 arch/powerpc/include/asm/systbl.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/powerpc/include/asm/systbl.h b/arch/powerpc/include/asm/systbl.h
index f6736b7..fa0d27a 100644
--- a/arch/powerpc/include/asm/systbl.h
+++ b/arch/powerpc/include/asm/systbl.h
@@ -171,7 +171,7 @@ SYSCALL_SPU(setresuid)
 SYSCALL_SPU(getresuid)
 SYSCALL(ni_syscall)
 SYSCALL_SPU(poll)
-COMPAT_SYS(nfsservctl)
+SYSCALL(ni_syscall)
 SYSCALL_SPU(setresgid)
 SYSCALL_SPU(getresgid)
 COMPAT_SYS_SPU(prctl)
-- 
1.7.3.4

