Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031194Ab2K3RDJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:03:09 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45503 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754234Ab2K3RDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:03:04 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 22/32] staging: wlags49_h2: wl_profile.h: fixes C99 // comment
Date: Fri, 30 Nov 2012 18:58:47 +0200
Message-Id: <1354294737-5735-22-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit converts a C99 // comment to /* */. The checkpatch.pl
tool reports that this file has no further styling issues.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_profile.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/wlags49_h2/wl_profile.h b/drivers/staging/wlags49_h2/wl_profile.h
index 12faba2..d615c83 100644
--- a/drivers/staging/wlags49_h2/wl_profile.h
+++ b/drivers/staging/wlags49_h2/wl_profile.h
@@ -84,4 +84,4 @@ int parse_mac_address(char *value, u_char *byte_array);
 void ParseConfigLine(char *pszLine, char **ppszLVal, char **ppszRVal);
 
 
-#endif  // __WL_PROFILE_H__
+#endif  /* __WL_PROFILE_H__ */
-- 
1.7.10.4

