Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755382Ab0IMTsi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 15:48:38 -0400
Received: from mail.perches.com ([173.55.12.10]:1900 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755359Ab0IMTsg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 15:48:36 -0400
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: [PATCH 16/25] drivers/s390/char: Use static const char arrays
Date: Mon, 13 Sep 2010 12:47:54 -0700
Message-Id: <5867e44ccd0f86902b2230f1e25a9bdaf16ec1e6.1284406639.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.rc1
In-Reply-To: <cover.1284406638.git.joe@perches.com>
References: <cover.1284406638.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/s390/char/vmlogrdr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/s390/char/vmlogrdr.c b/drivers/s390/char/vmlogrdr.c
index e40a1b8..afd863c 100644
--- a/drivers/s390/char/vmlogrdr.c
+++ b/drivers/s390/char/vmlogrdr.c
@@ -214,7 +214,7 @@ static void vmlogrdr_iucv_message_pending(struct iucv_path *path,
 
 static int vmlogrdr_get_recording_class_AB(void)
 {
-	char cp_command[]="QUERY COMMAND RECORDING ";
+	static const char cp_command[] = "QUERY COMMAND RECORDING ";
 	char cp_response[80];
 	char *tail;
 	int len,i;
@@ -637,7 +637,7 @@ static ssize_t vmlogrdr_recording_status_show(struct device_driver *driver,
 					      char *buf)
 {
 
-	char cp_command[] = "QUERY RECORDING ";
+	static const char cp_command[] = "QUERY RECORDING ";
 	int len;
 
 	cpcmd(cp_command, buf, 4096, NULL);
-- 
1.7.3.rc1

