Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab1DCWug (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Apr 2011 18:50:36 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:63574 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752896Ab1DCWue (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Apr 2011 18:50:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=j2j3ybUPlziFsWwAFAZfFb5mbSm6r1c6aGglMVhHyArPxoAenPtciAnoGLaxJXi9Qt
         A8aLDl7woSZ+4RqynGhb0vgbs63wKysTUuvwT/DSv3vA3T3cmL9CcKU1YlE26xt6rLHb
         cJ8aNzhDCRGKodGXtROMsAk2QyFfNElhmIst4=
From: Thiago Farina <tfransosi@gmail.com>
To: linux-next@vger.kernel.org
Cc: linux-media@vger.kernel.org (open list:MEDIA INPUT INFRA...),
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH 1/1] wl128x: Remove unused NO_OF_ENTRIES_IN_ARRAY macro.
Date: Sun,  3 Apr 2011 19:50:14 -0300
Message-Id: <1301871014-15614-1-git-send-email-tfransosi@gmail.com>
X-Mailer: git-send-email 1.7.3.2.343.g7d43d
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thiago Farina <tfransosi@gmail.com>
---
 drivers/media/radio/wl128x/fmdrv.h |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/media/radio/wl128x/fmdrv.h b/drivers/media/radio/wl128x/fmdrv.h
index 5db6fd1..1a45a5d 100644
--- a/drivers/media/radio/wl128x/fmdrv.h
+++ b/drivers/media/radio/wl128x/fmdrv.h
@@ -55,8 +55,6 @@
 #define FM_DRV_TX_TIMEOUT      (5*HZ)	/* 5 seconds */
 #define FM_DRV_RX_SEEK_TIMEOUT (20*HZ)	/* 20 seconds */
 
-#define NO_OF_ENTRIES_IN_ARRAY(array) (sizeof(array) / sizeof(array[0]))
-
 #define fmerr(format, ...) \
 	printk(KERN_ERR "fmdrv: " format, ## __VA_ARGS__)
 #define fmwarn(format, ...) \
-- 
1.7.3.2.343.g7d43d

