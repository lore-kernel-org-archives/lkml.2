Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759351Ab2I1Uis (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Sep 2012 16:38:48 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:56516 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759309Ab2I1Uif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Sep 2012 16:38:35 -0400
X-Sasl-enc: 2Mp0TD2+QC1+p5+XUXuYaVr7ryBR7cdqlRQ6Vnc17PHt 1348864714
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>
Subject: =?UTF-8?q?=5B=20198/218=5D=20net=3A=20qmi=5Fwwan=3A=20Add=20Sierra=20Wireless=20device=20IDs?=
Date: Fri, 28 Sep 2012 13:16:55 -0700
Message-Id: <20120928201524.271304049@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.1.428.g652398a
In-Reply-To: <20120928201501.208384923@linuxfoundation.org>
References: <20120928201501.208384923@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bjørn Mork <bjorn@mork.no>

commit 5e071b5d1aa6928f8d695c15f52a949d70b8d7fb upstream.

Some additional Gobi3K IDs found in the BSD/GPL licensed
out-of-tree GobiNet driver from Sierra Wireless.

Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/usb/qmi_wwan.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/usb/qmi_wwan.c
+++ b/drivers/net/usb/qmi_wwan.c
@@ -548,6 +548,8 @@ static const struct usb_device_id produc
 	{QMI_GOBI_DEVICE(0x16d8, 0x8002)},	/* CMDTech Gobi 2000 Modem device (VU922) */
 	{QMI_GOBI_DEVICE(0x05c6, 0x9205)},	/* Gobi 2000 Modem device */
 	{QMI_GOBI_DEVICE(0x1199, 0x9013)},	/* Sierra Wireless Gobi 3000 Modem device (MC8355) */
+	{QMI_GOBI_DEVICE(0x1199, 0x9015)},	/* Sierra Wireless Gobi 3000 Modem device */
+	{QMI_GOBI_DEVICE(0x1199, 0x9019)},	/* Sierra Wireless Gobi 3000 Modem device */
 	{ }					/* END */
 };
 MODULE_DEVICE_TABLE(usb, products);


