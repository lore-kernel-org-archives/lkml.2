Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753049Ab1DQSJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Apr 2011 14:09:30 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:52416 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752131Ab1DQSJY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Apr 2011 14:09:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=IJ6LMVXdjJWZOgZ7rCDnic9Bpwhwf8zX/CsEZJ2LyMoLXrvsRdb89qN3y4QLxBwayw
         MpaT3GrBcQ49NBybUdPuHjBEH0ehja6CrItTDRbWiPgTFfdHcAI/JdY0knPxPawP7zG9
         cfZVH32KaaPlz7G89f4KRVMhczWW8z2DVI+Jc=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 1/5 v2]Typo: change kenrel to kernel.
Date: Sun, 17 Apr 2011 11:09:05 -0700
Message-Id: <1303063749-8282-1-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch is a resend due to rebasing to the current Mainline, in
of which changes a typo "kenrel" to "kernel".

Signed-off-by: Justin P. Mattock  <justinmattock@gmail.com>

---
 Documentation/feature-removal-schedule.txt    |    2 +-
 drivers/media/video/saa7164/saa7164-encoder.c |    2 +-
 drivers/media/video/saa7164/saa7164-vbi.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 492e81d..9536652 100644
--- a/Documentation/feature-removal-schedule.txt
+++ b/Documentation/feature-removal-schedule.txt
@@ -226,7 +226,7 @@ Who:	Zhang Rui <rui.zhang@intel.com>
 What:	CONFIG_ACPI_PROCFS_POWER
 When:	2.6.39
 Why:	sysfs I/F for ACPI power devices, including AC and Battery,
-        has been working in upstream kenrel since 2.6.24, Sep 2007.
+        has been working in upstream kernel since 2.6.24, Sep 2007.
 	In 2.6.37, we make the sysfs I/F always built in and this option
 	disabled by default.
 	Remove this option and the ACPI power procfs interface in 2.6.39.
diff --git a/drivers/media/video/saa7164/saa7164-encoder.c b/drivers/media/video/saa7164/saa7164-encoder.c
index f9d5946..4003645 100644
--- a/drivers/media/video/saa7164/saa7164-encoder.c
+++ b/drivers/media/video/saa7164/saa7164-encoder.c
@@ -177,7 +177,7 @@ static int saa7164_encoder_buffers_alloc(struct saa7164_port *port)
 		}
 	}
 
-	/* Allocate some kenrel kernel buffers for copying
+	/* Allocate some kernel buffers for copying
 	 * to userpsace.
 	 */
 	len = params->numberoflines * params->pitch;
diff --git a/drivers/media/video/saa7164/saa7164-vbi.c b/drivers/media/video/saa7164/saa7164-vbi.c
index 9e5b01c..bc1fced 100644
--- a/drivers/media/video/saa7164/saa7164-vbi.c
+++ b/drivers/media/video/saa7164/saa7164-vbi.c
@@ -148,7 +148,7 @@ static int saa7164_vbi_buffers_alloc(struct saa7164_port *port)
 		}
 	}
 
-	/* Allocate some kenrel kernel buffers for copying
+	/* Allocate some kernel buffers for copying
 	 * to userpsace.
 	 */
 	len = params->numberoflines * params->pitch;
-- 
1.7.4.4

