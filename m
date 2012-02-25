Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757534Ab2BYBWi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 20:22:38 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38417 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757489Ab2BYBWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 20:22:36 -0500
From: Cyril Roelandt <tipecaml@gmail.com>
To: balbi@ti.com
Cc: dahlmann.thomas@arcor.de, gregkh@linuxfoundation.org,
        linux-geode@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Cyril Roelandt <tipecaml@gmail.com>
Subject: [PATCH 6/6] amd5536udc: Remove old CVS markers.
Date: Sat, 25 Feb 2012 02:15:02 +0100
Message-Id: <1330132502-17057-7-git-send-email-tipecaml@gmail.com>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
References: <1330132502-17057-1-git-send-email-tipecaml@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Git does not care about CVS markers.

Signed-off-by: Cyril Roelandt <tipecaml@gmail.com>
---
 drivers/usb/gadget/amd5536udc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/gadget/amd5536udc.c b/drivers/usb/gadget/amd5536udc.c
index 16079bd..19b01f7 100644
--- a/drivers/usb/gadget/amd5536udc.c
+++ b/drivers/usb/gadget/amd5536udc.c
@@ -29,7 +29,7 @@
 
 /* Driver strings */
 #define UDC_MOD_DESCRIPTION		"AMD 5536 UDC - USB Device Controller"
-#define UDC_DRIVER_VERSION_STRING	"01.00.0206 - $Revision: #3 $"
+#define UDC_DRIVER_VERSION_STRING	"01.00.0206"
 
 /* system */
 #include <linux/module.h>
-- 
1.7.9

