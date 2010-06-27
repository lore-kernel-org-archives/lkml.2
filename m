Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752437Ab0F0GNx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jun 2010 02:13:53 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:49718 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751727Ab0F0GNu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jun 2010 02:13:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=OYeRTYv7ND3Lxmmj5bp2hMRXJcPB0bW9+03nMO99YMJs/DTi0MlZbcfqAtO2QDFPYP
         UjBRyFekGl8MFFzCyuqc9uncApuKPLIY9pIUk5mdlOKwhpjG2VwVaXOL1X/YmGknIVJv
         GduDNcaP7Wq5Z18HQ2fg7jFUFIOlii5F99SeI=
From: Cody Rester <codyrester@gmail.com>
To: marcel@holtmann.org
Cc: linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org,
       Cody Rester <codyrester@gmail.com>
Subject: [PATCH] drivers: bluetooth: bluecard_cs.c: Fixed include error, changed to linux/io.h
Date: Sun, 27 Jun 2010 02:12:22 -0400
Message-Id: <1277619142-10751-1-git-send-email-codyrester@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed include error, changed to linux/io.h

Signed-off-by: Cody Rester <codyrester@gmail.com>
---
 drivers/bluetooth/bluecard_cs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/bluetooth/bluecard_cs.c b/drivers/bluetooth/bluecard_cs.c
index d9bf87c..89a4455 100644
--- a/drivers/bluetooth/bluecard_cs.c
+++ b/drivers/bluetooth/bluecard_cs.c
@@ -37,7 +37,7 @@
 #include <linux/wait.h>
 
 #include <linux/skbuff.h>
-#include <asm/io.h>
+#include <linux/io.h>
 
 #include <pcmcia/cs_types.h>
 #include <pcmcia/cs.h>
-- 
1.7.0.4

