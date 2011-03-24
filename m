Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934103Ab1CXUTU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:19:20 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51040 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934165Ab1CXUTP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:19:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=om7jmFJvn5muZo+ZRKqb3sv/dFGvdDOf0YoKdF5q+f5+SzPR0gq5Vu7FNe9mhhUEv6
         w58y/hJku+eBt1OF0SNBoBz9pGJBqqxexcoPCd6XxfHU9odDNbEr7xE3tmiI/2ExEi5w
         TmGzXEWf305MbGBmNXuKrUIZk2Wox1vPyzIns=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [RFC V2 13/21]drivers:i2c:busses:i2c-designware.c Remove extra semi-colon.
Date: Thu, 24 Mar 2011 13:18:32 -0700
Message-Id: <1300997920-31573-13-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
References: <1300997920-31573-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The patch below removes an extra semi-colon from various parts 
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

