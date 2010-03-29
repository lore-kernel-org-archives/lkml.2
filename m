Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753869Ab0C2Ues (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 16:34:48 -0400
Received: from mail-ew0-f220.google.com ([209.85.219.220]:60451 "EHLO
	mail-ew0-f220.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751531Ab0C2Ueq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 16:34:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=exQMcX1Y7Diq3+fa+uSOW5smXCHtgq5f1wmMdJyQzubQTaC1MtRwBX0Z0fTEeyCeXi
         YDaowEcdZDsEMa3ngOOcBrntKdnObhYHAll29KmyrKmpjDcxgSvg04yPH1Fc8nM35rJx
         1GEGRZDeDZ1NotKnufReWTmVwyTUO8ZIMR3HY=
From: Luis de Bethencourt <luisbg@ubuntu.com>
To: linville@tuxdriver.com, lrodriguez@atheros.com
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org,
       Luis de Bethencourt <luisbg@openshine.com>,
       Luis de Bethencourt <luisbg@ubuntu.com>
Subject: [PATCH] Net: wireless: ath: fix macros coding style issue in hw.c
Date: Mon, 29 Mar 2010 21:34:39 +0100
Message-Id: <1269894879-13884-1-git-send-email-luisbg@ubuntu.com>
X-Mailer: git-send-email 1.6.3.3
In-Reply-To: <ath/hw.c>
References: <ath/hw.c>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Luis de Bethencourt <luisbg@openshine.com>

This is a patch to the ath/hw.c file that fixes up a warning about
macros found by the checkpatch.pl tool, that said that complex values
should be enclosed in parenthesis.

Signed-off-by: Luis de Bethencourt <luisbg@ubuntu.com>
---
 drivers/net/wireless/ath/hw.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/wireless/ath/hw.c b/drivers/net/wireless/ath/hw.c
index ecc9eb0..a8f81ea 100644
--- a/drivers/net/wireless/ath/hw.c
+++ b/drivers/net/wireless/ath/hw.c
@@ -19,8 +19,8 @@
 #include "ath.h"
 #include "reg.h"
 
-#define REG_READ	common->ops->read
-#define REG_WRITE	common->ops->write
+#define REG_READ	(common->ops->read)
+#define REG_WRITE	(common->ops->write)
 
 /**
  * ath_hw_set_bssid_mask - filter out bssids we listen
-- 
1.6.3.3

