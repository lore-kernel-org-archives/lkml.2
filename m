Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754670Ab0LFWJN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 17:09:13 -0500
Received: from mail.perches.com ([173.55.12.10]:2338 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754254Ab0LFWFW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 17:05:22 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/29] drivers/firmware: Update WARN uses
Date: Mon,  6 Dec 2010 14:05:00 -0800
Message-Id: <93793849cdd6f702da0c16cdd047c8a66652b253.1291670105.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.3.398.g0b0cd.dirty
In-Reply-To: <cover.1291670104.git.joe@perches.com>
References: <cover.1291670104.git.joe@perches.com>
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
1.7.3.2.245.g03276.dirty

