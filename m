Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933306Ab1IBD7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 23:59:03 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:58219 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933234Ab1IBD67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 23:58:59 -0400
From: "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Ruslan Pisarev <ruslan@rpisarev.org.ua>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Joe Perches <joe@perches.com>,
        Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Arnd Bergmann <arnd@arndb.de>,
        Youquan Song <youquan.song@intel.com>, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org,
        "Leonid V. Fedorenchik" <leonidsbox@gmail.com>
Subject: [PATCH v4 17/19] Staging: cx25821: Fix long lines in cx25821-video-upstream-ch2.h
Date: Fri,  2 Sep 2011 11:55:45 +0800
Message-Id: <1314935747-6881-18-git-send-email-leonidsbox@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
References: <1314935747-6881-1-git-send-email-leonidsbox@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix long lines in cx25821-video-upstream-ch2.h

Signed-off-by: Leonid V. Fedorenchik <leonidsbox@gmail.com>
---
 .../staging/cx25821/cx25821-video-upstream-ch2.h   |   83 ++++++++++++++------
 1 files changed, 60 insertions(+), 23 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
index 029e830..d42dab5 100644
--- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
+++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.h
@@ -65,37 +65,74 @@
 #define USE_RISC_NOOP_VIDEO   1
 
 #ifdef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +   \
-				    RISC_SYNC_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define PAL_US_VID_PROG_SIZE						\
+	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
+	 RISC_WRITECR_INSTRUCTION_SIZE + RISC_SYNC_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 
 #define PAL_RISC_BUF_SIZE         (2 * PAL_US_VID_PROG_SIZE)
 
-#define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)
+#define PAL_VID_PROG_SIZE						\
+	((PAL_FIELD_HEIGHT * 2) * 3 * DWORD_SIZE +			\
+	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	 JUMP_INSTRUCTION_SIZE + 2 * NUM_NO_OPS * DWORD_SIZE)
 
-#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define ODD_FLD_PAL_PROG_SIZE						\
+	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 
-#define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
-				    JUMP_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define NTSC_US_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE +			\
+	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 
-#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
+#define NTSC_RISC_BUF_SIZE						\
+	(2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
 
-#define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE + 2*NUM_NO_OPS*DWORD_SIZE)
-#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + NUM_NO_OPS*DWORD_SIZE)
+#define FRAME1_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) *			\
+	 3 * DWORD_SIZE + 2 * RISC_SYNC_INSTRUCTION_SIZE +		\
+	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE +	\
+	 2 * NUM_NO_OPS * DWORD_SIZE)
+
+#define ODD_FLD_NTSC_PROG_SIZE						\
+	(NTSC_ODD_FLD_LINES * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE +	\
+	 NUM_NO_OPS * DWORD_SIZE)
 #endif
 
 #ifndef USE_RISC_NOOP_VIDEO
-#define PAL_US_VID_PROG_SIZE      ((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-#define PAL_RISC_BUF_SIZE         (2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE))
-#define PAL_VID_PROG_SIZE         ((PAL_FIELD_HEIGHT*2) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define ODD_FLD_PAL_PROG_SIZE     ((PAL_FIELD_HEIGHT) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-#define ODD_FLD_NTSC_PROG_SIZE    ((NTSC_ODD_FLD_LINES) * 3 * DWORD_SIZE + RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
-#define NTSC_US_VID_PROG_SIZE     ((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
-#define NTSC_RISC_BUF_SIZE        (2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
-#define FRAME1_VID_PROG_SIZE      ((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) * 3 * DWORD_SIZE + 2*RISC_SYNC_INSTRUCTION_SIZE + \
-				    RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+#define PAL_US_VID_PROG_SIZE						\
+	((PAL_FIELD_HEIGHT + 1) * 3 * DWORD_SIZE +			\
+	 RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define PAL_RISC_BUF_SIZE						\
+	(2 * (RISC_SYNC_INSTRUCTION_SIZE + PAL_US_VID_PROG_SIZE))
+
+#define PAL_VID_PROG_SIZE						\
+	((PAL_FIELD_HEIGHT * 2) * 3 * DWORD_SIZE +			\
+	 2 * RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE + \
+	 JUMP_INSTRUCTION_SIZE)
+
+#define ODD_FLD_PAL_PROG_SIZE						\
+	(PAL_FIELD_HEIGHT * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define ODD_FLD_NTSC_PROG_SIZE						\
+	(NTSC_ODD_FLD_LINES * 3 * DWORD_SIZE +				\
+	 RISC_SYNC_INSTRUCTION_SIZE + RISC_WRITECR_INSTRUCTION_SIZE)
+
+#define NTSC_US_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + 1) * 3 * DWORD_SIZE +			\
+	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+
+#define NTSC_RISC_BUF_SIZE						\
+	(2 * (RISC_SYNC_INSTRUCTION_SIZE + NTSC_US_VID_PROG_SIZE))
+
+#define FRAME1_VID_PROG_SIZE						\
+	((NTSC_ODD_FLD_LINES + NTSC_FIELD_HEIGHT) *			\
+	 3 * DWORD_SIZE + 2 * RISC_SYNC_INSTRUCTION_SIZE +		\
+	 RISC_WRITECR_INSTRUCTION_SIZE + JUMP_INSTRUCTION_SIZE)
+
 #endif
-- 
1.7.0.4

