Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758755Ab2K3RAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:00:20 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:59357 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab2K3RAQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:00:16 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 05/32] staging: wlags49_h2: ap_h25: corrects casting styling issue
Date: Fri, 30 Nov 2012 18:58:30 +0200
Message-Id: <1354294737-5735-5-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit corrects a casting styling issue as reported by the
checkpatch.pl tool.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h25.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlags49_h2/ap_h25.c b/drivers/staging/wlags49_h2/ap_h25.c
index 454d01b..f578800 100644
--- a/drivers/staging/wlags49_h2/ap_h25.c
+++ b/drivers/staging/wlags49_h2/ap_h25.c
@@ -4014,7 +4014,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x0148,		// sizeof(fw_image_1_data),
 		0x00000060,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_1_data
+		(hcf_8 *)fw_image_1_data
 	},
 	{
 		8,
@@ -4023,7 +4023,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x2432,		// sizeof(fw_image_2_data),
 		0x00000C16,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_2_data
+		(hcf_8 *)fw_image_2_data
 	},
 	{
 		8,
@@ -4032,7 +4032,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x194c,		// sizeof(fw_image_3_data),
 		0x001E3048,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_3_data
+		(hcf_8 *)fw_image_3_data
 	},
 	{
 		8,
@@ -4041,7 +4041,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0xb7e4,		// sizeof(fw_image_4_data),
 		0x001F4000,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_4_data
+		(hcf_8 *)fw_image_4_data
 	},
 	{
 		5,
-- 
1.7.10.4

