Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755877Ab2JWGXA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 02:23:00 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:45712 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751452Ab2JWGW6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 02:22:58 -0400
From: "Justin P. Mattock" <justinmattock@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: [PATCH 2/2]staging: "winbond" Fix typos.
Date: Mon, 22 Oct 2012 23:22:22 -0700
Message-Id: <1350973342-3868-2-git-send-email-justinmattock@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1350973342-3868-1-git-send-email-justinmattock@gmail.com>
References: <1350973342-3868-1-git-send-email-justinmattock@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Justin P. Mattock" <justinmattock@gmail.com>

Signed-off-by: Justin P. Mattock <justinmattock@gmail.com>

---

The below patch fixes a typo in staging: "winbond"

 drivers/staging/winbond/mds.c   |    2 +-
 drivers/staging/winbond/wbhal.h |    4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/mds.c b/drivers/staging/winbond/mds.c
index 1b8b8ac..43990e8 100644
--- a/drivers/staging/winbond/mds.c
+++ b/drivers/staging/winbond/mds.c
@@ -315,7 +315,7 @@ static void Mds_HeaderCopy(struct wbsoft_priv *adapter, struct wb35_descriptor *
 
 	pT00->T00_tx_packet_id = pDes->Descriptor_ID; /* Set packet ID */
 	pT00->T00_header_length = 24; /* Set header length */
-	pT01->T01_retry_abort_ebable = 1; /* 921013 931130.5.h */
+	pT01->T01_retry_abort_enable = 1; /* 921013 931130.5.h */
 
 	/* Key ID setup */
 	pT01->T01_wep_id = 0;
diff --git a/drivers/staging/winbond/wbhal.h b/drivers/staging/winbond/wbhal.h
index 39e84a0..289ee54 100644
--- a/drivers/staging/winbond/wbhal.h
+++ b/drivers/staging/winbond/wbhal.h
@@ -226,11 +226,11 @@ struct T01_descriptor {
 			u32	T01_add_challenge_text:1;
 			u32	T01_inhibit_crc:1;
 			u32	T01_loop_back_wep_mode:1;
-			u32	T01_retry_abort_ebable:1;
+			u32	T01_retry_abort_enable:1;
 		};
 #else
 		struct {
-			u32	T01_retry_abort_ebable:1;
+			u32	T01_retry_abort_enable:1;
 			u32	T01_loop_back_wep_mode:1;
 			u32	T01_inhibit_crc:1;
 			u32	T01_add_challenge_text:1;
-- 
1.7.10.4

