Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758798Ab2K3RC1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:02:27 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:55829 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758785Ab2K3RCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:02:23 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 18/32] staging: wlags49_h2: sta_h2: fixes spaces around parentheses
Date: Fri, 30 Nov 2012 18:58:43 +0200
Message-Id: <1354294737-5735-18-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit fixes an instance where the spacing around parentheses
was incorrect.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/sta_h2.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/sta_h2.c b/drivers/staging/wlags49_h2/sta_h2.c
index 7c50ccd..711c7e0 100644
--- a/drivers/staging/wlags49_h2/sta_h2.c
+++ b/drivers/staging/wlags49_h2/sta_h2.c
@@ -4381,7 +4381,7 @@ static const hcf_8 fw_image_4_data[] = {
 
 static const CFG_IDENTITY_STRCT fw_image_infoidentity[] = {
 	{
-		sizeof( CFG_IDENTITY_STRCT ) / sizeof(hcf_16) - 1,
+		sizeof(CFG_IDENTITY_STRCT) / sizeof(hcf_16) - 1,
 		CFG_FW_IDENTITY,
 		COMP_ID_FW_STA,
 		3,							//Variant
-- 
1.7.10.4

