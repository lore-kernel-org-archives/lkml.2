Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932532Ab0JLNXX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 09:23:23 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:44214 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932340Ab0JLNXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 09:23:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KMamOoV5SU2jwkOjSQy1x71UX9fMym8OdU2XYBpKE6XphuaWNv4A1MlolnObc0XYm5
         D6g02JsY6h+A+mvcbSf65/7cq6IURWxl2f+Yanh1Am4pDz8/6vZiac0u3C4rsSh4uZpN
         7k4knI2aTMXzK4nHXl8/z+cU+FHUaU2ukoqeQ=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
Subject: [PATCH 2/2] staging: wlags49_h2: remove custom macros min() and max()
Date: Tue, 12 Oct 2010 16:22:49 +0300
Message-Id: <6a47ed73fed16a1b398ec4e171fbedad9700a335.1286889640.git.ext-andriy.shevchenko@nokia.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <58ee6c5338ae1c6dc18633e48fad1b753c0f7ec7.1286889640.git.ext-andriy.shevchenko@nokia.com>
References: <58ee6c5338ae1c6dc18633e48fad1b753c0f7ec7.1286889640.git.ext-andriy.shevchenko@nokia.com>
In-Reply-To: <58ee6c5338ae1c6dc18633e48fad1b753c0f7ec7.1286889640.git.ext-andriy.shevchenko@nokia.com>
References: <58ee6c5338ae1c6dc18633e48fad1b753c0f7ec7.1286889640.git.ext-andriy.shevchenko@nokia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Andy Shevchenko <ext-andriy.shevchenko@nokia.com>
---
 drivers/staging/wlags49_h2/hcf.c    |    1 +
 drivers/staging/wlags49_h2/hcfdef.h |    8 --------
 2 files changed, 1 insertions(+), 8 deletions(-)

diff --git a/drivers/staging/wlags49_h2/hcf.c b/drivers/staging/wlags49_h2/hcf.c
index c4fe0ec..d4bdd3e 100644
--- a/drivers/staging/wlags49_h2/hcf.c
+++ b/drivers/staging/wlags49_h2/hcf.c
@@ -92,6 +92,7 @@
 #include "hcf.h"				// HCF and MSF common include file
 #include "hcfdef.h"				// HCF specific include file
 #include "mmd.h"				// MoreModularDriver common include file
+#include <linux/kernel.h>
 
 #if ! defined offsetof
 #define offsetof(s,m)   ((unsigned int)&(((s *)0)->m))
diff --git a/drivers/staging/wlags49_h2/hcfdef.h b/drivers/staging/wlags49_h2/hcfdef.h
index f7e74bf..4e20171 100644
--- a/drivers/staging/wlags49_h2/hcfdef.h
+++ b/drivers/staging/wlags49_h2/hcfdef.h
@@ -593,14 +593,6 @@ err: ;
 /**************************************  MACROS  ************************************************/
 /************************************************************************************************/
 
-/* min and max macros */
-#if ! defined max
-#define max(a,b)  		(((a) > (b)) ? (a) : (b))
-#endif
-#if ! defined min
-#define min(a,b)  		(((a) < (b)) ? (a) : (b))
-#endif
-
 #ifdef HCF_SLEEP
 #if defined MSF_WAIT
 err: MSF should no longer supply this macro;
-- 
1.6.3.3

