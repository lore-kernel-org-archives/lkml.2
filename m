Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757394Ab0IIW6v (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 18:58:51 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:59224 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932838Ab0IIWhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 18:37:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=dOQtQgyIJg3K4dLMnizXuhnlC+OfzqSP8FWqaXDAFzTbJAFVP0PHhKHgBto3A8bkvv
         ToRxo0etYM9nWuAylA6i6C8zYC/ATuPT628+g5u5nccJKoIzql5tE82HB4HXnrSGT0/3
         NkTslx8C1u5ZknBhg1M6HQqSfO7OyRN2zsFS8=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 127/223]drivers/scsi/scsi_debug.c Update broken web addresses.
Date: Thu,  9 Sep 2010 15:37:34 -0700
Message-Id: <1284071862-8194-7-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.2.1
In-Reply-To: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
References: <1284071862-8194-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Below you will find an Update to a broken web address.
Please let me know if this needs to be changed.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 drivers/scsi/scsi_debug.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index b02bdc6..705f541 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -555,8 +555,8 @@ static int inquiry_evpd_84(unsigned char * arr)
 static int inquiry_evpd_85(unsigned char * arr)
 {
 	int num = 0;
-	const char * na1 = "https://www.kernel.org/config";
-	const char * na2 = "http://www.kernel.org/log";
+	const char * na1 = "https://www.kernel.org";
+	const char * na2 = "http://www.kernel.org";
 	int plen, olen;
 
 	arr[num++] = 0x1;	/* lu, storage config */
-- 
1.7.2.1

