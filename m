Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753906Ab1EISgo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 14:36:44 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:55042 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753803Ab1EISgg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 14:36:36 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: X86-ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [PATCH -v3 1/6] x86, MCE: Add a HW injection flag
Date: Mon,  9 May 2011 20:35:50 +0200
Message-Id: <1304966155-9841-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1304966155-9841-1-git-send-email-bp@amd64.org>
References: <1304966155-9841-1-git-send-email-bp@amd64.org>
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
index eb16e94..a2e3dcf 100644
--- a/arch/x86/include/asm/mce.h
+++ b/arch/x86/include/asm/mce.h
@@ -49,6 +49,7 @@
 #define MCJ_CTX_IRQ		2    /* inject context: IRQ */
 #define MCJ_NMI_BROADCAST	4    /* do NMI broadcasting */
 #define MCJ_EXCEPTION		8    /* raise as exception */
+#define MCJ_HW_INJECT		16   /* do a HW MCE inject, i.e. INT18 */
 
 /* Fields are zero when not available */
 struct mce {
-- 
1.7.4.rc2

