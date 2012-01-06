Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030322Ab2AFLDi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 06:03:38 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53701 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030241Ab2AFLDh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 06:03:37 -0500
From: Che-Liang Chiou <clchiou@chromium.org>
To: dmitry.torokhov@gmail.com
Cc: linux-kernel@vger.kernel.org, Che-Liang Chiou <clchiou@chromium.org>
Subject: [PATCH 1/2] Input: serio_raw - cosmetic fixes
Date: Fri,  6 Jan 2012 19:03:14 +0800
Message-Id: <1325847795-30486-1-git-send-email-clchiou@chromium.org>
X-Mailer: git-send-email 1.7.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Che-Liang Chiou <clchiou@chromium.org>
---
 drivers/input/serio/serio_raw.c |    4 +---
 1 files changed, 1 insertions(+), 3 deletions(-)

diff --git a/drivers/input/serio/serio_raw.c b/drivers/input/serio/serio_raw.c
index 4d4cd14..a935c38 100644
--- a/drivers/input/serio/serio_raw.c
+++ b/drivers/input/serio/serio_raw.c
@@ -220,7 +220,7 @@ static ssize_t serio_raw_write(struct file *file, const char __user *buffer,
 			goto out;
 		}
 		written++;
-	};
+	}
 
 out:
 	mutex_unlock(&serio_raw_mutex);
@@ -231,11 +231,9 @@ static unsigned int serio_raw_poll(struct file *file, poll_table *wait)
 {
 	struct serio_raw_client *client = file->private_data;
 	struct serio_raw *serio_raw = client->serio_raw;
-	unsigned int mask;
 
 	poll_wait(file, &serio_raw->wait, wait);
 
-	mask = serio_raw->dead ? POLLHUP | POLLERR : POLLOUT | POLLWRNORM;
 	if (serio_raw->head != serio_raw->tail)
 		return POLLIN | POLLRDNORM;
 
-- 
1.7.3.1

