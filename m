Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932122Ab1BYHH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Feb 2011 02:07:26 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:45911 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754361Ab1BYHHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Feb 2011 02:07:25 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=WR8XdsycQQY2PhDkBLm5qck2h+ahReGxd8P81mfQfaREwpki2GdzHrwdAdjhHzUoel
         KO9EZg/7Hfy6c0bPsANfYhoKJ9pwPfZHN0nHkQ6DavLCJjbYtgbjTsJ7C7tJFm5twUW1
         vobNI53Hc6I7YezoGWIgm/2EhXV1yzYa2ve1Q=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: jes@sgi.com, tony.luck@intel.com, linux-ia64@vger.kernel.org,
        linux-kernel@vger.kernel.org, joe@perches.com, hans.boehm@hp.com,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH V3 02/21]arch:ia64:setup.c remove one to many l's in the word. 
Date: Thu, 24 Feb 2011 23:07:05 -0800
Message-Id: <1298617625-6227-1-git-send-email-justinmattock@gmail.com>
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

