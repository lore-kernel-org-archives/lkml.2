Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757883Ab2C0JHq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Mar 2012 05:07:46 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:34681 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2C0JHp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Mar 2012 05:07:45 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q2R8gqon001587, This message is released by code: ctaloc0852
From: <wei_wang@realsil.com.cn>
To: <gregkh@suse.de>, <devel@linuxdriverproject.org>,
        <linux-kernel@vger.kernel.org>
CC: wwang <wei_wang@realsil.com.cn>
Subject: [PATCH 1/3] staging:rts_pstor:Fix unbalanced parentheses
Date: Tue, 27 Mar 2012 16:42:42 +0800
Message-ID: <1332837762-9690-1-git-send-email-wei_wang@realsil.com.cn>
X-Mailer: git-send-email 1.7.5.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: wwang <wei_wang@realsil.com.cn>

Signed-off-by: wwang <wei_wang@realsil.com.cn>
---
 drivers/staging/rts_pstor/ms.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 66341df..e098a90 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -4135,7 +4135,7 @@ int mg_set_ICV(struct scsi_cmnd *srb, struct rtsx_chip *chip)
 #else
 	retval = ms_transfer_data(chip, MS_TM_AUTO_WRITE, PRO_WRITE_LONG_DATA,
 				2, WAIT_INT, 0, 0, buf + 4, 1024);
-	if ((retval != STATUS_SUCCESS) || check_ms_err(chip) {
+	if ((retval != STATUS_SUCCESS) || check_ms_err(chip)) {
 		rtsx_clear_ms_error(chip);
 		if (ms_card->mg_auth == 0) {
 			if ((buf[5] & 0xC0) != 0) {
-- 
1.7.5.4

