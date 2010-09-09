Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757088Ab0IIWck (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:32:40 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:41656 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932651Ab0IIWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:32:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=kFyTS2UxFkOMLVnzQsME6zS0b2Y1e+sLp8kSTRxFV+RabIMu4peSQ+4Q9i5VlU3YH5
         IPgJo4JIrSe7xTd/v4DpG8UAlW7Z1DPkVYqenWQD8Zf9gKFVK0vpHMjw/v/qRIIPQJQY
         WtcsVosEQfOm95hOOP7VLpNifZNVCM5TtXB2Q=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 098/223]drivers/net/wireless/p54/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:32:41 -0700
Message-Id: <1284071562-7948-8-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071562-7948-1-git-send-email-justinmattock@gmail.com>
References: <1284071562-7948-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/wireless/p54/Kconfig |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/p54/Kconfig b/drivers/net/wireless/p54/Kconfig
index b0342a5..024fccc 100644
--- a/drivers/net/wireless/p54/Kconfig
+++ b/drivers/net/wireless/p54/Kconfig
@@ -8,7 +8,7 @@ config P54_COMMON
 	  also need to be enabled in order to support any devices.
 
 	  These devices require softmac firmware which can be found at
-	  http://prism54.org/
+	  http://wireless.kernel.org/en/users/Drivers/p54 
 
 	  If you choose to build a module, it'll be called p54common.
 
@@ -20,7 +20,7 @@ config P54_USB
 	  This driver is for USB isl38xx based wireless cards.
 
 	  These devices require softmac firmware which can be found at
-	  http://prism54.org/
+	  http://wireless.kernel.org/en/users/Drivers/p54 
 
 	  If you choose to build a module, it'll be called p54usb.
 
@@ -34,7 +34,7 @@ config P54_PCI
 	  supported by the fullmac driver/firmware.
 
 	  This driver requires softmac firmware which can be found at
-	  http://prism54.org/
+	  http://wireless.kernel.org/en/users/Drivers/p54
 
 	  If you choose to build a module, it'll be called p54pci.
 
-- 
1.7.2.1

