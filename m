Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757571Ab1E0XhS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:37:18 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:59261 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757046Ab1E0XhO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:37:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=b0InDrWrym2T/lU9sOsgwPvvyISpmydU3PXprAKRNS4lP+QAPmy9KwobKW7Ezokif2
         uPOME07u1zTgHSDV6y2DWLhe5UPyQH+rl0vm8JgFIxabGOGTRa+G9fmGA4i4ZYL+pA22
         pMlePvTuiHjxK/TsAZbgyVPWZ7SgcUGVLemQw=
From: Ralf Thielow <ralf.thielow@googlemail.com>
To: gregkh@suse.de
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Ralf Thielow <ralf.thielow@googlemail.com>
Subject: [PATCH] staging: comedi: fixed a declaration coding style issue
Date: Sat, 28 May 2011 01:37:03 +0200
Message-Id: <1306539423-4553-1-git-send-email-ralf.thielow@googlemail.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed a declaration coding style issue.

Signed-off-by: Ralf Thielow <ralf.thielow@googlemail.com>
---
 drivers/staging/comedi/comedi.h |    6 +++++-
 1 files changed, 5 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/comedi/comedi.h b/drivers/staging/comedi/comedi.h
index 6c900e2..14ea35a 100644
--- a/drivers/staging/comedi/comedi.h
+++ b/drivers/staging/comedi/comedi.h
@@ -514,12 +514,16 @@
 			return 0x1 + pfi_channel;
 		else
 			return 0xb + pfi_channel;
-	} static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel) {
+	}
+
+	static inline unsigned NI_USUAL_RTSI_SELECT(unsigned rtsi_channel)
+	{
 		if (rtsi_channel < 7)
 			return 0xb + rtsi_channel;
 		else
 			return 0x1b;
 	}
+
 /* mode bits for NI general-purpose counters, set with
  * INSN_CONFIG_SET_COUNTER_MODE */
 #define NI_GPCT_COUNTING_MODE_SHIFT 16
-- 
1.7.5.1

