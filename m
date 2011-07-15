Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965274Ab1GOGWK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 02:22:10 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:60383 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965121Ab1GOGWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 02:22:06 -0400
Subject: [PATCH 16/16] SCSI: remove Scsi_Cmnd
From: Davidlohr Bueso <dave.bueso@gmail.com>
Reply-To: dave@gnu.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Cc: lkml <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Fri, 15 Jul 2011 02:20:43 -0400
Message-ID: <1310710843.3184.67.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Davidlohr Bueso <dave@gnu.org>

Now that no driver is using this typedef, we can finally get rid of this ugly file.

Signed-off-by: Davidlohr Bueso <dave@gnu.org>
---
 drivers/scsi/scsi.h          |    3 ---
 drivers/scsi/scsi_typedefs.h |    2 --
 2 files changed, 0 insertions(+), 5 deletions(-)
 delete mode 100644 drivers/scsi/scsi_typedefs.h

diff --git a/drivers/scsi/scsi.h b/drivers/scsi/scsi.h
index d5a55fa..db67d4c 100644
--- a/drivers/scsi/scsi.h
+++ b/drivers/scsi/scsi.h
@@ -42,7 +42,4 @@ struct scsi_device;
 struct scsi_target;
 struct scatterlist;
 
-/* obsolete typedef junk. */
-#include "scsi_typedefs.h"
-
 #endif /* _SCSI_H */
diff --git a/drivers/scsi/scsi_typedefs.h b/drivers/scsi/scsi_typedefs.h
deleted file mode 100644
index 2ed4c5c..0000000
--- a/drivers/scsi/scsi_typedefs.h
+++ /dev/null
@@ -1,2 +0,0 @@
-
-typedef struct scsi_cmnd Scsi_Cmnd;
-- 
1.7.4.1





