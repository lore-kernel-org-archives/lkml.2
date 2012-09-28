Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422725Ab2I1VAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 17:00:08 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:59817 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1033013Ab2I1Ury (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:47:54 -0400
X-Sasl-enc: OgvQGEDtRzNAR/v5qsz88SgPCn1FhLx2qv0PGkXR+wyV 1348865274
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?S=C3=B8ren=20Holm?= <sgh@sgh.dk>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20062/127=5D=20asix=3A=20Support=20DLink=20DUB-E100=20H/W=20Ver=20C1?=
Date: Fri, 28 Sep 2012 13:33:55 -0700
Message-Id: <20120928203053.107402807@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928203045.835238916@linuxfoundation.org>
References: <20120928203045.835238916@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1537,6 +1537,10 @@ static const struct usb_device_id	produc
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


