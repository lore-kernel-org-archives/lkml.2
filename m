Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756803Ab1ESIhl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 04:37:41 -0400
Received: from qmta15.emeryville.ca.mail.comcast.net ([76.96.27.228]:53240
	"EHLO qmta15.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754292Ab1ESIhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 04:37:40 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH] staging: usbip: userspace: stub_driver.c: update kernel module name
Date: Thu, 19 May 2011 01:37:31 -0700
Message-Id: <7e165c8295921944bbd2f6c2bf36a548af5a167b.1305794195.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kernel module name to usbip-host.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 .../staging/usbip/userspace/libsrc/stub_driver.c   |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/usbip/userspace/libsrc/stub_driver.c b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
index 4c76e03..cc33643 100644
--- a/drivers/staging/usbip/userspace/libsrc/stub_driver.c
+++ b/drivers/staging/usbip/userspace/libsrc/stub_driver.c
@@ -8,7 +8,8 @@
 
 #include "usbip.h"
 
-static const char *usbip_stub_driver_name = "usbip";
+/* kernel module name */
+static const char *usbip_stub_driver_name = "usbip-host";
 
 
 struct usbip_stub_driver *stub_driver;
-- 
1.7.5.1

