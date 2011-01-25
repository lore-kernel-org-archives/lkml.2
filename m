Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab1AYRJG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 12:09:06 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:56281 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753019Ab1AYRJC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 12:09:02 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=B1Ss2Yc6U45VSuebM3yyqdMeMuaz+VpDg0ddC2710q7HhBT/7fvq++WVlQ1AWakET8
         XYFgS3fNjL5ZB/fqXJc1SmkWNepaUEOuLi5M+oBzg67xKh4nCaVq23GjDfRFxJmB6JeM
         PUTeRicbsgEGLTs2AifyzuV/2hEd0QncPEGmA=
MIME-Version: 1.0
Date: Tue, 25 Jan 2011 22:39:01 +0530
Message-ID: <AANLkTi=-3GBLdM_dP5nb4s_pWR+-1KnN3F6ws1Enh2NP@mail.gmail.com>
Subject: [PATCH 2.6.37 4/4] edac: i82975x driver revision change
From: Arvind R <arvino55@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: trivial@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Subject: [PATCH 4/4] edac: i82975x driver revision change

bump up revision to reflect 3 patches

Signed-off-by: Arvind R. <arvino55@gmail.com>
---
 i82975x_edac.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)
---
diff -up a/drivers/edac/i82975x_edac.c b/drivers/edac/i82975x_edac.c
--- a/drivers/edac/i82975x_edac.c
+++ b/drivers/edac/i82975x_edac.c
@@ -16,7 +16,7 @@
 #include <linux/edac.h>
 #include "edac_core.h"

-#define I82975X_REVISION	" Ver: 1.0.0 " __DATE__
+#define I82975X_REVISION	" Ver: 1.0.3 " __DATE__
 #define EDAC_MOD_STR		"i82975x_edac"

 #define i82975x_printk(level, fmt, arg...) \
