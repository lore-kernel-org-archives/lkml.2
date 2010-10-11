Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753833Ab0JKJH5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 05:07:57 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:49151 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753236Ab0JKJHz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 05:07:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=koeudevlqR/dWRHJ/emsh5OZyMKuKoRjdXKvnLb+hCnM/gPorssjyEulVjBF9Itou/
         YMedzUtJi597e68FmcWTWHEq6LVRvKMrOiFRUklTQQH/X4EamRoaup+qMkMDzxIrOWEz
         NrwtVNiEyML7R0AH/aCq0HVI6FWd0rEr/tbgU=
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Cc: Nohee Ko <noheek@broadcom.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andy Shevchenko <andy.shevchenko@gmail.com>
Subject: [PATCHv2 1/2] staging: brcm80211: clean up custom ctype library again
Date: Mon, 11 Oct 2010 12:07:34 +0300
Message-Id: <9134fce655e27d36628ab508127a6d3f2d8fbfb8.1286787946.git.andy.shevchenko@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The similar cleanup was done before for softmac implementation.  But the
fullmac driver brings this back. Remove it again.

Signed-off-by: Andy Shevchenko <andy.shevchenko@gmail.com>
---
 drivers/staging/brcm80211/brcmfmac/wl_iw.h |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/brcm80211/brcmfmac/wl_iw.h b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
index 1488657..d15abc0 100644
--- a/drivers/staging/brcm80211/brcmfmac/wl_iw.h
+++ b/drivers/staging/brcm80211/brcmfmac/wl_iw.h
@@ -58,7 +58,6 @@ typedef struct wl_iw_extra_params {
 #define	WL_IW_RSSI_EXCELLENT	-57
 #define	WL_IW_RSSI_INVALID	 0
 #define MAX_WX_STRING 80
-#define isprint(c) bcm_isprint(c)
 #define WL_IW_SET_ACTIVE_SCAN	(SIOCIWFIRSTPRIV+1)
 #define WL_IW_GET_RSSI			(SIOCIWFIRSTPRIV+3)
 #define WL_IW_SET_PASSIVE_SCAN	(SIOCIWFIRSTPRIV+5)
-- 
1.7.2.3

