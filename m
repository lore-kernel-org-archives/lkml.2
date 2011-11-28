Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1K1MMy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 07:12:54 -0500
Received: from mail.infrascan.de ([188.40.84.136]:60516 "EHLO infrascan.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752997Ab1K1MMx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 07:12:53 -0500
X-Greylist: delayed 536 seconds by postgrey-1.27 at vger.kernel.org; Mon, 28 Nov 2011 07:12:53 EST
From: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
To: balbi@ti.com, gregkh@suse.de
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Subject: [PATCH] linux-cdc-acm.inf: add support for the acm_ms gadget
Date: Mon, 28 Nov 2011 13:03:25 +0100
Message-Id: <1322481805-11450-1-git-send-email-schwarzkopf@sensortherm.de>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Support for the acm_ms usb gadget on windows.

Signed-off-by: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
---
 Documentation/usb/linux-cdc-acm.inf |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/usb/linux-cdc-acm.inf b/Documentation/usb/linux-cdc-acm.inf
index 37a02ce..f0ffc27 100644
--- a/Documentation/usb/linux-cdc-acm.inf
+++ b/Documentation/usb/linux-cdc-acm.inf
@@ -90,10 +90,10 @@ ServiceBinary=%12%\USBSER.sys
 [SourceDisksFiles]
 [SourceDisksNames]
 [DeviceList]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_1D6B&PID_0104&MI_02
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_1D6B&PID_0104&MI_02, USB\VID_1D6B&PID_0106&MI_00
 
 [DeviceList.NTamd64]
-%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_1D6B&PID_0104&MI_02
+%DESCRIPTION%=DriverInstall, USB\VID_0525&PID_A4A7, USB\VID_1D6B&PID_0104&MI_02, USB\VID_1D6B&PID_0106&MI_00
 
 
 ;------------------------------------------------------------------------------
-- 
1.7.0.4

