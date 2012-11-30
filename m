Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031079Ab2K3RBL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Nov 2012 12:01:11 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:47831 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031052Ab2K3RBF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Nov 2012 12:01:05 -0500
From: Johan Meiring <johanmeiring@gmail.com>
To: pe1dnn@amsat.org, jkosina@suse.cz, standby24x7@gmail.com,
        viro@zeniv.linux.org.uk, gregkh@linuxfoundation.org
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Johan Meiring <johanmeiring@gmail.com>
Subject: [PATCH 10/32] staging: wlags49_h2: wl_enc: fixes incorrect use of return
Date: Fri, 30 Nov 2012 18:58:35 +0200
Message-Id: <1354294737-5735-10-git-send-email-johanmeiring@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
References: <1354294737-5735-1-git-send-email-johanmeiring@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This commit removes parentheses that were used as part of return
statements, seeing as how return is not a function.

Signed-off-by: Johan Meiring <johanmeiring@gmail.com>
---
 drivers/staging/wlags49_h2/wl_enc.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/wlags49_h2/wl_enc.c b/drivers/staging/wlags49_h2/wl_enc.c
index 2cf3a113..51293d9 100644
--- a/drivers/staging/wlags49_h2/wl_enc.c
+++ b/drivers/staging/wlags49_h2/wl_enc.c
@@ -155,7 +155,7 @@ int wl_wep_code(char *szCrypt, char *szDest, void *Data, int nLen)
 	}
 	}
 
-	return(strlen(szDest)) ;
+	return strlen(szDest);
 
 }
 /*============================================================================*/
@@ -225,7 +225,7 @@ int wl_wep_decode(char *szCrypt, void *Dest, char *szData)
 
 	}
 
-	return(i) ;
+	return i;
 
 }
 /*============================================================================*/
-- 
1.7.10.4

