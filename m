Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932951Ab1C3RBg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 13:01:36 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:34244 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932932Ab1C3RBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 13:01:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:in-reply-to:references;
        b=tGNbj9d+KqORZys+ren5FBYD8x13I8bRbs3YzSf9ERqYReSoLXg2N5Hp/Nj30oesbs
         aLlElJGBUvcCn4iVcVGIvZl0jjr/POfWrAyHRKVyQvUvoClILjGp+eNgzta+GYhYTw/3
         4uV3KLQ5pIPHWpKVY9LeZ/ryYdOpUEzRuoTCI=
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/5]Documentation and driver: Change kenrel to kernel.
Date: Wed, 30 Mar 2011 10:01:15 -0700
Message-Id: <1301504478-3450-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
References: <1301504478-3450-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The below patch changes kenrel to kernel.
Note:searching I am getting hits about kenrel having to do with
android so these could be wrong.

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---
 Documentation/feature-removal-schedule.txt    |    2 +-
 drivers/media/video/saa7164/saa7164-encoder.c |    2 +-
 drivers/media/video/saa7164/saa7164-vbi.c     |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/feature-removal-schedule.txt b/Documentation/feature-removal-schedule.txt
index 274b32d..b364c59 100644
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
1.7.4.1

