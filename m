Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759293Ab1CaTur (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:50:47 -0400
Received: from adelie.canonical.com ([91.189.90.139]:53545 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759203Ab1CaTuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:50:37 -0400
From: Manoj Iyer <manoj.iyer@canonical.com>
To: linux-kernel@vger.kernel.org
Cc: dmitry.torokhov@gmail.com, pingc@wacom.com, chris@cnpbagwell.com
Subject: [PATCH] add support for Lenovo tablet ID (0xE6)
Date: Thu, 31 Mar 2011 14:50:04 -0500
Message-Id: <1301601004-5391-2-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1301601004-5391-1-git-send-email-manoj.iyer@canonical.com>
References: <1301601004-5391-1-git-send-email-manoj.iyer@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Manoj Iyer <manoj.iyer@canonical.com>
---
 drivers/input/tablet/wacom_wac.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/input/tablet/wacom_wac.c b/drivers/input/tablet/wacom_wac.c
index c87d94f..08ba5ad 100644
--- a/drivers/input/tablet/wacom_wac.c
+++ b/drivers/input/tablet/wacom_wac.c
@@ -1439,6 +1439,9 @@ static const struct wacom_features wacom_features_0xE2 =
 static const struct wacom_features wacom_features_0xE3 =
 	{ "Wacom ISDv4 E3",       WACOM_PKGLEN_TPC2FG,    26202, 16325,  255,
 	  0, TABLETPC2FG, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
+static const struct wacom_features wacom_features_0xE6 =
+	{ "Wacom ISDv4 E6",       WACOM_PKGLEN_TPC2FG,    27760, 15694,  255,
+	  0, TABLETPC2FG, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
 static const struct wacom_features wacom_features_0x47 =
 	{ "Wacom Intuos2 6x8",    WACOM_PKGLEN_INTUOS,    20320, 16240, 1023,
 	  31, INTUOS, WACOM_INTUOS_RES, WACOM_INTUOS_RES };
@@ -1561,6 +1564,7 @@ const struct usb_device_id wacom_ids[] = {
 	{ USB_DEVICE_WACOM(0x9F) },
 	{ USB_DEVICE_WACOM(0xE2) },
 	{ USB_DEVICE_WACOM(0xE3) },
+	{ USB_DEVICE_WACOM(0xE6) },
 	{ USB_DEVICE_WACOM(0x47) },
 	{ USB_DEVICE_LENOVO(0x6004) },
 	{ }
-- 
1.7.1

