Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753895Ab1LIBYP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 20:24:15 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:36462 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752893Ab1LIBYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 20:24:14 -0500
From: Devendra Naga <devendra.aaru@gmail.com>
To: gregkh@suse.de, edwin_rong@realsil.com.cn, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Dev <devendra.aaru@gmail.com>
Subject: [PATCH 1/1] remove version.h includes in drivers/staging/rts5139 as reported by "make versioncheck"
Date: Thu,  8 Dec 2011 20:23:39 -0500
Message-Id: <1323393819-2149-1-git-send-email-devendra.aaru@gmail.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dev <devendra.aaru@gmail.com>


Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
---
 drivers/staging/rts5139/rts51x.h           |    1 -
 drivers/staging/rts5139/rts51x_transport.h |    1 -
 2 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x.h b/drivers/staging/rts5139/rts51x.h
index 9415d5c..b2c5839 100644
--- a/drivers/staging/rts5139/rts51x.h
+++ b/drivers/staging/rts5139/rts51x.h
@@ -34,7 +34,6 @@
 #include <linux/mutex.h>
 #include <linux/cdrom.h>
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>
diff --git a/drivers/staging/rts5139/rts51x_transport.h b/drivers/staging/rts5139/rts51x_transport.h
index f7aa87f..8464c48 100644
--- a/drivers/staging/rts5139/rts51x_transport.h
+++ b/drivers/staging/rts5139/rts51x_transport.h
@@ -28,7 +28,6 @@
 #define __RTS51X_TRANSPORT_H
 
 #include <linux/kernel.h>
-#include <linux/version.h>
 
 #include "rts51x.h"
 #include "rts51x_chip.h"
-- 
1.7.4.1

