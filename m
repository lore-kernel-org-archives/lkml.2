Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754940Ab1BRPrb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:47:31 -0500
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:37920 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500Ab1BRPr2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:47:28 -0500
From: Borislav Petkov <bp@amd64.org>
To: <x86@kernel.org>
Cc: <linux-kernel@vger.kernel.org>, Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH] x86, system.h: Drop unused __SAVE/__RESTORE macros
Date: Fri, 18 Feb 2011 16:47:36 +0100
Message-Id: <1298044056-31104-1-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Those are unused since at least the beginning of git history.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
---
 arch/x86/include/asm/system.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/system.h b/arch/x86/include/asm/system.h
index 33ecc3e..12569e6 100644
--- a/arch/x86/include/asm/system.h
+++ b/arch/x86/include/asm/system.h
@@ -98,8 +98,6 @@ do {									\
  */
 #define HAVE_DISABLE_HLT
 #else
-#define __SAVE(reg, offset) "movq %%" #reg ",(14-" #offset ")*8(%%rsp)\n\t"
-#define __RESTORE(reg, offset) "movq (14-" #offset ")*8(%%rsp),%%" #reg "\n\t"
 
 /* frame pointer must be last for get_wchan */
 #define SAVE_CONTEXT    "pushf ; pushq %%rbp ; movq %%rsi,%%rbp\n\t"
-- 
1.7.4.rc2

