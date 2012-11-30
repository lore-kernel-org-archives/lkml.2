Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933416Ab2K3Q77 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 11:59:59 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:57821 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933370Ab2K3Q7y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 11:59:54 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 03/32] staging: wlags49_h2: ap_h25: corrects parentheses styling issue
Date: Fri, 30 Nov 2012 18:58:28 +0200
Message-Id: <1354294737-5735-3-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit corrects incorrect spaces around parentheses.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/ap_h25.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/ap_h25.c b/drivers/staging/wlags49_h2/ap_h25.c
index f0fd34f..1c8f2be 100644
--- a/drivers/staging/wlags49_h2/ap_h25.c
+++ b/drivers/staging/wlags49_h2/ap_h25.c
@@ -3996,7 +3996,7 @@ static const hcf_8 fw_image_4_data[] = {
 
 static const CFG_IDENTITY_STRCT fw_image_infoidentity[] = {
 	{
-		sizeof( CFG_IDENTITY_STRCT ) / sizeof(hcf_16) - 1,
+		sizeof(CFG_IDENTITY_STRCT) / sizeof(hcf_16) - 1,
 		CFG_FW_IDENTITY,
 		COMP_ID_FW_AP,
 		3,							//Variant
-- 
1.7.10.4

