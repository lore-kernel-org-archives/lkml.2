Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934086Ab1CXT37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 15:29:59 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:62751 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933858Ab1CXT1v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 15:27:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=V3GOT662GgInekXjaqc2NZLELcI7YrdzTfFK0P9+dyGXkAs3cLJFpu5q5Lx8r5vLsr
         p5FVKjw8mIC0htdeNhGPJxA7Hh/b0q3Rb2lydXxgEKYERBQhK+LyZyuAtgSlPGH9J1GS
         TEvsPn/ehMQxXz6Mx7CcC02YrT4Ks1w0U/t1I=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC 13/21]drivers:i2c:busses:i2c-designware.c Remove extra comma.
Date: Thu, 24 Mar 2011 12:26:51 -0700
Message-Id: <1300994819-30930-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
References: <1300994819-30930-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra comma from various parts 
of the kernel. Please have a look when you have time, and let
me know if its legit or not.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/i2c/busses/i2c-designware.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware.c b/drivers/i2c/busses/i2c-designware.c
index b664ed8..a93922d 100644
--- a/drivers/i2c/busses/i2c-designware.c
+++ b/drivers/i2c/busses/i2c-designware.c
@@ -390,7 +390,7 @@ i2c_dw_xfer_msg(struct dw_i2c_dev *dev)
 	int tx_limit, rx_limit;
 	u32 addr = msgs[dev->msg_write_idx].addr;
 	u32 buf_len = dev->tx_buf_len;
-	u8 *buf = dev->tx_buf;;
+	u8 *buf = dev->tx_buf;
 
 	intr_mask = DW_IC_INTR_DEFAULT_MASK;
 
-- 
1.7.4.1

