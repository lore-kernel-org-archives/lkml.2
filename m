Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932945Ab0KODJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 22:09:37 -0500
Received: from mail.perches.com ([173.55.12.10]:1204 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932802Ab0KODFp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 22:05:45 -0500
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 27/44] drivers/serial: Remove unnecessary semicolons
Date: Sun, 14 Nov 2010 19:04:46 -0800
Message-Id: <57c2393ee99b62bca43fa1c510cae832795069ba.1289789605.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289789604.git.joe@perches.com>
References: <cover.1289789604.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/serial/mrst_max3110.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/mrst_max3110.c b/drivers/serial/mrst_max3110.c
index b62857b..00d284c 100644
--- a/drivers/serial/mrst_max3110.c
+++ b/drivers/serial/mrst_max3110.c
@@ -56,7 +56,7 @@ struct uart_max3110 {
 	wait_queue_head_t wq;
 	struct task_struct *main_thread;
 	struct task_struct *read_thread;
-	struct mutex thread_mutex;;
+	struct mutex thread_mutex;
 
 	u32 baud;
 	u16 cur_conf;
-- 
1.7.3.1.g432b3.dirty

