Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935039Ab0EZXm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 19:42:29 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56342 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934913Ab0EZXlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 19:41:10 -0400
From: Mike Sheldon <mike@mikeasoft.com>
To: greg@kroah.com, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Mike Sheldon <mike@mikeasoft.com>
Subject: [PATCH 10/15] Staging: winbond: Replace C99 comments with C88
Date: Thu, 27 May 2010 00:39:47 +0100
Message-Id: <1274917192-16962-10-git-send-email-mike@mikeasoft.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
References: <1274917192-16962-1-git-send-email-mike@mikeasoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patches wb35rx_f.h to replace all the C99 style comments (//) with C89 style (/* ... */), as reported by checkpatch.pl.

Signed-off-by: Mike Sheldon <mike@mikeasoft.com>
---
 drivers/staging/winbond/wb35rx_f.h |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/winbond/wb35rx_f.h b/drivers/staging/winbond/wb35rx_f.h
index 7885e51..706905a 100644
--- a/drivers/staging/winbond/wb35rx_f.h
+++ b/drivers/staging/winbond/wb35rx_f.h
@@ -4,9 +4,9 @@
 #include <net/mac80211.h>
 #include "wbhal_s.h"
 
-//====================================
-// Interface function declare
-//====================================
+/*************************************\
+ * Interface function declare        *
+\*************************************/
 unsigned char	Wb35Rx_initial(struct hw_data *pHwData);
 void		Wb35Rx_destroy(struct hw_data *pHwData);
 void		Wb35Rx_stop(struct hw_data *pHwData);
-- 
1.7.0.4

