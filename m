Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754775Ab0GLUuw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 16:50:52 -0400
Received: from mail.perches.com ([173.55.12.10]:1761 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753519Ab0GLUuu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 16:50:50 -0400
From: Joe Perches <joe@perches.com>
To: Jiri Kosina <trivial@kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 16/36] drivers/sbus: Remove unnecessary casts of private_data
Date: Mon, 12 Jul 2010 13:50:08 -0700
Message-Id: <135e39325e4dd5c7fc4ac9481575ab03c6ce04f6.1278967121.git.joe@perches.com>
X-Mailer: git-send-email 1.7.1.337.g6068.dirty
In-Reply-To: <cover.1278967120.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/sbus/char/openprom.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/sbus/char/openprom.c b/drivers/sbus/char/openprom.c
index d53e62a..aacbe14 100644
--- a/drivers/sbus/char/openprom.c
+++ b/drivers/sbus/char/openprom.c
@@ -554,7 +554,7 @@ static int opiocgetnext(unsigned int cmd, void __user *argp)
 static int openprom_bsd_ioctl(struct file * file,
 			      unsigned int cmd, unsigned long arg)
 {
-	DATA *data = (DATA *) file->private_data;
+	DATA *data = file->private_data;
 	void __user *argp = (void __user *)arg;
 	int err;
 
@@ -601,7 +601,7 @@ static int openprom_bsd_ioctl(struct file * file,
 static long openprom_ioctl(struct file * file,
 			   unsigned int cmd, unsigned long arg)
 {
-	DATA *data = (DATA *) file->private_data;
+	DATA *data = file->private_data;
 
 	switch (cmd) {
 	case OPROMGETOPT:
-- 
1.7.1.337.g6068.dirty

