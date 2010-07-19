Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751736Ab0GSEv3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 00:51:29 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:37098 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab0GSEv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 00:51:28 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer;
        b=xrJrhIpRCMUuLjbeZCbPrJaT5fyya4BRXg5bven4zr4nIq/TON3N4mdUYWhLCAk1Va
         wTpnkQ7S1kjl84NOP8vn/hokAdeY7vy6eTtgkQTQ3uFAcTOu3DpG4iKU0P1RQT+onVLd
         zOINEimuq86uMNBN4lBoJDDgoBkwiB2NyXVUo=
From: "Gustavo F. Padovan" <gustavo@padovan.org>
To: drbd-dev@lists.linbit.com
Cc: philipp.reisner@linbit.com, jens.axboe@oracle.com,
        linux-kernel@vger.kernel.org,
        "Gustavo F. Padovan" <padovan@profusion.mobi>
Subject: [PATCH] drbd: Remove __packed define
Date: Mon, 19 Jul 2010 01:50:16 -0300
Message-Id: <1279515016-25907-1-git-send-email-gustavo@padovan.org>
X-Mailer: git-send-email 1.7.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Gustavo F. Padovan <padovan@profusion.mobi>

__packed is already defined on <compiler.h>

Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
---
 drivers/block/drbd/drbd_int.h |    4 ----
 1 files changed, 0 insertions(+), 4 deletions(-)

diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index e9654c8..548b3fa 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -323,10 +323,6 @@ static inline void bm_xfer_ctx_bit_to_word_offset(struct bm_xfer_ctx *c)
 #endif
 }
 
-#ifndef __packed
-#define __packed __attribute__((packed))
-#endif
-
 /* This is the layout for a packet on the wire.
  * The byteorder is the network byte order.
  *     (except block_id and barrier fields.
-- 
1.7.1.1

