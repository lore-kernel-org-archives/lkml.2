Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760598Ab1CEBCU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 20:02:20 -0500
Received: from kroah.org ([198.145.64.141]:50502 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932517Ab1CEBBC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 20:01:02 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Fri Mar  4 16:56:41 2011
Message-Id: <20110305005641.221655430@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Fri, 04 Mar 2011 16:56:13 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Christian Lamparter <chunkeey@googlemail.com>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: [68/73] carl9170: add Airlive X.USB a/b/g/n USBID
In-Reply-To: <20110305005720.GA16162@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Jan Puk <janpuk@volny.cz>

commit c86664e5a285af1afa06416e450e7c4af04daa7c upstream.

"AirLive X.USB now works perfectly under a Linux
environment!"

Signed-off-by: Christian Lamparter <chunkeey@googlemail.com>
Signed-off-by: John W. Linville <linville@tuxdriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/net/wireless/ath/carl9170/usb.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/wireless/ath/carl9170/usb.c
+++ b/drivers/net/wireless/ath/carl9170/usb.c
@@ -118,6 +118,8 @@ static struct usb_device_id carl9170_usb
 	{ USB_DEVICE(0x057c, 0x8402) },
 	/* Qwest/Actiontec 802AIN Wireless N USB Network Adapter */
 	{ USB_DEVICE(0x1668, 0x1200) },
+	/* Airlive X.USB a/b/g/n */
+	{ USB_DEVICE(0x1b75, 0x9170) },
 
 	/* terminate */
 	{}


