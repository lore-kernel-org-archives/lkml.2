Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754082Ab2CDAei (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Mar 2012 19:34:38 -0500
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:37013 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753619Ab2CDAeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Mar 2012 19:34:37 -0500
Message-ID: <1330821275.15243.6.camel@dabdike.int.hansenpartnership.com>
Subject: [GIT PULL] SCSI fixes for 3.3-rc5
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Sat, 03 Mar 2012 18:34:35 -0600
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's just a single fix in here: the osd max device number fix.

The patch is available here:

git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi-rc-fixes-2.6.git scsi-fixes

The short changelog is

Boaz Harrosh (1):
      osd_uld: Bump MAX_OSD_DEVICES from 64 to 1,048,576

The diffstat is:

 drivers/scsi/osd/osd_uld.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

And the complete diff is below.

James

---

diff --git a/drivers/scsi/osd/osd_uld.c b/drivers/scsi/osd/osd_uld.c
index b31a8e3..d4ed9eb 100644
--- a/drivers/scsi/osd/osd_uld.c
+++ b/drivers/scsi/osd/osd_uld.c
@@ -69,10 +69,10 @@
 #ifndef SCSI_OSD_MAJOR
 #  define SCSI_OSD_MAJOR 260
 #endif
-#define SCSI_OSD_MAX_MINOR 64
+#define SCSI_OSD_MAX_MINOR MINORMASK
 
 static const char osd_name[] = "osd";
-static const char *osd_version_string = "open-osd 0.2.0";
+static const char *osd_version_string = "open-osd 0.2.1";
 
 MODULE_AUTHOR("Boaz Harrosh <bharrosh@panasas.com>");
 MODULE_DESCRIPTION("open-osd Upper-Layer-Driver osd.ko");


