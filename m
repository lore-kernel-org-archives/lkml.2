Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932798Ab1JNM3p (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 08:29:45 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:58287 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932180Ab1JNM3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 08:29:43 -0400
Subject: [PATCH 10/21] tomoyo: drop unused Kconfig symbols
From: Paul Bolle <pebolle@tiscali.nl>
To: Kentaro Takeda <takedakn@nttdata.co.jp>,
        Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 14 Oct 2011 14:29:02 +0200
Message-ID: <1318595342.6132.67.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 security/tomoyo/Kconfig |   24 ------------------------
 1 files changed, 0 insertions(+), 24 deletions(-)

diff --git a/security/tomoyo/Kconfig b/security/tomoyo/Kconfig
index 7c7f8c1..d93df71 100644
--- a/security/tomoyo/Kconfig
+++ b/security/tomoyo/Kconfig
@@ -10,30 +10,6 @@ config SECURITY_TOMOYO
 	  found at <http://tomoyo.sourceforge.jp/>.
 	  If you are unsure how to answer this question, answer N.
 
-config SECURITY_TOMOYO_MAX_ACCEPT_ENTRY
-	int "Default maximal count for learning mode"
-	default 2048
-	range 0 2147483647
-	depends on SECURITY_TOMOYO
-	help
-	  This is the default value for maximal ACL entries
-	  that are automatically appended into policy at "learning mode".
-	  Some programs access thousands of objects, so running
-	  such programs in "learning mode" dulls the system response
-	  and consumes much memory.
-	  This is the safeguard for such programs.
-
-config SECURITY_TOMOYO_MAX_AUDIT_LOG
-	int "Default maximal count for audit log"
-	default 1024
-	range 0 2147483647
-	depends on SECURITY_TOMOYO
-	help
-	  This is the default value for maximal entries for
-	  audit logs that the kernel can hold on memory.
-	  You can read the log via /sys/kernel/security/tomoyo/audit.
-	  If you don't need audit logs, you may set this value to 0.
-
 config SECURITY_TOMOYO_OMIT_USERSPACE_LOADER
 	bool "Activate without calling userspace policy loader."
 	default n
-- 
1.7.4.4




