Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933913Ab1FWWfY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 18:35:24 -0400
Received: from mail.perches.com ([173.55.12.10]:3188 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753179Ab1FWWfV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 18:35:21 -0400
From: Joe Perches <joe@perches.com>
To: Ivo van Doorn <IvDoorn@gmail.com>,
        Gertjan van Wingerde <gwingerde@gmail.com>,
        Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] rt2x00: Fix unspeficied typo
Date: Thu, 23 Jun 2011 15:35:18 -0700
Message-Id: <6002eb70809bb1c87c84f32ab4a4f034d2d1ffb5.1308868289.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/rt2x00/rt2x00queue.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/rt2x00/rt2x00queue.h b/drivers/net/wireless/rt2x00/rt2x00queue.h
index 167d458..5900474 100644
--- a/drivers/net/wireless/rt2x00/rt2x00queue.h
+++ b/drivers/net/wireless/rt2x00/rt2x00queue.h
@@ -54,7 +54,7 @@
  * @QID_RX: RX queue
  * @QID_OTHER: None of the above (don't use, only present for completeness)
  * @QID_BEACON: Beacon queue (value unspecified, don't send it to device)
- * @QID_ATIM: Atim queue (value unspeficied, don't send it to device)
+ * @QID_ATIM: Atim queue (value unspecified, don't send it to device)
  */
 enum data_queue_qid {
 	QID_AC_VO = 0,
-- 
1.7.6.rc1

