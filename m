Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758369Ab2ESSxi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:53:38 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49408 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757375Ab2ESSxg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:53:36 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        John Stultz <john.stultz@linaro.org>,
        Andy Green <andy.green@linaro.org>,
        =?UTF-8?q?Arve=20Hj=C3=B8nnev=C3=A5g?= <arve@android.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH] android/alarm: remove unnecessary goto statement
Date: Sun, 20 May 2012 00:23:26 +0530
Message-Id: <1337453606-6127-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/android/alarm-dev.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/android/alarm-dev.c b/drivers/staging/android/alarm-dev.c
index 03efb34..1573672 100644
--- a/drivers/staging/android/alarm-dev.c
+++ b/drivers/staging/android/alarm-dev.c
@@ -196,7 +196,6 @@ from_old_alarm_set:
 
 	default:
 		rv = -EINVAL;
-		goto err1;
 	}
 err1:
 	return rv;
-- 
1.7.9.5

