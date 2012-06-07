Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758370Ab2FGIay (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 04:30:54 -0400
Received: from www84.your-server.de ([213.133.104.84]:40563 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751931Ab2FGIaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 04:30:52 -0400
From: stefani@seibold.net
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org, oneukum@suse.de
Cc: linux-usb@vger.kernel.org, Stefani Seibold <stefani@seibold.net>
Subject: [PATCH 13/13] Bump version number and add aditional author
Date: Thu,  7 Jun 2012 10:20:43 +0200
Message-Id: <1339057243-10029-14-git-send-email-stefani@seibold.net>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1339057243-10029-1-git-send-email-stefani@seibold.net>
References: <1339057243-10029-1-git-send-email-stefani@seibold.net>
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
index 456c9a8..1e36782 100644
--- a/drivers/usb/usb-skeleton.c
+++ b/drivers/usb/usb-skeleton.c
@@ -1,7 +1,8 @@
 /*
- * USB Skeleton driver - 2.2
+ * USB Skeleton driver - 2.3
  *
  * Copyright (C) 2001-2004 Greg Kroah-Hartman (greg@kroah.com)
+ * Fixes and cleanup by Stefani Seibold (stefani@seibold.net)
  *
  *	This program is free software; you can redistribute it and/or
  *	modify it under the terms of the GNU General Public License as
-- 
1.7.8.6

