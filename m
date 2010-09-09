Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932633Ab0IIWaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:30:14 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44570 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932613Ab0IIWaJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:30:09 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=KnVlIDQfFPx1petCnk+uHXcAo3SDkggdUCpowjQcveDZDcC63YG63MAnJetUYcehkB
         wRp/j8mxy09F7INWvgv/BpFmxGrFgnSbgmUUrjAQTJEyaHbI7JCw4ZWgDZPxnGB6o5Xz
         2LVyx4lCPsyL3wgcGsb9qeou9XtA9TPR5+Y7w=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 094/223]drivers/net/tulip/Kconfig Update broken web addresses.
Date: Thu,  9 Sep 2010 15:30:24 -0700
Message-Id: <1284071429-7902-4-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071429-7902-1-git-send-email-justinmattock@gmail.com>
References: <1284071429-7902-1-git-send-email-justinmattock@gmail.com>
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

