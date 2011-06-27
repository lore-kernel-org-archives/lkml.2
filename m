Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756595Ab1F0FDj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 01:03:39 -0400
Received: from mail.perches.com ([173.55.12.10]:3228 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756316Ab1F0FCH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 01:02:07 -0400
From: Joe Perches <joe@perches.com>
To: netdev@vger.kernel.org, Kevin Curtis <kevin.curtis@farsite.co.uk>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 6/8] farsync: Update to current logging forms
Date: Sun, 26 Jun 2011 22:01:33 -0700
Message-Id: <a3271494190678572096d0fe3141f98967ea277f.1309150684.git.joe@perches.com>
X-Mailer: git-send-email 1.7.6.rc1
In-Reply-To: <cover.1309150683.git.joe@perches.com>
References: <cover.1309150683.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use pr_fmt, pr_<level> and netdev_<level> as appropriate.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wan/farsync.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wan/farsync.c b/drivers/net/wan/farsync.c
index 0f27f4c..ebb9f24 100644
--- a/drivers/net/wan/farsync.c
+++ b/drivers/net/wan/farsync.c
@@ -1665,10 +1665,9 @@ check_started_ok(struct fst_card_info *card)
 	 * existing firmware etc so we just report it for the moment.
 	 */
 	if (FST_RDL(card, numberOfPorts) != card->nports) {
-		pr_warning("Port count mismatch on card %d. "
-			   "Firmware thinks %d we say %d\n",
-			   card->card_no,
-			   FST_RDL(card, numberOfPorts), card->nports);
+		pr_warn("Port count mismatch on card %d.  Firmware thinks %d we say %d\n",
+			card->card_no,
+			FST_RDL(card, numberOfPorts), card->nports);
 	}
 }
 
-- 
1.7.6.rc1

