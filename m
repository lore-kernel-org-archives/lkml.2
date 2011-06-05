Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab1FEQ2X (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:28:23 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:34134 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775Ab1FEQ2W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:28:22 -0400
From: "Ken O'Brien" <kernel@kenobrien.org>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Ken O'Brien" <kernel@kenobrien.org>
Subject: [PATCH] Staging: comedi: Fixed brace coding style issue
Date: Sun,  5 Jun 2011 17:26:08 +0100
Message-Id: <1307291168-20311-1-git-send-email-kernel@kenobrien.org>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed coding style error raised by scripts/checkpatch.pl on comedi.h.
This file no longer throws an error.

Signed-off-by: Ken O'Brien <kernel@kenobrien.org>
---
 drivers/staging/comedi/comedi.h |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 6c900e2..ed6854c 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -514,7 +514,9 @@
 			return 0x1 + pfi_channel;
 		else
 			return 0xb + pfi_channel;
-	} static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel) {
+	}
+	static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel)
+	{
 		if (rtsi_channel < 7)
 			return 0xb + rtsi_channel;
 		else
-- 
1.7.4.1

