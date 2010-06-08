Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753528Ab0FHDux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jun 2010 23:50:53 -0400
Received: from mail.perches.com ([173.55.12.10]:2764 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753342Ab0FHDuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jun 2010 23:50:50 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 10/12] drivers/serial/icom.c: Remove unnecessary kmalloc casts
Date: Mon,  7 Jun 2010 20:50:42 -0700
Message-Id: <cd5ee62fdb86fb84729d0bbb9c96310f298d489b.1275968594.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.244.gbdc4
In-Reply-To: <cover.1275968594.git.joe@perches.com>
References: <cover.1275968594.git.joe@perches.com>
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
1.7.1.244.gbdc4

