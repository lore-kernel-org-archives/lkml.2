Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754980Ab0FADYy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 23:24:54 -0400
Received: from mail.perches.com ([173.55.12.10]:2491 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754796Ab0FADXd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 23:23:33 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 16/21] drivers/serial/icom.c: Remove unnecessary kmalloc casts
Date: Mon, 31 May 2010 20:23:18 -0700
Message-Id: <e4b9c0e0a4fa696972338a9975905e223d1f9ca6.1275360951.git.joe@perches.com>
X-Mailer: git-send-email 1.7.0.3.311.g6a6955
In-Reply-To: <cover.1275360951.git.joe@perches.com>
References: <cover.1275360951.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/icom.c |    3 +--
 1 files changed, 1 insertions(+), 2 deletions(-)

diff --git a/drivers/serial/icom.c b/drivers/serial/icom.c
index 53a4682..105e25c 100644
--- a/drivers/serial/icom.c
+++ b/drivers/serial/icom.c
@@ -1416,8 +1416,7 @@ static int __devinit icom_alloc_adapter(struct icom_adapter
 	struct icom_adapter *cur_adapter_entry;
 	struct list_head *tmp;
 
-	icom_adapter = (struct icom_adapter *)
-	    kzalloc(sizeof(struct icom_adapter), GFP_KERNEL);
+	icom_adapter = kzalloc(sizeof(struct icom_adapter), GFP_KERNEL);
 
 	if (!icom_adapter) {
 		return -ENOMEM;
-- 
1.7.0.3.311.g6a6955

