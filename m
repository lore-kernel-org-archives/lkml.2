Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab2CZFez (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 01:34:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52571 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab2CZFey (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 01:34:54 -0400
From: Hitoshi NAKAMORI <hitoshi.nakamori@gmail.com>
To: gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        hitoshi.nakamori@gmail.com
Subject: [PATCH] Staging:rts_pstor: fix coding style issue in rtsx_transport.c
Date: Mon, 26 Mar 2012 14:34:50 +0900
Message-Id: <1332740090-10714-1-git-send-email-hitoshi.nakamori@gmail.com>
X-Mailer: git-send-email 1.7.8.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes the space of the indent to the tab that warning
found by the checkpatch.pl tool.

Signed-off-by: Hitoshi NAKAMORI<hitoshi.nakamori@gmail.com>
---
 drivers/staging/rts_pstor/rtsx_transport.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rts_pstor/rtsx_transport.c b/drivers/staging/rts_pstor/rtsx_transport.c
index 4e3d2c1..488f950 100644
--- a/drivers/staging/rts_pstor/rtsx_transport.c
+++ b/drivers/staging/rts_pstor/rtsx_transport.c
@@ -130,7 +130,7 @@ unsigned int rtsx_stor_access_xfer_buf(unsigned char *buffer,
 /* Store the contents of buffer into srb's transfer buffer and set the
 * SCSI residue. */
 void rtsx_stor_set_xfer_buf(unsigned char *buffer,
-       unsigned int buflen, struct scsi_cmnd *srb)
+	unsigned int buflen, struct scsi_cmnd *srb)
 {
 	unsigned int index = 0, offset = 0;
 
@@ -141,7 +141,7 @@ void rtsx_stor_set_xfer_buf(unsigned char *buffer,
 }
 
 void rtsx_stor_get_xfer_buf(unsigned char *buffer,
-       unsigned int buflen, struct scsi_cmnd *srb)
+	unsigned int buflen, struct scsi_cmnd *srb)
 {
 	unsigned int index = 0, offset = 0;
 
-- 
1.7.8.3

