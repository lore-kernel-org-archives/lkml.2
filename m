Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756799Ab1BPATI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Feb 2011 19:19:08 -0500
Received: from kroah.org ([198.145.64.141]:38750 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab1BPAS6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Feb 2011 19:18:58 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Tue Feb 15 16:14:28 2011
Message-Id: <20110216001428.884578421@clark.kroah.org>
User-Agent: quilt/0.48-11.2
Date: Tue, 15 Feb 2011 16:11:35 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Axel Koellhofer <AxelKoellhofer@web.de>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: [038/272] staging: r8712u: Add new device IDs
In-Reply-To: <20110216001559.GA31413@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.37-stable review patch.  If anyone has any objections, please let us know.

------------------

From: =?UTF-8?q?Axel=20K=C3=B6llhofer?= <AxelKoellhofer@web.de>

commit 6b28405395f7ec492ea69f541cc774adcb9e00ca upstream.

This patch adds several new device ids to the r8712u staging driver.
The new ids were retrieved from latest vendor driver (v2.6.6.0.20101111)
downloadable from www.realtek.com.tw

Signed-off-by: Axel Koellhofer <AxelKoellhofer@web.de>
Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rtl8712/usb_intf.c |  145 ++++++++++++++++++++++++++++---------
 1 file changed, 113 insertions(+), 32 deletions(-)

--- a/drivers/staging/rtl8712/usb_intf.c
+++ b/drivers/staging/rtl8712/usb_intf.c
@@ -47,54 +47,123 @@ static int r871xu_drv_init(struct usb_in
 static void r871xu_dev_remove(struct usb_interface *pusb_intf);
 
 static struct usb_device_id rtl871x_usb_id_tbl[] = {
-	/*92SU
-	 * Realtek */
-	{USB_DEVICE(0x0bda, 0x8171)},
-	{USB_DEVICE(0x0bda, 0x8172)},
+
+/* RTL8188SU */
+	/* Realtek */
+	{USB_DEVICE(0x0BDA, 0x8171)},
 	{USB_DEVICE(0x0bda, 0x8173)},
-	{USB_DEVICE(0x0bda, 0x8174)},
 	{USB_DEVICE(0x0bda, 0x8712)},
 	{USB_DEVICE(0x0bda, 0x8713)},
 	{USB_DEVICE(0x0bda, 0xC512)},
-	/* Abocom  */
+	/* Abocom */
 	{USB_DEVICE(0x07B8, 0x8188)},
+	/* ASUS */
+	{USB_DEVICE(0x0B05, 0x1786)},
+	{USB_DEVICE(0x0B05, 0x1791)}, /* 11n mode disable */
+	/* Belkin */
+	{USB_DEVICE(0x050D, 0x945A)},
 	/* Corega */
-	{USB_DEVICE(0x07aa, 0x0047)},
-	/* Dlink */
-	{USB_DEVICE(0x07d1, 0x3303)},
-	{USB_DEVICE(0x07d1, 0x3302)},
-	{USB_DEVICE(0x07d1, 0x3300)},
-	/* Dlink for Skyworth */
-	{USB_DEVICE(0x14b2, 0x3300)},
-	{USB_DEVICE(0x14b2, 0x3301)},
-	{USB_DEVICE(0x14b2, 0x3302)},
+	{USB_DEVICE(0x07AA, 0x0047)},
+	/* D-Link */
+	{USB_DEVICE(0x2001, 0x3306)},
+	{USB_DEVICE(0x07D1, 0x3306)}, /* 11n mode disable */
+	/* Edimax */
+	{USB_DEVICE(0x7392, 0x7611)},
 	/* EnGenius */
 	{USB_DEVICE(0x1740, 0x9603)},
-	{USB_DEVICE(0x1740, 0x9605)},
+	/* Hawking */
+	{USB_DEVICE(0x0E66, 0x0016)},
+	/* Hercules */
+	{USB_DEVICE(0x06F8, 0xE034)},
+	{USB_DEVICE(0x06F8, 0xE032)},
+	/* Logitec */
+	{USB_DEVICE(0x0789, 0x0167)},
+	/* PCI */
+	{USB_DEVICE(0x2019, 0xAB28)},
+	{USB_DEVICE(0x2019, 0xED16)},
+	/* Sitecom */
+	{USB_DEVICE(0x0DF6, 0x0057)},
+	{USB_DEVICE(0x0DF6, 0x0045)},
+	{USB_DEVICE(0x0DF6, 0x0059)}, /* 11n mode disable */
+	{USB_DEVICE(0x0DF6, 0x004B)},
+	{USB_DEVICE(0x0DF6, 0x0063)},
+	/* Sweex */
+	{USB_DEVICE(0x177F, 0x0154)},
+	/* Thinkware */
+	{USB_DEVICE(0x0BDA, 0x5077)},
+	/* Toshiba */
+	{USB_DEVICE(0x1690, 0x0752)},
+	/* - */
+	{USB_DEVICE(0x20F4, 0x646B)},
+	{USB_DEVICE(0x083A, 0xC512)},
+
+/* RTL8191SU */
+	/* Realtek */
+	{USB_DEVICE(0x0BDA, 0x8172)},
+	/* Amigo */
+	{USB_DEVICE(0x0EB0, 0x9061)},
+	/* ASUS/EKB */
+	{USB_DEVICE(0x0BDA, 0x8172)},
+	{USB_DEVICE(0x13D3, 0x3323)},
+	{USB_DEVICE(0x13D3, 0x3311)}, /* 11n mode disable */
+	{USB_DEVICE(0x13D3, 0x3342)},
+	/* ASUS/EKBLenovo */
+	{USB_DEVICE(0x13D3, 0x3333)},
+	{USB_DEVICE(0x13D3, 0x3334)},
+	{USB_DEVICE(0x13D3, 0x3335)}, /* 11n mode disable */
+	{USB_DEVICE(0x13D3, 0x3336)}, /* 11n mode disable */
+	/* ASUS/Media BOX */
+	{USB_DEVICE(0x13D3, 0x3309)},
 	/* Belkin */
-	{USB_DEVICE(0x050d, 0x815F)},
-	{USB_DEVICE(0x050d, 0x945A)},
-	{USB_DEVICE(0x050d, 0x845A)},
-	/* Guillemot */
-	{USB_DEVICE(0x06f8, 0xe031)},
+	{USB_DEVICE(0x050D, 0x815F)},
+	/* D-Link */
+	{USB_DEVICE(0x07D1, 0x3302)},
+	{USB_DEVICE(0x07D1, 0x3300)},
+	{USB_DEVICE(0x07D1, 0x3303)},
 	/* Edimax */
-	{USB_DEVICE(0x7392, 0x7611)},
 	{USB_DEVICE(0x7392, 0x7612)},
-	{USB_DEVICE(0x7392, 0x7622)},
-	/* Sitecom */
-	{USB_DEVICE(0x0DF6, 0x0045)},
+	/* EnGenius */
+	{USB_DEVICE(0x1740, 0x9605)},
+	/* Guillemot */
+	{USB_DEVICE(0x06F8, 0xE031)},
 	/* Hawking */
 	{USB_DEVICE(0x0E66, 0x0015)},
-	{USB_DEVICE(0x0E66, 0x0016)},
-	{USB_DEVICE(0x0b05, 0x1786)},
-	{USB_DEVICE(0x0b05, 0x1791)},    /* 11n mode disable */
-
+	/* Mediao */
 	{USB_DEVICE(0x13D3, 0x3306)},
-	{USB_DEVICE(0x13D3, 0x3309)},
+	/* PCI */
+	{USB_DEVICE(0x2019, 0xED18)},
+	{USB_DEVICE(0x2019, 0x4901)},
+	/* Sitecom */
+	{USB_DEVICE(0x0DF6, 0x0058)},
+	{USB_DEVICE(0x0DF6, 0x0049)},
+	{USB_DEVICE(0x0DF6, 0x004C)},
+	{USB_DEVICE(0x0DF6, 0x0064)},
+	/* Skyworth */
+	{USB_DEVICE(0x14b2, 0x3300)},
+	{USB_DEVICE(0x14b2, 0x3301)},
+	{USB_DEVICE(0x14B2, 0x3302)},
+	/* - */
+	{USB_DEVICE(0x04F2, 0xAFF2)},
+	{USB_DEVICE(0x04F2, 0xAFF5)},
+	{USB_DEVICE(0x04F2, 0xAFF6)},
+	{USB_DEVICE(0x13D3, 0x3339)},
+	{USB_DEVICE(0x13D3, 0x3340)}, /* 11n mode disable */
+	{USB_DEVICE(0x13D3, 0x3341)}, /* 11n mode disable */
 	{USB_DEVICE(0x13D3, 0x3310)},
-	{USB_DEVICE(0x13D3, 0x3311)},    /* 11n mode disable */
 	{USB_DEVICE(0x13D3, 0x3325)},
-	{USB_DEVICE(0x083A, 0xC512)},
+
+/* RTL8192SU */
+	/* Realtek */
+	{USB_DEVICE(0x0BDA, 0x8174)},
+	{USB_DEVICE(0x0BDA, 0x8174)},
+	/* Belkin */
+	{USB_DEVICE(0x050D, 0x845A)},
+	/* Corega */
+	{USB_DEVICE(0x07AA, 0x0051)},
+	/* Edimax */
+	{USB_DEVICE(0x7392, 0x7622)},
+	/* NEC */
+	{USB_DEVICE(0x0409, 0x02B6)},
 	{}
 };
 
@@ -103,8 +172,20 @@ MODULE_DEVICE_TABLE(usb, rtl871x_usb_id_
 static struct specific_device_id specific_device_id_tbl[] = {
 	{.idVendor = 0x0b05, .idProduct = 0x1791,
 		 .flags = SPEC_DEV_ID_DISABLE_HT},
+	{.idVendor = 0x0df6, .idProduct = 0x0059,
+		 .flags = SPEC_DEV_ID_DISABLE_HT},
+	{.idVendor = 0x13d3, .idProduct = 0x3306,
+		 .flags = SPEC_DEV_ID_DISABLE_HT},
 	{.idVendor = 0x13D3, .idProduct = 0x3311,
 		 .flags = SPEC_DEV_ID_DISABLE_HT},
+	{.idVendor = 0x13d3, .idProduct = 0x3335,
+		 .flags = SPEC_DEV_ID_DISABLE_HT},
+	{.idVendor = 0x13d3, .idProduct = 0x3336,
+		 .flags = SPEC_DEV_ID_DISABLE_HT},
+	{.idVendor = 0x13d3, .idProduct = 0x3340,
+		 .flags = SPEC_DEV_ID_DISABLE_HT},
+	{.idVendor = 0x13d3, .idProduct = 0x3341,
+		 .flags = SPEC_DEV_ID_DISABLE_HT},
 	{}
 };
 


