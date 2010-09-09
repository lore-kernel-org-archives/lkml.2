Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932605Ab0IIWcc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:32:32 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:58149 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab0IIWcY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:32:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=ZK80U+SywKaqzLm7gT2ExpDlcRWnxpoQtzihzENYLdd9GuoubzfrBu+mgR+rHbtPWk
         VsHg+VzZa9gyzsI6y6AJHZt/9NHVuXZyX37plZUhtnvM6KjzwYdkycblAhpHT8n4ApZl
         FkWOBM2Zu2Pt4lI6a4ZQ9g831yVNMHvNDR7cA=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 094/223]drivers/net/tulip/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:32:37 -0700
Message-Id: <1284071562-7948-4-git-send-email-justinmattock@gmail.com>
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
 drivers/net/tulip/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/tulip/Kconfig b/drivers/net/tulip/Kconfig
index 516713f..14c02e1 100644
--- a/drivers/net/tulip/Kconfig
+++ b/drivers/net/tulip/Kconfig
@@ -151,7 +151,7 @@ config ULI526X
 	select CRC32
 	---help---
 	  This driver is for ULi M5261/M5263 10/100M Ethernet Controller
-	  (<http://www.uli.com.tw/>).
+	  (<http://www.nvidia.com/page/uli_drivers.html>).
 
 	  To compile this driver as a module, choose M here. The module will
 	  be called uli526x.
-- 
1.7.2.1

