Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757505Ab2FFQbG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 12:31:06 -0400
Received: from www84.your-server.de ([213.133.104.84]:36982 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757394Ab2FFQbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 12:31:03 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: alan@lxorguk.ukuu.org.uk, linux-usb@vger.kernel.org,
        Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 11/11] Bump version number and add aditional author
Date: Wed,  6 Jun 2012 18:27:12 +0200
Message-Id: <1339000032-10313-12-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339000032-10313-1-git-send-email-stefani@seibold.net>
References: <1339000032-10313-1-git-send-email-stefani@seibold.net>
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stefani Seibold <stefani@seibold.net>

Signed-off-by: Stefani Seibold <stefani@seibold.net>
---
 drivers/usb/usb-skeleton.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/usb-skeleton.c b/drivers/usb/usb-skeleton.c
index 81d256f..c93841c 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -1,7 +1,8 @@
 /*
- * USB Skeleton driver - 2.2
+ * USB Skeleton driver - 2.3
  *
  * Copyright (C) 2001-2004 Greg Kroah-Hartman (greg@kroah.com)
+ * fixes by Stefani Seibold (stefani@seibold.net)
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
-- 
1.7.8.6

