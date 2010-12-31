Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751747Ab0LaFss (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Dec 2010 00:48:48 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:54214 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876Ab0LaFso (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Dec 2010 00:48:44 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=sm2GRrHjq7wqf0oVg9dp3FsPBZO6sVpyR8I/6bguKHCyQfyomzamwXK86TP6mEh00x
         qfBcCHHbeqpWHH32K+2b+xyZtC4tkAybWHxyWFeQeMfqybm+K+WywMRa7KE3ZCrN22vE
         a8+8G0NHQYnGGi1KL5TJjnKG2aYonIT3GvGPY=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 01/15]drivers:staging:rtl8187se:r8180_93cx6.h Fix some comments.
Date: Thu, 30 Dec 2010 21:48:37 -0800
Message-Id: <1293774531-5294-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
In-Reply-To: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
References: <1293774531-5294-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below are some patches that either fix a typo in a comment and/or fixes a
comment altogether to make more sense. If there is anything I missed let me know
and I'll resend.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/staging/rtl8187se/r8180_93cx6.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rtl8187se/r8180_93cx6.h b/drivers/staging/rtl8187se/r8180_93cx6.h
index 79e7391..4a3e248 100644
--- a/drivers/staging/rtl8187se/r8180_93cx6.h
+++ b/drivers/staging/rtl8187se/r8180_93cx6.h
@@ -7,7 +7,7 @@
 	Parts of this driver are based on the rtl8180 driver skeleton from Patric Schenke & Andres Salomon
 	Parts of this driver are based on the Intel Pro Wireless 2100 GPL driver
 
-	We want to tanks the Authors of such projects and the Ndiswrapper project Authors.
+	We want to thanks the Authors of such projects and the Ndiswrapper project Authors.
 */
 
 /*This files contains card eeprom (93c46 or 93c56) programming routines*/
-- 
1.6.5.2.180.gc5b3e

