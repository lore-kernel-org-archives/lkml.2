Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755151Ab1EPXlh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 19:41:37 -0400
Received: from na3sys009aog116.obsmtp.com ([74.125.149.240]:44422 "EHLO
	na3sys009aog116.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753285Ab1EPXld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 19:41:33 -0400
From: Felipe Balbi <balbi@ti.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [RESEND/PATCH 2/2] init: drop trailing semicolon from module_init/module_exit
Date: Tue, 17 May 2011 02:41:10 +0300
Message-Id: <1305589270-5389-3-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.4.1.343.ga91df
In-Reply-To: <1305589270-5389-1-git-send-email-balbi@ti.com>
References: <1305589270-5389-1-git-send-email-balbi@ti.com>
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

now that all drivers add ; to the end of module_init()
and module_exit(), we can safely remove it from the
definition.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 include/linux/init.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/linux/init.h b/include/linux/init.h
index 577671c5..8532f7c 100644
--- a/include/linux/init.h
+++ b/include/linux/init.h
@@ -263,7 +263,7 @@ void __init parse_early_options(char *cmdline);
  * builtin) or at module insertion time (if a module).  There can only
  * be one per module.
  */
-#define module_init(x)	__initcall(x);
+#define module_init(x)	__initcall(x)
 
 /**
  * module_exit() - driver exit entry point
@@ -275,7 +275,7 @@ void __init parse_early_options(char *cmdline);
  * compiled into the kernel, module_exit() has no effect.
  * There can only be one per module.
  */
-#define module_exit(x)	__exitcall(x);
+#define module_exit(x)	__exitcall(x)
 
 #else /* MODULE */
 
-- 
1.7.4.1.343.ga91df

