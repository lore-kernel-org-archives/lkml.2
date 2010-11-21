Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757103Ab0KUCkc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Nov 2010 21:40:32 -0500
Received: from mail.perches.com ([173.55.12.10]:1720 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757074Ab0KUCka (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Nov 2010 21:40:30 -0500
From: Joe Perches <joe@perches.com>
To: Christian Lamparter <chunkeey@web.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 50/62] ar9170: Use const
Date: Sat, 20 Nov 2010 18:38:51 -0800
Message-Id: <589b0a937f059a48a972d174c1cfd84b7578143a.1290305776.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.2.245.g03276.dirty
In-Reply-To: <cover.1290305773.git.joe@perches.com>
References: <cover.1290305773.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark an array const.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/net/wireless/ath/ar9170/cmd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/wireless/ath/ar9170/cmd.c b/drivers/net/wireless/ath/ar9170/cmd.c
index 4604de0..6452c50 100644
--- a/drivers/net/wireless/ath/ar9170/cmd.c
+++ b/drivers/net/wireless/ath/ar9170/cmd.c
@@ -54,7 +54,7 @@ int ar9170_write_mem(struct ar9170 *ar, const __le32 *data, size_t len)
 
 int ar9170_write_reg(struct ar9170 *ar, const u32 reg, const u32 val)
 {
-	__le32 buf[2] = {
+	const __le32 buf[2] = {
 		cpu_to_le32(reg),
 		cpu_to_le32(val),
 	};
-- 
1.7.3.2.245.g03276.dirty

