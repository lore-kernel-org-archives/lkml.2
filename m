Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756173Ab1BPGzY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 01:55:24 -0500
Received: from mail-yi0-f46.google.com ([209.85.218.46]:48087 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755633Ab1BPGzU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 01:55:20 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=UZdcmu+hxgs9I/8U7NCGnetO1LGfOEP/ToBamtMKYDmce317rFmiM6dNcLZJ6fH7+b
         52Idpe+15uh9vfAvbdgFz/tmPKk6GEInNInpCJFflDW5JolTzCcIqwqgko0WU5Whorah
         x8aIRJRSzxb92aWLnIho4HYpVTvPMj7Ld6fvI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: davem@davemloft.net, eric.dumazet@gmail.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/3]drivers:net:rrunner.c Fix typo occationally to occasionally
Date: Tue, 15 Feb 2011 22:55:02 -0800
Message-Id: <1297839302-3125-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.6.5.2.180.gc5b3e
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch fixes a typo occationally to occasionally.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/net/rrunner.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/rrunner.c b/drivers/net/rrunner.c
index e68c941..6dceeb5 100644
--- a/drivers/net/rrunner.c
+++ b/drivers/net/rrunner.c
@@ -1072,7 +1072,7 @@ static irqreturn_t rr_interrupt(int irq, void *dev_id)
 	txcon = rrpriv->dirty_tx;
 	if (txcsmr != txcon) {
 		do {
-			/* Due to occational firmware TX producer/consumer out
+			/* Due to occasional firmware TX producer/consumer out
 			 * of sync. error need to check entry in ring -kbf
 			 */
 			if(rrpriv->tx_skbuff[txcon]){
-- 
1.6.5.2.180.gc5b3e

