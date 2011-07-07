Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754072Ab1GGHd2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 03:33:28 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:46671 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab1GGHdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 03:33:22 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 4/7] staging: usbip: userspace: usbip_list.c: modify exportable device output
Date: Thu,  7 Jul 2011 00:31:53 -0700
Message-Id: <7e932c1df825f045f521432ce5ea6927b363977e.1310023068.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <cover.1310023068.git.mfm@muteddisk.com>
References: <cover.1310023068.git.mfm@muteddisk.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change spacing to provide better indentation for readability.

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 drivers/staging/usbip/userspace/src/usbip_list.c |    8 ++++----
 1 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/usbip/userspace/src/usbip_list.c b/drivers/staging/usbip/userspace/src/usbip_list.c
index 3edf5d1..6349638 100644
--- a/drivers/staging/usbip/userspace/src/usbip_list.c
+++ b/drivers/staging/usbip/userspace/src/usbip_list.c
@@ -100,9 +100,9 @@ static int get_exported_devices(char *host, int sockfd)
 		usbip_names_get_class(class_name, sizeof(class_name),
 				      udev.bDeviceClass, udev.bDeviceSubClass,
 				      udev.bDeviceProtocol);
-		printf("%8s: %s\n", udev.busid, product_name);
-		printf("%8s: %s\n", "", udev.path);
-		printf("%8s: %s\n", "", class_name);
+		printf("%11s: %s\n", udev.busid, product_name);
+		printf("%11s: %s\n", "", udev.path);
+		printf("%11s: %s\n", "", class_name);
 
 		for (j = 0; j < udev.bNumInterfaces; j++) {
 			rc = usbip_net_recv(sockfd, &uintf, sizeof(uintf));
@@ -118,7 +118,7 @@ static int get_exported_devices(char *host, int sockfd)
 					      uintf.bInterfaceClass,
 					      uintf.bInterfaceSubClass,
 					      uintf.bInterfaceProtocol);
-			printf("%8s: %2d - %s\n", "", j, class_name);
+			printf("%11s: %2d - %s\n", "", j, class_name);
 		}
 		printf("\n");
 	}
-- 
1.7.6

