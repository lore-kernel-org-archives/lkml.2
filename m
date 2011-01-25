Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753017Ab1AYLIF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:08:05 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:50775 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab1AYLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=DIWkwFVBg229Ab3hAnRTSrC/evQw22sOgUkU3atnVmamh/y9kap6fv40gAz2Y7gcOz
         kcRw+dwPfaS/zWakKZbDnvBo/AGrtwjPH8cak4GxboY7Oa+DSCn1WS/Z5P6r4qV3zfUn
         gaSURhhRsKbXMMhK9QeqWidUEiSkxs4kUOWB4=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 10/12] staging: ft1000: Fix coding style.
Date: Tue, 25 Jan 2011 12:08:15 +0100
Message-Id: <1295953697-9805-10-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style for put_request_value() function.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   14 +++++---------
 1 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index a5dca6c..3c02144 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -445,16 +445,12 @@ static long get_request_value(struct ft1000_device *ft1000dev)
 //---------------------------------------------------------------------------
 static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 {
-   u32    tempx;
-   u32    status;
-
-       tempx = ntohl(lvalue);
-       status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC, (u8 *)&tempx);
-
-
-
-   //DEBUG("put_request_value: value is %x\n", lvalue);
+	u32    tempx;
+	u32    status;
 
+	tempx = ntohl(lvalue);
+	status = fix_ft1000_write_dpram32(ft1000dev, DWNLD_MAG1_SIZE_LOC,
+					  (u8 *)&tempx);
 }
 
 
-- 
1.7.1

