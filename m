Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab2GRQto (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jul 2012 12:49:44 -0400
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:61408 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753242Ab2GRQt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jul 2012 12:49:29 -0400
X-RZG-AUTH: :P2EQZWCpfu+qG7CngxMFH1J+zrwiavkK6tmQaLfmwtM48/lq387pErHR
X-RZG-CLASS-ID: mo00
From: olaf@aepfle.de
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Olaf Hering <olaf@aepfle.de>
Subject: [PATCH] fix comment typo in mtrr_bp_init
Date: Wed, 18 Jul 2012 18:49:26 +0200
Message-Id: <1342630166-16601-1-git-send-email-olaf@aepfle.de>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olaf Hering <olaf@aepfle.de>

Signed-off-by: Olaf Hering <olaf@aepfle.de>

diff --git a/arch/x86/kernel/cpu/mtrr/main.c b/arch/x86/kernel/cpu/mtrr/main.c
index 6b96110..b5a0fd8 100644
--- a/arch/x86/kernel/cpu/mtrr/main.c
+++ b/arch/x86/kernel/cpu/mtrr/main.c
@@ -606,7 +606,7 @@ void __init mtrr_bp_init(void)
 
 		/*
 		 * This is an AMD specific MSR, but we assume(hope?) that
-		 * Intel will implement it to when they extend the address
+		 * Intel will implement it too when they extend the address
 		 * bus of the Xeon.
 		 */
 		if (cpuid_eax(0x80000000) >= 0x80000008) {
-- 
1.7.10.4

