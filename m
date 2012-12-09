Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab2LILEP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 06:04:15 -0500
Received: from wren.arvixe.com ([50.97.138.99]:37355 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758329Ab2LILEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 06:04:13 -0500
X-Greylist: delayed 2890 seconds by postgrey-1.27 at vger.kernel.org; Sun, 09 Dec 2012 06:04:13 EST
From: Przemo Firszt <przemo@firszt.eu>
To: Larry.Finger@lwfinger.net, florian.c.schilhabel@googlemail.com,
        greg@kroah.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 5/5] rtl8712: replace leading spaces with tab
Date: Sun,  9 Dec 2012 10:15:10 +0000
Message-Id: <1355048110-10859-5-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
References: <1355048110-10859-1-git-send-email-przemo@firszt.eu>
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - wren.arvixe.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - firszt.eu
X-Get-Message-Sender-Via: wren.arvixe.com: authenticated_id: przemo@firszt.eu
X-Source: 
X-Source-Args: 
X-Source-Dir: 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Replace leading spaces with tab

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/rtl871x_ioctl_linux.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
index b131b61..b4629c3 100644
--- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
+++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
@@ -510,7 +510,7 @@ exit:
 }
 
 static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
-			    unsigned short ielen)
+				unsigned short ielen)
 {
 	u8 *buf = NULL, *pos = NULL;
 	int group_cipher = 0, pairwise_cipher = 0;
-- 
1.8.0.1

