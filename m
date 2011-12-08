Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753127Ab1LHJxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 04:53:15 -0500
Received: from smtprelay01.ispgateway.de ([80.67.31.39]:53731 "EHLO
	smtprelay01.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab1LHJxM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 04:53:12 -0500
X-Greylist: delayed 410 seconds by postgrey-1.27 at vger.kernel.org; Thu, 08 Dec 2011 04:53:11 EST
Message-ID: <4EE08769.1070701@selhorst.net>
Date: Thu, 08 Dec 2011 10:46:17 +0100
From: Marcel Selhorst <tpmdd@selhorst.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111109 Thunderbird/7.0.1
MIME-Version: 1.0
To: TPM Device Driver List <tpmdd-devel@lists.sourceforge.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: tpm-new-email-address-for-tpm_infineon-driver.patch
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-AntiVirus: checked by Avira MailGate (version: 2.1.4-7; AVE: 7.9.6.128; VDF: 7.11.19.25; host: mail.selhorst.net); id=18516-6arZKi
X-Df-Sender: MTc0NDk5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

my contact details have changed, please find a patch below.

Signed-off-by: Marcel Selhorst <tpmdd@selhorst.net>
---
diff -pruN linux-3.1.4.old/MAINTAINERS linux-3.1.4.new/MAINTAINERS
--- linux-3.1.4.old/MAINTAINERS	2011-11-28 23:48:14.000000000 +0100
+++ linux-3.1.4.new/MAINTAINERS	2011-12-08 10:15:19.752440618 +0100
@@ -6491,7 +6491,8 @@ TPM DEVICE DRIVER
 M:	Debora Velarde <debora@linux.vnet.ibm.com>
 M:	Rajiv Andrade <srajiv@linux.vnet.ibm.com>
 W:	http://tpmdd.sourceforge.net
-M:	Marcel Selhorst <m.selhorst@sirrix.com>
+M:	Marcel Selhorst <tpmdd@selhorst.net>
+M:	Sirrix AG <tpmdd@sirrix.com>
 W:	http://www.sirrix.com
 L:	tpmdd-devel@lists.sourceforge.net (moderated for non-subscribers)
 S:	Maintained
diff -pruN linux-3.1.4.old/drivers/char/tpm/tpm_infineon.c linux-3.1.4.new/drivers/char/tpm/tpm_infineon.c
--- linux-3.1.4.old/drivers/char/tpm/tpm_infineon.c	2011-11-28 23:48:14.000000000 +0100
+++ linux-3.1.4.new/drivers/char/tpm/tpm_infineon.c	2011-12-08 10:37:10.876440286 +0100
@@ -4,8 +4,8 @@
  * SLD 9630 TT 1.1 and SLB 9635 TT 1.2 Trusted Platform Module
  * Specifications at www.trustedcomputinggroup.org
  *
- * Copyright (C) 2005, Marcel Selhorst <m.selhorst@sirrix.com>
- * Sirrix AG - security technologies, http://www.sirrix.com and
+ * Copyright (C) 2005, Marcel Selhorst <tpmdd@selhorst.net>
+ * Sirrix AG - security technologies <tpmdd@sirrix.com> and
  * Applied Data Security Group, Ruhr-University Bochum, Germany
  * Project-Homepage: http://www.trust.rub.de/projects/linux-device-driver-infineon-tpm/
  *
@@ -671,7 +671,7 @@ static void __exit cleanup_inf(void)
 module_init(init_inf);
 module_exit(cleanup_inf);

-MODULE_AUTHOR("Marcel Selhorst <m.selhorst@sirrix.com>");
+MODULE_AUTHOR("Marcel Selhorst <tpmdd@selhorst.net>");
 MODULE_DESCRIPTION("Driver for Infineon TPM SLD 9630 TT 1.1 / SLB 9635 TT 1.2");
 MODULE_VERSION("1.9.2");
 MODULE_LICENSE("GPL");

