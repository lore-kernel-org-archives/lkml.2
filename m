Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752060Ab2LJXXu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 18:23:50 -0500
Received: from wren.arvixe.com ([50.97.138.99]:34521 "EHLO wren.arvixe.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752537Ab2LJXWd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 18:22:33 -0500
From: Przemo Firszt <przemo@firszt.eu>
To: greg@kroah.com, Larry.Finger@lwfinger.net,
        florian.c.schilhabel@googlemail.com, dan.carpenter@oracle.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Przemo Firszt <przemo@firszt.eu>
Subject: [PATCH 5/9] rtl8712: remove unused macros
Date: Mon, 10 Dec 2012 23:21:23 +0000
Message-Id: <1355181685-4444-5-git-send-email-przemo@firszt.eu>
X-Mailer: git-send-email 1.8.0.1
In-Reply-To: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
References: <1355181685-4444-1-git-send-email-przemo@firszt.eu>
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

Signed-off-by: Przemo Firszt <przemo@firszt.eu>
---
 drivers/staging/rtl8712/usb_ops_linux.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/staging/rtl8712/usb_ops_linux.c b/drivers/staging/rtl8712/usb_ops_linux.c
index 9e28ef0..dca398a 100644
--- a/drivers/staging/rtl8712/usb_ops_linux.c
+++ b/drivers/staging/rtl8712/usb_ops_linux.c
@@ -45,9 +45,6 @@ struct zero_bulkout_context {
 	void *padapter;
 };
 
-#define usb_write_cmd r8712_usb_write_mem
-#define usb_write_cmd_complete usb_write_mem_complete
-
 uint r8712_usb_init_intf_priv(struct intf_priv *pintfpriv)
 {
 	pintfpriv->piorw_urb = usb_alloc_urb(0, GFP_ATOMIC);
-- 
1.8.0.1

