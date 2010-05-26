Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934978Ab0EZXlO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:41:14 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:33626 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934955Ab0EZXlI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:08 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 09/15] Staging: winbond: Fix spacing around brackets and pointers.
Date: Thu, 27 May 2010 00:39:46 +0100
Message-Id: <1274917192-16962-9-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches wb35rx_f.h to correct the spacing around brackets and pointers as reported by checkpatch.pl

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wb35rx_f.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index 98acce5..7885e51 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -7,9 +7,9 @@
 //====================================
 // Interface function declare
 //====================================
-unsigned char		Wb35Rx_initial(  struct hw_data * pHwData );
-void		Wb35Rx_destroy(  struct hw_data * pHwData );
-void		Wb35Rx_stop(  struct hw_data * pHwData );
+unsigned char	Wb35Rx_initial(struct hw_data *pHwData);
+void		Wb35Rx_destroy(struct hw_data *pHwData);
+void		Wb35Rx_stop(struct hw_data *pHwData);
 void		Wb35Rx_start(struct ieee80211_hw *hw);
 
 #endif
-- 
1.7.0.4

