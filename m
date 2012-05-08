Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754572Ab2EHSGw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 14:06:52 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:49975 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036Ab2EHSGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 14:06:50 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-kernel@vger.kernel.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] staging, rts5139: Fix typo in rts5139
Date: Wed,  9 May 2012 03:06:46 +0900
Message-Id: <1336500406-25272-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.1.487.ga3935e6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in rts5139

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/rts5139/rts51x_chip.h | 10 +++++-----
 drivers/staging/rts5139/sd.c          |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/staging/rts5139/rts51x_chip.h b/drivers/staging/rts5139/rts51x_chip.h
index 13fc2a4..65cc30a 100644
--- a/drivers/staging/rts5139/rts51x_chip.h
+++ b/drivers/staging/rts5139/rts51x_chip.h
@@ -242,8 +242,8 @@ struct trace_msg_t {
 #define CUR_ERR                 0x70	/* current error                    */
 #define DEF_ERR                 0x71	/* specific command error           */
 
-/*---- sense key Infomation ----*/
-#define SNSKEYINFO_LEN          3	/* length of sense key infomation   */
+/*---- sense key Information ----*/
+#define SNSKEYINFO_LEN          3	/* length of sense key information   */
 
 #define SKSV                    0x80
 #define CDB_ILLEGAL             0x40
@@ -296,13 +296,13 @@ struct sense_data_t {
 	unsigned char seg_no;	/* segment No.                      */
 	unsigned char sense_key;	/* byte5 : ILI                      */
 	/* bit3-0 : sense key              */
-	unsigned char info[4];	/* infomation                       */
+	unsigned char info[4];	/* information                       */
 	unsigned char ad_sense_len;	/* additional sense data length     */
-	unsigned char cmd_info[4];	/* command specific infomation      */
+	unsigned char cmd_info[4];	/* command specific information      */
 	unsigned char asc;	/* ASC                              */
 	unsigned char ascq;	/* ASCQ                             */
 	unsigned char rfu;	/* FRU                              */
-	unsigned char sns_key_info[3];	/* sense key specific infomation    */
+	unsigned char sns_key_info[3];	/* sense key specific information    */
 };
 
 /* sd_ctl bit map */
diff --git a/drivers/staging/rts5139/sd.c b/drivers/staging/rts5139/sd.c
index d5dd2f9..7e1033d 100644
--- a/drivers/staging/rts5139/sd.c
+++ b/drivers/staging/rts5139/sd.c
@@ -1562,7 +1562,7 @@ static u8 sd_search_final_phase(struct rts51x_chip *chip, u32 phase_map,
 	}
 
 Search_Finish:
-	RTS51X_DEBUGP("Final choosen phase: %d\n", final_phase);
+	RTS51X_DEBUGP("Final chosen phase: %d\n", final_phase);
 	return final_phase;
 }
 
-- 
1.7.10.1.487.ga3935e6

