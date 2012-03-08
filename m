Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758250Ab2CHQGb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 11:06:31 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:45626 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758122Ab2CHQG2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 11:06:28 -0500
From: Masanari Iida <standby24x7@gmail.com>
To: gregkh@linuxfoundation.org
Cc: tirvial@kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH] [trivial] staging: Fix typo in crystalhd_hw.c
Date: Fri,  9 Mar 2012 01:06:20 +0900
Message-Id: <1331222780-32094-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.7.10.rc0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling "interal" to "internal" in
drivers/staging/crystalhd/crystalhd_hw.c

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 drivers/staging/crystalhd/crystalhd_hw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/crystalhd/crystalhd_hw.c b/drivers/staging/crystalhd/crystalhd_hw.c
index 88b538b..e617d2f 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.c
+++ b/drivers/staging/crystalhd/crystalhd_hw.c
@@ -767,7 +767,7 @@ static enum BC_STATUS crystalhd_hw_fill_desc(struct crystalhd_dio_req *ioreq,
 	crystalhd_hw_dump_desc(desc, last_desc_ix, 1);
 
 	if (count != xfr_sz) {
-		BCMLOG_ERR("interal error sz curr:%x exp:%x\n", count, xfr_sz);
+		BCMLOG_ERR("internal error sz curr:%x exp:%x\n", count, xfr_sz);
 		return BC_STS_ERROR;
 	}
 
-- 
1.7.10.rc0

