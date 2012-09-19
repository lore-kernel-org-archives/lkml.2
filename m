Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751195Ab2ISTiJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 15:38:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43499 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060Ab2ISTiH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 15:38:07 -0400
From: Adil Mujeeb <mujeeb.adil@gmail.com>
To: willy@meta-x.org
Cc: gregkh@linuxfoundation.org, evel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mujeeb.adil@gmail.com
Subject: [PATCH] Staging: panel: Fixed a macro coding style issue
Date: Thu, 20 Sep 2012 01:07:40 +0530
Message-Id: <1348083460-7920-1-git-send-email-mujeeb.adil@gmail.com>
X-Mailer: git-send-email 1.7.6.msysgit.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removed do {} while (0) loop for a single statement macros

Signed-off-by: Adil Mujeeb <mujeeb.adil@gmail.com>
---
 linux-3.6-rc6/drivers/staging/panel/panel.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/linux-3.6-rc6/drivers/staging/panel/panel.c b/linux-3.6-rc6/drivers/staging/panel/panel.c
index 39f9982..d9fec5b 100644
--- a/linux-3.6-rc6/drivers/staging/panel/panel.c
+++ b/linux-3.6-rc6/drivers/staging/panel/panel.c
@@ -137,8 +137,8 @@
 #define r_ctr(x)        (parport_read_control((x)->port))
 #define r_dtr(x)        (parport_read_data((x)->port))
 #define r_str(x)        (parport_read_status((x)->port))
-#define w_ctr(x, y)     do { parport_write_control((x)->port, (y)); } while (0)
-#define w_dtr(x, y)     do { parport_write_data((x)->port, (y)); } while (0)
+#define w_ctr(x, y)     (parport_write_control((x)->port, (y)))
+#define w_dtr(x, y)     (parport_write_data((x)->port, (y)))
 
 /* this defines which bits are to be used and which ones to be ignored */
 /* logical or of the output bits involved in the scan matrix */
-- 
1.7.7.3

