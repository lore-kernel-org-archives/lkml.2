Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751993Ab0GYPO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Jul 2010 11:14:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:35649 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751884Ab0GYPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Jul 2010 11:14:58 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=GUSpwSbhI/CCu1JQPsjJVt+PyYylYP+NCg38Eeobr3tLMbM2wgjZcX5SAeGq6xqBmj
         dsEldFo/7aJ1OsPAfDePS6P2RPu7gUG+G2pBr/3dQnhdf6AUz9l1Fxd1gEkTLDplNFuO
         zOpwbjxZWvWlD7bZUdcIb1rUJX7cmBCUw/bUQ=
From: Michael Jensen <emjay1988@gmail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Michael Jensen <emjay1988@gmail.com>
Subject: [PATCH] Staging: comedi: comedidev: Removed unused macro definitions
Date: Mon, 26 Jul 2010 01:14:34 +1000
Message-Id: <1280070874-8961-1-git-send-email-emjay1988@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed macro definition that wasn't used.

Signed-off-by: Michael Jensen <emjay1988@gmail.com>
---
 drivers/staging/comedi/comedidev.h |    5 -----
 1 files changed, 0 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/comedi/comedidev.h b/drivers/staging/comedi/comedidev.h
index 4eb2b77..b225fff 100644
--- a/drivers/staging/comedi/comedidev.h
+++ b/drivers/staging/comedi/comedidev.h
@@ -61,11 +61,6 @@
 	module_init(x ## _init_module);					\
 	module_exit(x ## _cleanup_module);
 
-#define COMEDI_MODULE_MACROS						\
-	MODULE_AUTHOR("Comedi http://www.comedi.org");		\
-	MODULE_DESCRIPTION("Comedi low-level driver");			\
-	MODULE_LICENSE("GPL");
-
 #define COMEDI_INITCLEANUP(x)						\
 	COMEDI_MODULE_MACROS		\
 	COMEDI_INITCLEANUP_NOMODULE(x)
-- 
1.7.0.4

