Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2AWR1X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jan 2012 12:27:23 -0500
Received: from i118-21-156-233.s30.a048.ap.plala.or.jp ([118.21.156.233]:41025
	"EHLO rinabert.homeip.net" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753406Ab2AWR1U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jan 2012 12:27:20 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: linuxppc-dev@lists.ozlabs.org, benh@kernel.crashing.org
Cc: standby24x7@gmail.com, trivial@kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/2] [trivial] macintosh: Fix typo in mediabay.c
Date: Tue, 24 Jan 2012 02:26:36 +0900
Message-Id: <1327339596-3503-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.6.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix typo "unsuported" to "unsupported" in
drivers/machintosh/mediabay.c

Signed-off-by: Masanari Iida<standby24x7@gmail.com>
---
 drivers/macintosh/mediabay.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/macintosh/mediabay.c b/drivers/macintosh/mediabay.c
index 2fd435b..831d751 100644
--- a/drivers/macintosh/mediabay.c
+++ b/drivers/macintosh/mediabay.c
@@ -356,7 +356,7 @@ static void poll_media_bay(struct media_bay_info* bay)
 	static char *mb_content_types[] = {
 		"a floppy drive",
 		"a floppy drive",
-		"an unsuported audio device",
+		"an unsupported audio device",
 		"an ATA device",
 		"an unsupported PCI device",
 		"an unknown device",
-- 
1.7.6.5

