Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab1BEOVf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Feb 2011 09:21:35 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:52225 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752621Ab1BEOVd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Feb 2011 09:21:33 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=IsGLwBE5zOoSVptRYL4vQH7XNccuq/2CcfT0z1Lk90dZiB17P8ozeVv5XR1dXYofQQ
         yg2Niv6D+Gn2h71etCAI8uZBJK4117/u6+KQYKFtuOThZccaUUkBmKUCFUaWfkbw6i96
         vEnY1XU7A+PZwKWYjmfOed1Es+X9iM6Xy3cC0=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, adobriyan@gmail.com
Subject: [PATCH 11/52] kstrtox: convert drivers/ata/
Date: Sat,  5 Feb 2011 16:20:14 +0200
Message-Id: <1296915654-7458-11-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
References: <1296915654-7458-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 600f635..f0b6f48 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -204,7 +204,7 @@ static ssize_t ata_scsi_park_store(struct device *device,
 	unsigned long flags;
 	int rc;
 
-	rc = strict_strtol(buf, 10, &input);
+	rc = kstrtol(buf, 10, &input);
 	if (rc || input < -2)
 		return -EINVAL;
 	if (input > ATA_TMOUT_MAX_PARK) {
-- 
1.7.3.4

