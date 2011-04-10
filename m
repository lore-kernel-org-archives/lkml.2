Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752898Ab1DJOLd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Apr 2011 10:11:33 -0400
Received: from mail-iy0-f194.google.com ([209.85.210.194]:46887 "EHLO
	mail-iy0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752326Ab1DJOLa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Apr 2011 10:11:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=wJl0nOPjdRUFz82MTZZXDsMJCYiHyTalt+AlwAY/8/1gk0A4Qi2w/3C4XbuyibbS8/
         0YtsGB3xdmQakMkCLzKGHG1tUgu5BbL0A5zbOkESJAtgy254lB5uPFCSUZI0WRTLUbgk
         RqcZwSAVlbZAxlcsin5w1amMEWqvCiH0ubpjw=
From: wanlong.gao@gmail.com
To: broonie@opensource.wolfsonmicro.com, geert@linux-m68k.org,
        starvik@axis.com, jesper.nilsson@axis.com, sameo@linux.intel.com,
        ian@opensource.wolfsonmicro.com, dp@opensource.wolfsonmicro.com,
        lrg@slimlogic.co.uk, James.Bottomley@suse.de, aelder@sgi.com
Cc: linux-kernel@vger.kernel.org, Wanlong Gao <wanlong.gao@gmail.com>
Subject: [PATCH 1/5] cris:removed the unused variable
Date: Sun, 10 Apr 2011 22:10:25 +0800
Message-Id: <1302444629-17043-1-git-send-email-wanlong.gao@gmail.com>
X-Mailer: git-send-email 1.7.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Wanlong Gao <wanlong.gao@gmail.com>

removed the unused variable "unsigned long tmp".

Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
---
 arch/cris/arch-v32/kernel/ptrace.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/arch/cris/arch-v32/kernel/ptrace.c b/arch/cris/arch-v32/kernel/ptrace.c
index 511ece9..42ed6c7 100644
--- a/arch/cris/arch-v32/kernel/ptrace.c
+++ b/arch/cris/arch-v32/kernel/ptrace.c
@@ -115,8 +115,6 @@ void user_disable_single_step(struct task_struct *child)
 void
 ptrace_disable(struct task_struct *child)
 {
-	unsigned long tmp;
-
 	/* Deconfigure SPC and S-bit. */
 	user_disable_single_step(child);
 	put_reg(child, PT_SPC, 0);
-- 
1.7.3

