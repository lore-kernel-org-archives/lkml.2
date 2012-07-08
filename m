Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751954Ab2GHKQS (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 06:16:18 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44151 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751814Ab2GHKQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 06:16:05 -0400
From: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
To: gregkh@linuxfoundation.org
Cc: hitoshi.nakamori@gmail.com, wei_wang@realsil.com.cn,
        dan.carpenter@oracle.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/4] Staging:rts_pstor: Fix brace coding style issue in ms.c
Date: Sun,  8 Jul 2012 10:15:50 +0900
Message-Id: <1341710152-4266-3-git-send-email-hitoshi.nakamori@gmail.com>
X-Mailer: git-send-email 1.7.10
In-Reply-To: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
References: <1341710152-4266-1-git-send-email-hitoshi.nakamori@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the ms.c file that fixes brace warning at ms_switch_clock
function found by checkpatch.pl tool.

Signed-off-by: Hitoshi Nakamori <hitoshi.nakamori@gmail.com>
---
 drivers/staging/rts_pstor/ms.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rts_pstor/ms.c b/drivers/staging/rts_pstor/ms.c
index 99886b0..f389930 100644
--- a/drivers/staging/rts_pstor/ms.c
+++ b/drivers/staging/rts_pstor/ms.c
@@ -369,14 +369,12 @@ static int ms_switch_clock(struct rtsx_chip *chip)
 	int retval;
 
 	retval = select_card(chip, MS_CARD);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	retval = switch_clock(chip, ms_card->ms_clock);
-	if (retval != STATUS_SUCCESS) {
+	if (retval != STATUS_SUCCESS)
 		TRACE_RET(chip, STATUS_FAIL);
-	}
 
 	return STATUS_SUCCESS;
 }
-- 
1.7.10

