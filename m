Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab2CVRgx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Mar 2012 13:36:53 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:47072 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756936Ab2CVRgv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Mar 2012 13:36:51 -0400
From: Rafal Kapela <raf.kapela@gmail.com>
To: rdunlap@xenotime.net, raf.kapela@gmail.com, gregkh@linuxfoundation.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Documentation:"the the" in ABI/stable/sysfs-driver-usb-usbtmc Documentation misspelling
Date: Thu, 22 Mar 2012 17:35:49 +0000
Message-Id: <1332437749-25766-1-git-send-email-raf.kapela@gmail.com>
X-Mailer: git-send-email 1.7.5.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Rafal Kapela <raf.kapela@gmail.com>
---
 Documentation/ABI/stable/sysfs-driver-usb-usbtmc |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/Documentation/ABI/stable/sysfs-driver-usb-usbtmc b/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
index 23a43b8..2a7f9a0 100644
--- a/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
+++ b/Documentation/ABI/stable/sysfs-driver-usb-usbtmc
@@ -55,7 +55,7 @@ What:		/sys/bus/usb/drivers/usbtmc/devices/*/auto_abort
 Date:		August 2008
 Contact:	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
 Description:
-		This file determines if the the transaction of the USB TMC
+		This file determines if the transaction of the USB TMC
 		device is to be automatically aborted if there is any error.
 		For more details about this, please see the document,
 		"Universal Serial Bus Test and Measurement Class Specification
-- 
1.7.5.4

