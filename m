Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671Ab2FROmh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:42:37 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50116 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751999Ab2FROmf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:42:35 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/2]staging "slicoss" Fix a typo. 
Date: Mon, 18 Jun 2012 07:42:24 -0700
Message-Id: <1340030544-21245-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1340030544-21245-1-git-send-email-justinmattock@gmail.com>
References: <1340030544-21245-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes a typo found while reading through "staging" "slicoss"

 drivers/staging/slicoss/slicoss.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/slicoss/slicoss.c b/drivers/staging/slicoss/slicoss.c
index 77a0751..d2b82a7 100644
--- a/drivers/staging/slicoss/slicoss.c
+++ b/drivers/staging/slicoss/slicoss.c
@@ -47,7 +47,7 @@
  *      Oasis cards (single and dual port PCI-x Gigabit) copper and fiber
  *      Kalahari cards (dual and quad port PCI-e Gigabit) copper and fiber
  *
- * The driver was acutally tested on Oasis and Kalahari cards.
+ * The driver was actually tested on Oasis and Kalahari cards.
  *
  *
  * NOTE: This is the standard, non-accelerated version of Alacritech's
-- 
1.7.5.4

