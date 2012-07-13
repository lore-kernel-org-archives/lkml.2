Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916Ab2GMUWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jul 2012 16:22:03 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:46305 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751093Ab2GMUWA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jul 2012 16:22:00 -0400
From: Devendra Naga <devendra.aaru@gmail.com>
To: Forest Bond <forest@alittletooquiet.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Devendra Naga <devendra.aaru@gmail.com>
Subject: [PATCH 2/3] staging/vt6656: remove unnecessary return in BSSvSecondTxData
Date: Sat, 14 Jul 2012 02:06:52 +0545
Message-Id: <1342210912-9119-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

this return is at the function end, and function is returning nothing..
i.e a void.

Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/vt6656/wcmd.c |    1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/staging/vt6656/wcmd.c b/drivers/staging/vt6656/wcmd.c
index cecfdb6..c9de937 100644
--- a/drivers/staging/vt6656/wcmd.c
+++ b/drivers/staging/vt6656/wcmd.c
@@ -1300,5 +1300,4 @@ void BSSvSecondTxData(void *hDeviceContext)
 
 	pDevice->sTimerTxData.expires = RUN_AT(10 * HZ);      //10s callback
 	add_timer(&pDevice->sTimerTxData);
-	return;
 }
-- 
1.7.9.5

