Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965390Ab2I1TAs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 15:00:48 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64534 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965374Ab2I1TAl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 15:00:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?S=C3=B8ren=20Holm?= <sgh@sgh.dk>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20138/262=5D=20asix=3A=20Support=20DLink=20DUB-E100=20H/W=20Ver=20C1?=
Date: Fri, 28 Sep 2012 11:51:07 -0700
Message-Id: <20120928183014.281301084@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120928182957.993484211@linuxfoundation.org>
References: <20120928182957.993484211@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Søren Holm <sgh@sgh.dk>

commit ed3770a9cd5764a575b83810ea679bbff2b03082 upstream.

Signed-off-by: Søren Holm <sgh@sgh.dk>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/asix.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/net/usb/asix.c
+++ b/drivers/net/usb/asix.c
@@ -1604,6 +1604,10 @@ static const struct usb_device_id	produc
 	USB_DEVICE (0x2001, 0x3c05),
 	.driver_info = (unsigned long) &ax88772_info,
 }, {
+       // DLink DUB-E100 H/W Ver C1
+       USB_DEVICE (0x2001, 0x1a02),
+       .driver_info = (unsigned long) &ax88772_info,
+}, {
 	// Linksys USB1000
 	USB_DEVICE (0x1737, 0x0039),
 	.driver_info = (unsigned long) &ax88178_info,


