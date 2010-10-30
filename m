Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0J3VPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Oct 2010 17:15:37 -0400
Received: from mail.perches.com ([173.55.12.10]:3731 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752007Ab0J3VJa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Oct 2010 17:09:30 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 11/39] drivers/firmware: Update WARN uses
Date: Sat, 30 Oct 2010 14:08:28 -0700
Message-Id: <aaba94cf001a6160d5600a80c9b110a6ad510b57.1288471898.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1288471897.git.joe@perches.com>
References: <cover.1288471897.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Remove KERN_<level>.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/firmware/dmi_scan.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/firmware/dmi_scan.c b/drivers/firmware/dmi_scan.c
index e28e41668..5f427d4 100644
--- a/drivers/firmware/dmi_scan.c
+++ b/drivers/firmware/dmi_scan.c
@@ -475,7 +475,7 @@ static bool dmi_matches(const struct dmi_system_id *dmi)
 {
 	int i;
 
-	WARN(!dmi_initialized, KERN_ERR "dmi check: not initialized yet.\n");
+	WARN(!dmi_initialized, "dmi check: not initialized yet\n");
 
 	for (i = 0; i < ARRAY_SIZE(dmi->matches); i++) {
 		int s = dmi->matches[i].slot;
-- 
1.7.3.1.g432b3.dirty

