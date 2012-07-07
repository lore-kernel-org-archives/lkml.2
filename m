Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752157Ab2GGMGe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 08:06:34 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:36870 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751709Ab2GGMGD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 08:06:03 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>,
        Marek Belisko <marek.belisko@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 8/8] staging/ft1000: remove unnecessary assignment of ret with STATUS_SUCCESS
Date: Sat,  7 Jul 2012 17:35:19 +0530
Message-Id: <1341662719-25752-8-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
References: <1341662719-25752-1-git-send-email-devendra.aaru@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

as ret is assigned to the return of ft1000_poll, we dont need to
initialise ret with STATUS_SUCCESS.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/ft1000/ft1000-usb/ft1000_usb.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
index e434d33..7bd7fb2 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_usb.c
@@ -39,7 +39,7 @@ MODULE_DEVICE_TABLE(usb, id_table);
 static bool gPollingfailed = FALSE;
 static int ft1000_poll_thread(void *arg)
 {
-	int ret = STATUS_SUCCESS;
+	int ret;
 
 	while (!kthread_should_stop()) {
 		msleep(10);
-- 
1.7.9.5

