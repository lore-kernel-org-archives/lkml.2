Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754944Ab2EELQz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 07:16:55 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2549 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754623Ab2EELQx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 07:16:53 -0400
Message-ID: <1336216611.8450.2.camel@x61.thuisdomein>
Subject: [PATCH] usb: make vendor id of root hubs greppable
From: Paul Bolle <pebolle@tiscali.nl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 05 May 2012 13:16:51 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 05 May 2012 11:16:51.0631 (UTC) FILETIME=[92095BF0:01CD2AB0]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It took me surprisingly long to find the location where the Linux
Foundation vendor id (0x1d6b) is set for the root hubs. A minor update
to three comments makes those locations (trivially) greppable.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
 drivers/usb/core/hcd.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/hcd.c b/drivers/usb/core/hcd.c
index 140d3e1..0cd2daa 100644
--- a/drivers/usb/core/hcd.c
+++ b/drivers/usb/core/hcd.c
@@ -138,7 +138,7 @@ static const u8 usb3_rh_dev_descriptor[18] = {
 	0x03,       /*  __u8  bDeviceProtocol; USB 3.0 hub */
 	0x09,       /*  __u8  bMaxPacketSize0; 2^9 = 512 Bytes */
 
-	0x6b, 0x1d, /*  __le16 idVendor; Linux Foundation */
+	0x6b, 0x1d, /*  __le16 idVendor; Linux Foundation 0x1d6b */
 	0x03, 0x00, /*  __le16 idProduct; device 0x0003 */
 	KERNEL_VER, KERNEL_REL, /*  __le16 bcdDevice */
 
@@ -159,7 +159,7 @@ static const u8 usb2_rh_dev_descriptor [18] = {
 	0x00,       /*  __u8  bDeviceProtocol; [ usb 2.0 no TT ] */
 	0x40,       /*  __u8  bMaxPacketSize0; 64 Bytes */
 
-	0x6b, 0x1d, /*  __le16 idVendor; Linux Foundation */
+	0x6b, 0x1d, /*  __le16 idVendor; Linux Foundation 0x1d6b */
 	0x02, 0x00, /*  __le16 idProduct; device 0x0002 */
 	KERNEL_VER, KERNEL_REL, /*  __le16 bcdDevice */
 
@@ -182,7 +182,7 @@ static const u8 usb11_rh_dev_descriptor [18] = {
 	0x00,       /*  __u8  bDeviceProtocol; [ low/full speeds only ] */
 	0x40,       /*  __u8  bMaxPacketSize0; 64 Bytes */
 
-	0x6b, 0x1d, /*  __le16 idVendor; Linux Foundation */
+	0x6b, 0x1d, /*  __le16 idVendor; Linux Foundation 0x1d6b */
 	0x01, 0x00, /*  __le16 idProduct; device 0x0001 */
 	KERNEL_VER, KERNEL_REL, /*  __le16 bcdDevice */
 
-- 
1.7.7.6



