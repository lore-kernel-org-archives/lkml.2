Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab1ENK7F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 May 2011 06:59:05 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:47396 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab1ENK4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 May 2011 06:56:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=OLm95DMnXMjUKv8SO9z17dPv0txYNsJfkv84XzRVIfczBGREsOZiFf+ryEopzLV+Cv
         L6oOB8nX4021X7UfkPaS7jLgzmnKs5d2DYOU7WGQlwfQK79RAR/ec4P4vgAJy99XAHL6
         Xvk22/l3JJASEdtbniwZY2NbmMm7v8UiRGrL4=
From: matt mooney <mfmooney@gmail.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 04/14] staging: usbip: userspace: remove unused files
Date: Sat, 14 May 2011 03:55:10 -0700
Message-Id: <1a4a6ff818506f34406def68f23e865968d09c54.1305369176.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305369175.git.mfm@muteddisk.com>
References: <cover.1305369175.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: matt mooney <mfm@muteddisk.com>

Remove ChangeLog and NEWS.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/NEWS      |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)
 delete mode 100644 drivers/staging/usbip/userspace/ChangeLog
 delete mode 100644 drivers/staging/usbip/userspace/NEWS

diff --git a/drivers/staging/usbip/userspace/ChangeLog b/drivers/staging/usbip/userspace/ChangeLog
deleted file mode 100644
index e69de29..0000000
diff --git a/drivers/staging/usbip/userspace/NEWS b/drivers/staging/usbip/userspace/NEWS
deleted file mode 100644
index 428b406..0000000
--- a/drivers/staging/usbip/userspace/NEWS
+++ /dev/null
@@ -1 +0,0 @@
-link ../NEWS
\ No newline at end of file
-- 
1.7.5.1

