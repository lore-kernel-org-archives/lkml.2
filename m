Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935289Ab1ETEyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 May 2011 00:54:04 -0400
Received: from qmta11.emeryville.ca.mail.comcast.net ([76.96.27.211]:55421
	"EHLO qmta11.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S935247Ab1ETExi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 May 2011 00:53:38 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [PATCH 10/12] staging: usbip: userspace: bind_driver.c: update kernel module name
Date: Thu, 19 May 2011 21:37:04 -0700
Message-Id: <7d1b45b1168cc014fde245ad766b81cf303c4e66.1305866084.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.1
In-Reply-To: <cover.1305866084.git.mfm@muteddisk.com>
References: <cover.1305866084.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change kernel module name to usbip-host.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/bind-driver.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/bind-driver.c b/drivers/staging/usbip/userspace/src/bind-driver.c
index 201ffbb..dcc540a 100644
--- a/drivers/staging/usbip/userspace/src/bind-driver.c
+++ b/drivers/staging/usbip/userspace/src/bind-driver.c
@@ -27,7 +27,7 @@ static const struct option longopts[] = {
 	{NULL,		0,			NULL,  0}
 };
 
-static const char match_busid_path[] = "/sys/bus/usb/drivers/usbip/match_busid";
+static const char match_busid_path[] = "/sys/bus/usb/drivers/usbip-host/match_busid";
 
 
 static void show_help(void)
@@ -228,7 +228,7 @@ static int bind_to_usbip(char *busid)
 	for (i = 0; i < ninterface; i++) {
 		int ret;
 
-		ret = bind_interface(busid, configvalue, i, "usbip");
+		ret = bind_interface(busid, configvalue, i, "usbip-host");
 		if (ret < 0) {
 			g_warning("bind usbip at %s:%d.%d, failed",
 					busid, configvalue, i);
-- 
1.7.5.1

