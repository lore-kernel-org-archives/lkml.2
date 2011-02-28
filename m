Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752464Ab1B1ErK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 23:47:10 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:41887 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab1B1ErI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 23:47:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=ajDiOChB/uWnRcKN6KuxUSNN8Z3+tmjAS3BXMFAhIqwJl5+ByUZ2J3JpwDEAPFDBMU
         btkfcp8ldj6UwR7yPQ7h7TPCOfIVaXdENgBpWNPKF0/LQCNJonewPGzPZ8SDeJgaPEwE
         yRNECX9hQZ5uZx7i1S7/5AcJCRwTwk5k7dX0s=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: jes@sgi.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, hans.boehm@hp.com,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH v3 02/21]arch:ia64:setup.c Typo fix  Architechtuallly
Date: Sun, 27 Feb 2011 20:46:46 -0800
Message-Id: <1298868406-4108-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch(hopefully)fixes a typo in a comment.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/sn/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index dbc4cbe..77db0b5 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -592,7 +592,7 @@ void __cpuinit sn_cpu_init(void)
 	/*
 	 * Don't check status. The SAL call is not supported on all PROMs
 	 * but a failure is harmless.
-	 * Architechtuallly, cpu_init is always called twice on cpu 0. We
+	 * Architecturally, cpu_init is always called twice on cpu 0. We
 	 * should set cpu_number on cpu 0 once.
 	 */
 	if (cpuid == 0) {
-- 
1.7.4.1

