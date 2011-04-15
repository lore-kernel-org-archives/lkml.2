Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753173Ab1DOPUx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 11:20:53 -0400
Received: from s15228384.onlinehome-server.info ([87.106.30.177]:53109 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750707Ab1DOPUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 11:20:52 -0400
From: Borislav Petkov <bp@amd64.org>
To: EDAC devel <linux-edac@vger.kernel.org>
Cc: Tony Luck <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Prarit Bhargava <prarit@redhat.com>, X86-ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Borislav Petkov <borislav.petkov@amd.com>
Subject: [RFC PATCH 1/4] x86, MCE: Add a HW injection flag
Date: Fri, 15 Apr 2011 17:20:24 +0200
Message-Id: <1302880827-22457-2-git-send-email-bp@amd64.org>
X-Mailer: git-send-email 1.7.4.rc2
In-Reply-To: <1302880827-22457-1-git-send-email-bp@amd64.org>
References: <1302880827-22457-1-git-send-email-bp@amd64.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <borislav.petkov@amd.com>

Add an mce->inject_flag to denote that we're doing HW injection.

Signed-off-by: Borislav Petkov <borislav.petkov@amd.com>
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

