Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757487Ab1FPJpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 05:45:33 -0400
Received: from na3sys009aog101.obsmtp.com ([74.125.149.67]:38489 "EHLO
	na3sys009aog101.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756686Ab1FPJp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 05:45:28 -0400
From: Felipe Balbi <balbi@ti.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Felipe Balbi <balbi@ti.com>
Subject: [PATCH 2/2] init: drop trailing semicolon from module_init/module_exit
Date: Thu, 16 Jun 2011 12:45:15 +0300
Message-Id: <1308217515-18529-2-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <1308217515-18529-1-git-send-email-balbi@ti.com>
References: <20110616093720.GL12230@legolas.emea.dhcp.ti.com>
 <1308217515-18529-1-git-send-email-balbi@ti.com>
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
index 9146f39..f04e760 100644
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
1.7.6.rc1

