Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756782Ab0LERul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Dec 2010 12:50:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:55965 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab0LERuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Dec 2010 12:50:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=TEoaVyldng5LkxLVZNLzt2rXk5zBq4J+Ii1VRHzjmIsE+4h6wb47MU+F4m4OW2bWP7
         4wvwGZ/+AxnKv3lEBYRMqBKKUgFL3zMkTIlFerrpYNdJ3jHhmZanbST3++6fxIoZX8RG
         EpqIbpU3dQsWHGVzRRtm7f/9ZzmTzJB9Hi2j0=
From: Alexey Dobriyan <adobriyan@gmail.com>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Alexey Dobriyan <adobriyan@gmail.com>
Subject: [PATCH 13/45] kstrtox: convert drivers/ata/
Date: Sun,  5 Dec 2010 19:49:10 +0200
Message-Id: <1291571382-2719-13-git-send-email-adobriyan@gmail.com>
X-Mailer: git-send-email 1.7.2.2
In-Reply-To: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
References: <1291571382-2719-1-git-send-email-adobriyan@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/ata/libata-scsi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index 66aa4be..83d3cc0 100644
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
1.7.2.2

