Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756502Ab1JSOwz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 10:52:55 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:38447 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756394Ab1JSOvb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 10:51:31 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>, Ingo Molnar <mingo@elte.hu>,
        X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH 5/9] x86, MCE: Add a HW injection flag
Date: Wed, 19 Oct 2011 16:51:02 +0200
Message-Id: <1319035866-29570-6-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1319035866-29570-1-git-send-email-bp@amd64.org>
References: <1319035866-29570-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add an mce->inject_flag to denote that we're doing HW injection.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
Acked-by: Ingo Molnar <mingo@elte.hu>
---
 arch/x86/include/asm/mce.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/mce.h b/arch/x86/include/asm/mce.h
index 545e8e4..233cf03 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -54,6 +54,7 @@
 #define MCJ_CTX_IRQ		2    /* inject context: IRQ */
 #define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
 #define MCJ_EXCEPTION		8    /* raise as exception */
+#define MCJ_HW_MSR_INJECT	16   /* HW MCE injection method */
 
 /* Fields are zero when not available */
 struct mce {
-- 
1.7.4.rc2

