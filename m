Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754422Ab1BIKIX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 05:08:23 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46688 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754394Ab1BIKIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 05:08:18 -0500
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: trivial@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH 03/10] trivial: fix typos concerning "adjust"
Date: Wed,  9 Feb 2011 11:07:35 +0100
Message-Id: <1297246062-23777-3-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1297246062-23777-1-git-send-email-u.kleine-koenig@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/acpi/video.c                   |    2 +-
 drivers/gpu/drm/radeon/radeon_device.c |    2 +-
 drivers/mtd/maps/dilnetpc.c            |    2 +-
 drivers/scsi/lpfc/lpfc_scsi.c          |    2 +-
 net/caif/caif_socket.c                 |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/acpi/video.c b/drivers/acpi/video.c
index 90f8f76..fbd4845 100644
--- a/drivers/acpi/video.c
+++ b/drivers/acpi/video.c
@@ -1201,7 +1201,7 @@ acpi_video_get_next_level(struct acpi_video_device *device,
 				break;
 		}
 	}
-	/* Ajust level_current to closest available level */
+	/* Adjust level_current to closest available level */
 	level_current += delta;
 	for (i = 2; i < device->brightness->count; i++) {
 		l = device->brightness->levels[i];
diff --git a/drivers/gpu/drm/radeon/radeon_device.c b/drivers/gpu/drm/radeon/radeon_device.c
index 0d47893..5d23894 100644
--- a/drivers/gpu/drm/radeon/radeon_device.c
+++ b/drivers/gpu/drm/radeon/radeon_device.c
@@ -307,7 +307,7 @@ void radeon_vram_location(struct radeon_device *rdev, struct radeon_mc *mc, u64
  *
  * Function will place try to place GTT before or after VRAM.
  *
- * If GTT size is bigger than space left then we ajust GTT size.
+ * If GTT size is bigger than space left then we adjust GTT size.
  * Thus function will never fails.
  *
  * FIXME: when reducing GTT size align new size on power of 2.
diff --git a/drivers/mtd/maps/dilnetpc.c b/drivers/mtd/maps/dilnetpc.c
index 0713e3a..b5517f8 100644
--- a/drivers/mtd/maps/dilnetpc.c
+++ b/drivers/mtd/maps/dilnetpc.c
@@ -422,7 +422,7 @@ static int __init init_dnpc(void)
 
 	/*
 	** If flash probes fail, try to make flashes accessible
-	** at least as ROM. Ajust erasesize in this case since
+	** at least as ROM. Adjust erasesize in this case since
 	** the default one (128M) will break our partitioning
 	*/
 	if (!mymtd)
diff --git a/drivers/scsi/lpfc/lpfc_scsi.c b/drivers/scsi/lpfc/lpfc_scsi.c
index c97751c..11199ba 100644
--- a/drivers/scsi/lpfc/lpfc_scsi.c
+++ b/drivers/scsi/lpfc/lpfc_scsi.c
@@ -1808,7 +1808,7 @@ lpfc_bg_scsi_prep_dma_buf(struct lpfc_hba *phba,
 		/*
 		 * We are in DIF Type 1 mode
 		 * Every data block has a 8 byte DIF (trailer)
-		 * attached to it.  Must ajust FCP data length
+		 * attached to it.  Must adjust FCP data length
 		 */
 		blksize = lpfc_cmd_blksize(scsi_cmnd);
 		diflen = (fcpdl / blksize) * 8;
diff --git a/net/caif/caif_socket.c b/net/caif/caif_socket.c
index 8184c03..3437b07 100644
--- a/net/caif/caif_socket.c
+++ b/net/caif/caif_socket.c
@@ -853,7 +853,7 @@ static int caif_connect(struct socket *sock, struct sockaddr *uaddr,
 	sk->sk_state = CAIF_CONNECTING;
 
 	/* Check priority value comming from socket */
-	/* if priority value is out of range it will be ajusted */
+	/* if priority value is out of range it will be adjusted */
 	if (cf_sk->sk.sk_priority > CAIF_PRIO_MAX)
 		cf_sk->conn_req.priority = CAIF_PRIO_MAX;
 	else if (cf_sk->sk.sk_priority < CAIF_PRIO_MIN)
-- 
1.7.2.3

