Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759429Ab1FQWva (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 18:51:30 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:44884 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756491Ab1FQWv2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 18:51:28 -0400
From: matt mooney <mfm@muteddisk.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: [PATCH] MAINTAINERS: add myself as maintainer of USB/IP
Date: Fri, 17 Jun 2011 15:50:46 -0700
Message-Id: <e33fee87976bbe3c45c96149f380f8454da1318c.1308350976.git.mfm@muteddisk.com>
X-Mailer: git-send-email 1.7.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: matt mooney <mfm@muteddisk.com>
---
 MAINTAINERS |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index fbf266c..ea8aac9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6474,6 +6474,12 @@ S:	Maintained
 F:	Documentation/usb/hiddev.txt
 F:	drivers/hid/usbhid/
 
+USB/IP DRIVERS
+M:	matt mooney <mfm@muteddisk.com>
+L:	linux-usb@vger.kernel.org
+S:	Maintained
+F:	drivers/staging/usbip/
+
 USB ISP116X DRIVER
 M:	Olav Kongas <ok@artecdesign.ee>
 L:	linux-usb@vger.kernel.org
-- 
1.7.5.2

