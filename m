Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751708Ab0GWGLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 02:11:31 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58010 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751266Ab0GWGL3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 02:11:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=oJyb4tK0B0GE9KPXTux7dPT913XkLUnDDmzqiOURYfh787emCUuzP/WeF+x9zq0JXB
         NV/4aFi+bNUGtM7k9K4/vh3RdcBvlSpBYzNELO4e1iM+JGudJPrzIi7Qf0oexCliN+80
         Jvam5ov8pKQflhpZv1fes+vMMJSeacIjh5CX4=
From: Michael Jensen <emjay1988@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michael Jensen <emjay1988@gmail.com>
Subject: [PATCH] Staging: comedi: comedidev: Fixed a macro definition code style issue
Date: Fri, 23 Jul 2010 16:11:07 +1000
Message-Id: <1279865467-16522-1-git-send-email-emjay1988@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a code style issue.

Signed-off-by: Michael Jensen <emjay1988@gmail.com>
---
 drivers/staging/comedi/comedidev.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 4eb2b77..a46e859 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -61,10 +61,11 @@
 	module_init(x ## _init_module);					\
 	module_exit(x ## _cleanup_module);
 
-#define COMEDI_MODULE_MACROS						\
-	MODULE_AUTHOR("Comedi http://www.comedi.org");		\
+#define COMEDI_MODULE_MACROS		do {				\
+	MODULE_AUTHOR("Comedi http://www.comedi.org");			\
 	MODULE_DESCRIPTION("Comedi low-level driver");			\
-	MODULE_LICENSE("GPL");
+	MODULE_LICENSE("GPL");						\
+} while (0)
 
 #define COMEDI_INITCLEANUP(x)						\
 	COMEDI_MODULE_MACROS		\
-- 
1.7.0.4

