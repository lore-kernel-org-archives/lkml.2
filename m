Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935481Ab1IOXae (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:30:34 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51055 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935411Ab1IOXad (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:30:33 -0400
From: David Kilroy <kilroyd@googlemail.com>
To: linux-kernel@vger.kernel.org, greg@kroah.com
Cc: pe1dnn@amsat.org, David Kilroy <kilroyd@googlemail.com>
Subject: [PATCH 12/13] staging: wlags49_h2: Reformat TX_CNTL comment
Date: Fri, 16 Sep 2011 00:20:56 +0100
Message-Id: <1316128857-9781-13-git-send-email-kilroyd@googlemail.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
References: <1316128857-9781-1-git-send-email-kilroyd@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This tabular comment is useful, but the original tabbed layout
is for a tab-wdth of 4. Reformat with spaces.

Signed-off-by: David Kilroy <kilroyd@googlemail.com>
---
 drivers/staging/wlags49_h2/mdd.h |   28 ++++++++++++++--------------
 1 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/wlags49_h2/mdd.h b/drivers/staging/wlags49_h2/mdd.h
index acdeacd..b02e3ea 100644
--- a/drivers/staging/wlags49_h2/mdd.h
+++ b/drivers/staging/wlags49_h2/mdd.h
@@ -893,20 +893,20 @@ XX1( CFG_SCAN,					SCAN_RS_STRCT, scan_result[32]		 ) /*Scan results											*
 
 //HFS_TX_CNTL
 /* Note that the HCF_.... System Constants influence the HFS_.... values below
- * 								H-I		H-I	 |	H-II	H-II	H-II.5
- *										WPA	 |			WPA
- * HFS_TX_CNTL_TX_OK			0002	0002 |	0002	0002	 N/A	<<<<<<<<deprecated
- * HFS_TX_CNTL_TX_EX			0004	0004 |	0004	0004	 N/A
- * HFS_TX_CNTL_MIC				 N/A	0010 |	 N/A	0010	 N/A
- * HFS_TX_CNTL_TID				 N/A	 N/A |	 N/A	 N/A	000F
- * HFS_TX_CNTL_SERVICE_CLASS	 N/A	 N/A |	 N/A	 N/A	00C0
- * HFS_TX_CNTL_PORT				0700	0700 |	0700	0700	0700
- * HFS_TX_CNTL_MIC_KEY_ID		1800	1800 |	0000	1800	 N/A
- * HFS_TX_CNTL_CKIP				0000	0000 |	0000	2000	2000
- * HFS_TX_CNTL_TX_DELAY			4000	4000 |	4000	4000	 N/A
- * HFS_TX_CNTL_ACTION			 N/A	 N/A |	 N/A	 N/A	4000
- * 								====	==== |	====	====	====
- * 								5F06	5F16 |	4706	7F06	67CF
+ *                              H-I     H-I  |  H-II    H-II    H-II.5
+ *                                      WPA  |          WPA
+ * HFS_TX_CNTL_TX_OK            0002    0002 |  0002    0002     N/A    <<<<<<<<deprecated
+ * HFS_TX_CNTL_TX_EX            0004    0004 |  0004    0004     N/A
+ * HFS_TX_CNTL_MIC               N/A    0010 |   N/A    0010     N/A
+ * HFS_TX_CNTL_TID               N/A     N/A |   N/A     N/A    000F
+ * HFS_TX_CNTL_SERVICE_CLASS     N/A     N/A |   N/A     N/A    00C0
+ * HFS_TX_CNTL_PORT             0700    0700 |  0700    0700    0700
+ * HFS_TX_CNTL_MIC_KEY_ID       1800    1800 |  0000    1800     N/A
+ * HFS_TX_CNTL_CKIP             0000    0000 |  0000    2000    2000
+ * HFS_TX_CNTL_TX_DELAY         4000    4000 |  4000    4000     N/A
+ * HFS_TX_CNTL_ACTION            N/A     N/A |   N/A     N/A    4000
+ *                              ====    ==== |  ====    ====    ====
+ *                              5F06    5F16 |  4706    7F06    67CF
  *
  * HCF_TX_CNTL_MASK specifies the bits allowed on the Host I/F
  * note: bit 0x4000 has different meaning for H-II and H-II.5
-- 
1.7.4.1

