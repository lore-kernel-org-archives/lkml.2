Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752421Ab2A1JLg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 04:11:36 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:56597 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab2A1JLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 04:11:33 -0500
MIME-Version: 1.0
Date: Sat, 28 Jan 2012 10:11:32 +0100
Message-ID: <CAFQ_mD6DThCcsvy5=A0sMVBn-1mhwyTeGsM8GpSS__5zDU6K-A@mail.gmail.com>
Subject: [PATCH] qcserial: add support for Huawei Gobi 3000 devices
From: =?ISO-8859-1?Q?Jos=E9_Antonio_Matute?= <matutet@gmail.com>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jose Antonio Matute <matutet@gmail.com>
Add USB IDs for Huawei Gobi 3000 devices (some of which are rebranded
as Sony Vaio VPCSA modems).

Signed-off-by: Jose Antonio Matute <matutet@gmail.com>
Cc: stable@vger.kernel.org
---
--- linux-3.3-rc1/drivers/usb/serial/qcserial.c.orig	2012-01-28
09:43:01.088140483 +0100
+++ linux-3.3-rc1/drivers/usb/serial/qcserial.c	2012-01-28
09:46:37.908131967 +0100
@@ -87,6 +87,7 @@ static const struct usb_device_id id_tab
 	{USB_DEVICE(0x05c6, 0x9204)},	/* Gobi 2000 QDL device */
 	{USB_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
 	{USB_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem
device (MC8355) */
+	{USB_DEVICE(0x12d1, 0x14f1)},	/* Huawei Wireless Gobi 3000 Modem device */
 	{ }				/* Terminating entry */
 };
 MODULE_DEVICE_TABLE(usb, id_table);
