Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752782Ab1BYGKT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 01:10:19 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59536 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751540Ab1BYGKR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 01:10:17 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=cGLjAHcJo/4vLRWDQDGl0SSEFe9N2+5uq1z87Q87eW60ryLKDjX7bK8sIaDt1BlD/d
         wD5dV1x13uWf7DvK3WxYP4KwLwTupGeU0Nah2HbA9h/2GO0H65vBa9Zl9y9jOd2EPBrx
         li1SAb9GTQOMODHV/HZ30jMClqFSgewiDJGuQ=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: jes@sgi.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 02/21]arch:ia64:setup.c remove one to many l's in the word.
Date: Thu, 24 Feb 2011 22:09:57 -0800
Message-Id: <1298614197-3494-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra "l" in the word.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 arch/ia64/sn/kernel/setup.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/arch/ia64/sn/kernel/setup.c b/arch/ia64/sn/kernel/setup.c
index dbc4cbe..65efc5d 100644
--- a/arch/ia64/sn/kernel/setup.c
+++ b/arch/ia64/sn/kernel/setup.c
@@ -592,7 +592,7 @@ void __cpuinit sn_cpu_init(void)
 	/*
 	 * Don't check status. The SAL call is not supported on all PROMs
 	 * but a failure is harmless.
-	 * Architechtuallly, cpu_init is always called twice on cpu 0. We
+	 * Architechtually, cpu_init is always called twice on cpu 0. We
 	 * should set cpu_number on cpu 0 once.
 	 */
 	if (cpuid == 0) {
-- 
1.7.4.1

