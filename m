Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031241Ab2K3RH0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:07:26 -0500
Received: from mail-wi0-f180.google.com ([209.85.212.180]:46604 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031118Ab2K3RHZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:07:25 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 01/32] staging: wlags49_h2: ap_h2: corrects a pointer styling issue
Date: Fri, 30 Nov 2012 18:58:26 +0200
Message-Id: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit correct a pointer styling issue as reported by the
checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlags49_h2/ap_h2.c b/drivers/staging/wlags49_h2/ap_h2.c
index e524153..3a08d42 100644
--- a/drivers/staging/wlags49_h2/ap_h2.c
+++ b/drivers/staging/wlags49_h2/ap_h2.c
@@ -3256,7 +3256,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x0146,		/* sizeof(fw_image_1_data), */
 		0x00000060,					/* Target address in NIC Memory */
 		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_1_data
+		(hcf_8 *)fw_image_1_data
 	},
 	{
 		8,
@@ -3265,7 +3265,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x1918,		/* sizeof(fw_image_2_data), */
 		0x00000C16,					/* Target address in NIC Memory */
 		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_2_data
+		(hcf_8 *)fw_image_2_data
 	},
 	{
 		8,
@@ -3274,7 +3274,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x01bc,		/* sizeof(fw_image_3_data), */
 		0x001E252E,					/* Target address in NIC Memory */
 		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_3_data
+		(hcf_8 *)fw_image_3_data
 	},
 	{
 		8,
@@ -3283,7 +3283,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0xab28,		/* sizeof(fw_image_4_data), */
 		0x001F4000,					/* Target address in NIC Memory */
 		0x0000,						/* CRC: yes/no	TYPE: primary/station/tertiary */
-		(hcf_8 FAR *) fw_image_4_data
+		(hcf_8 *)fw_image_4_data
 	},
 	{
 		5,
-- 
1.7.10.4

