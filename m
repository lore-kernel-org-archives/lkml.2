Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030743Ab2K3RKZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:10:25 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:58472 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932713Ab2K3RKX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:10:23 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 19/32] staging: wlags49_h2: sta_h2: fixes casting style issue
Date: Fri, 30 Nov 2012 18:58:44 +0200
Message-Id: <1354294737-5735-19-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit cleans up a styling issue when casting to "hcf_8 *".

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/sta_h2.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wlags49_h2/sta_h2.c b/drivers/staging/wlags49_h2/sta_h2.c
index 711c7e0..f0991c4 100644
--- a/drivers/staging/wlags49_h2/sta_h2.c
+++ b/drivers/staging/wlags49_h2/sta_h2.c
@@ -4399,7 +4399,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x0186,		// sizeof(fw_image_1_data),
 		0x00000060,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_1_data
+		(hcf_8 *)fw_image_1_data
 	},
 	{
 		8,
@@ -4408,7 +4408,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x2518,		// sizeof(fw_image_2_data),
 		0x00000C16,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_2_data
+		(hcf_8 *)fw_image_2_data
 	},
 	{
 		8,
@@ -4417,7 +4417,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0x3daa,		// sizeof(fw_image_3_data),
 		0x001E312E,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_3_data
+		(hcf_8 *)fw_image_3_data
 	},
 	{
 		8,
@@ -4426,7 +4426,7 @@ static const CFG_PROG_STRCT fw_image_code[] = {
 		0xaa66,		// sizeof(fw_image_4_data),
 		0x001F4000,					// Target address in NIC Memory
 		0x0000,						// CRC: yes/no	TYPE: primary/station/tertiary
-		(hcf_8 FAR   *) fw_image_4_data
+		(hcf_8 *)fw_image_4_data
 	},
 	{
 		5,
-- 
1.7.10.4

