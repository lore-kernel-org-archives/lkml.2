Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab0F2KQK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 06:16:10 -0400
Received: from fg-out-1718.google.com ([72.14.220.156]:3013 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755338Ab0F2KQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 06:16:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=vK2hEic/98FZCSonxNzlajsFYUvZM3PIk+Oyw3B0V0YYWx1yRpbRZmOulvWPDiGbhD
         AWJhOFL77/xYXwl77i1sBjeqfprRU40+NWG2otdxOGyEr6sbpAWcsgfguTzFQXpLLpvQ
         wiZZ3CWZSJkOwUk5hKLg/VbBdp0u7Hy8uTyuI=
From: Kulikov Vasiliy <segooon@gmail.com>
To: Kernel Janitors <kernel-janitors@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
       Alexander Beregalov <a.beregalov@gmail.com>,
       Mithlesh Thukral <mithlesh@linsyssoft.com>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 17/25] wrap_sec: remove casts from void*
Date: Tue, 29 Jun 2010 14:16:00 +0400
Message-Id: <1277806561-31282-1-git-send-email-segooon@gmail.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove unnesessary casts from void*.

Signed-off-by: Kulikov Vasiliy <segooon@gmail.com>
---
 drivers/staging/otus/wrap_sec.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/otus/wrap_sec.c b/drivers/staging/otus/wrap_sec.c
index 0b238e9..1fba7a9 100644
--- a/drivers/staging/otus/wrap_sec.c
+++ b/drivers/staging/otus/wrap_sec.c
@@ -36,7 +36,7 @@ extern int zfLnxCencSendMsg(struct sock *netlink_sk, u_int8_t *msg, int len);
 u16_t zfLnxCencAsocNotify(zdev_t *dev, u16_t *macAddr, u8_t *body,
 				u16_t bodySize, u16_t port)
 {
-	struct usbdrv_private *macp = (struct usbdrv_private *)dev->priv;
+	struct usbdrv_private *macp = dev->priv;
 	struct zydas_cenc_sta_info cenc_info;
 	/* struct sock *netlink_sk;	*/
 	u8_t ie_len;
-- 
1.7.0.4

