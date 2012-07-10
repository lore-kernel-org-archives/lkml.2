Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2GJWbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 18:31:24 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53222 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754174Ab2GJWbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 18:31:20 -0400
From: Jon Mason <jdmason@kudzu.us>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [trivial PATCH 5/7] hpet: Remove unused PCI Vendor ID #define
Date: Tue, 10 Jul 2012 15:31:30 -0700
Message-Id: <1341959492-31389-5-git-send-email-jdmason@kudzu.us>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
References: <1341959492-31389-1-git-send-email-jdmason@kudzu.us>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HPET_ID_VENDOR_8086 is defined but never used.  It would be a redefine
of PCI_VENDOR_ID_INTEL if it was ever used.

Signed-off-by: Jon Mason <jdmason@kudzu.us>
---
 arch/x86/include/asm/hpet.h |    2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/include/asm/hpet.h b/arch/x86/include/asm/hpet.h
index 2c392d6..434e210 100644
--- a/arch/x86/include/asm/hpet.h
+++ b/arch/x86/include/asm/hpet.h
@@ -35,8 +35,6 @@
 #define	HPET_ID_NUMBER_SHIFT	8
 #define HPET_ID_VENDOR_SHIFT	16
 
-#define HPET_ID_VENDOR_8086	0x8086
-
 #define HPET_CFG_ENABLE		0x001
 #define HPET_CFG_LEGACY		0x002
 #define	HPET_LEGACY_8254	2
-- 
1.7.9.5

