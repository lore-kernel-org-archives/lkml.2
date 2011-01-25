Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753183Ab1AYLIf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 06:08:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:40874 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831Ab1AYLID (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 06:08:03 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Rfkm/C9ayuknrpR9Eu8YoenOgh/+953q7tSJIRTaFpI2bp9F9/iP5F0J45x9AnPtwF
         ritRgqqFBE3F8pqDG5zJmVmGC2FGyrLENE3AWdUDdEgM5UovRGEdh1PvR0GETTqdUyhY
         lSCcX2j8wUHzUgiWE+5DRE9/kD54njErBT5cM=
From: Marek Belisko <marek.belisko@open-nandra.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Marek Belisko <marek.belisko@open-nandra.com>
Subject: [PATCH 11/12] staging: ft1000: Fix coding style.
Date: Tue, 25 Jan 2011 12:08:16 +0100
Message-Id: <1295953697-9805-11-git-send-email-marek.belisko@open-nandra.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
References: <1295953697-9805-1-git-send-email-marek.belisko@open-nandra.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix coding style for hdr_checksum() checksum.

Signed-off-by: Marek Belisko <marek.belisko@open-nandra.com>
---
 .../staging/ft1000/ft1000-usb/ft1000_download.c    |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
index 3c02144..596c923 100644
--- a/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
+++ b/drivers/staging/ft1000/ft1000-usb/ft1000_download.c
@@ -469,14 +469,14 @@ static void put_request_value(struct ft1000_device *ft1000dev, long lvalue)
 //---------------------------------------------------------------------------
 static u16 hdr_checksum(struct pseudo_hdr *pHdr)
 {
-   u16   *usPtr = (u16 *)pHdr;
-   u16   chksum;
+	u16   *usPtr = (u16 *)pHdr;
+	u16   chksum;
 
 
-  chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
-                    usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
+	chksum = ((((((usPtr[0] ^ usPtr[1]) ^ usPtr[2]) ^ usPtr[3]) ^
+	usPtr[4]) ^ usPtr[5]) ^ usPtr[6]);
 
-  return chksum;
+	return chksum;
 }
 
 
-- 
1.7.1

