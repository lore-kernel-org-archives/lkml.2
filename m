Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab2AUCR5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 21:17:57 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:56097 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751196Ab2AUCR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 21:17:56 -0500
From: Kashyap Gada <gada.kashyap@gmail.com>
To: gregkh@suse.de
Cc: john.stultz@linaro.org, arve@android.com, ccross@android.com,
        bringert@android.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, Kashyap Gada <gada.kashyap@gmail.com>
Subject: [PATCH 4/4] Staging: android: Fix struct definitioni warning from static to const
Date: Sat, 21 Jan 2012 02:17:49 +0000
Message-Id: <1327112269-17530-1-git-send-email-gada.kashyap@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Signed-off-by: Kashyap Gada <gada.kashyap@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

---
 drivers/staging/android/ashmem.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/android/ashmem.c b/drivers/staging/android/ashmem.c
index 4a00174a5..9f1f27e 100644
--- a/drivers/staging/android/ashmem.c
+++ b/drivers/staging/android/ashmem.c
@@ -680,7 +680,7 @@ static long ashmem_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
 	return ret;
 }
 
-const struct file_operations ashmem_fops = {
+static const struct file_operations ashmem_fops = {
 	.owner = THIS_MODULE,
 	.open = ashmem_open,
 	.release = ashmem_release,
-- 
1.7.5.4

