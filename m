Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933831Ab0FEXdc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Jun 2010 19:33:32 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:61269 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933815Ab0FEXd3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Jun 2010 19:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=fCru18KrIVJQAEYWIgJRI6UTIEP2E3Wx+oKhsQiA/Dz6Q5D+QbpUntDrIH6WD0spS6
         rrRovpvmbL4yA5o3skWiRLG7rmAz0CiI9+BADR6VYOtuvPOW9Uni2xiiJjSW6V2W4Mk2
         5s9iiX1hzqxHTd3xJfuYqrY+Bzg+rbdWOH5dE=
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
To: Arnaud Patard <apatard@mandriva.com>
Cc: linux-kernel@vger.kernel.org,
       Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
Subject: [PATCH 4/6] Kill unused header
Date: Sun,  6 Jun 2010 01:33:14 +0200
Message-Id: <1275780796-17751-5-git-send-email-riccardo.magliocchetti@gmail.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
References: <1275780796-17751-1-git-send-email-riccardo.magliocchetti@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
---
 drivers/staging/xgifb/XGI.h |   10 ----------
 1 files changed, 0 insertions(+), 10 deletions(-)
 delete mode 100644 drivers/staging/xgifb/XGI.h

diff --git a/drivers/staging/xgifb/XGI.h b/drivers/staging/xgifb/XGI.h
deleted file mode 100644
index 87803dd..0000000
--- a/drivers/staging/xgifb/XGI.h
+++ /dev/null
@@ -1,10 +0,0 @@
-#ifndef _XGI_H
-#define _XGI_H
-
-#if 1
-#define TWDEBUG(x)
-#else
-#define TWDEBUG(x) printk(KERN_INFO x "\n");
-#endif
-
-#endif
-- 
1.7.1

