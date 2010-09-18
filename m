Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756733Ab0IRTgd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Sep 2010 15:36:33 -0400
Received: from kroah.org ([198.145.64.141]:43259 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756697Ab0IRTO4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Sep 2010 15:14:56 -0400
X-Mailbox-Line: From gregkh@clark.site Sat Sep 18 12:12:59 2010
Message-Id: <20100918191259.399850955@clark.site>
User-Agent: quilt/0.48-11.2
Date: Sat, 18 Sep 2010 12:12:03 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [025/129] Staging: rt2870sta: Add more device IDs from vendor drivers
In-Reply-To: <20100918191317.GA11386@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2.6.35-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Ben Hutchings <ben@decadent.org.uk>

commit 9e693e4375689cb1cd1529aba011de0044f74ef5 upstream.

Taken from DPO_RT3070_LinuxSTA_V2.3.0.4_20100604.tar.bz2 and
2010_0709_RT2870_Linux_STA_v2.4.0.1.tar.bz2, with duplicates removed.

Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/staging/rt2860/usb_main_dev.c |   41 ++++++++++++++++++++++++++++++++--
 1 file changed, 39 insertions(+), 2 deletions(-)

--- a/drivers/staging/rt2860/usb_main_dev.c
+++ b/drivers/staging/rt2860/usb_main_dev.c
@@ -44,6 +44,7 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x07B8, 0x2870)},	/* AboCom */
 	{USB_DEVICE(0x07B8, 0x2770)},	/* AboCom */
 	{USB_DEVICE(0x0DF6, 0x0039)},	/* Sitecom 2770 */
+	{USB_DEVICE(0x0DF6, 0x003F)},	/* Sitecom 2770 */
 	{USB_DEVICE(0x083A, 0x7512)},	/* Arcadyan 2770 */
 	{USB_DEVICE(0x0789, 0x0162)},	/* Logitec 2870 */
 	{USB_DEVICE(0x0789, 0x0163)},	/* Logitec 2870 */
@@ -95,7 +96,8 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x050d, 0x815c)},
 	{USB_DEVICE(0x1482, 0x3C09)},	/* Abocom */
 	{USB_DEVICE(0x14B2, 0x3C09)},	/* Alpha */
-	{USB_DEVICE(0x04E8, 0x2018)},	/* samsung */
+	{USB_DEVICE(0x04E8, 0x2018)},	/* samsung linkstick2 */
+	{USB_DEVICE(0x1690, 0x0740)},	/* Askey */
 	{USB_DEVICE(0x5A57, 0x0280)},	/* Zinwell */
 	{USB_DEVICE(0x5A57, 0x0282)},	/* Zinwell */
 	{USB_DEVICE(0x7392, 0x7718)},
@@ -105,21 +107,34 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x1737, 0x0071)},	/* Linksys WUSB600N */
 	{USB_DEVICE(0x0411, 0x00e8)},	/* Buffalo WLI-UC-G300N */
 	{USB_DEVICE(0x050d, 0x815c)},	/* Belkin F5D8053 */
+	{USB_DEVICE(0x100D, 0x9031)},	/* Motorola 2770 */
 #endif /* RT2870 // */
 #ifdef RT3070
 	{USB_DEVICE(0x148F, 0x3070)},	/* Ralink 3070 */
 	{USB_DEVICE(0x148F, 0x3071)},	/* Ralink 3071 */
 	{USB_DEVICE(0x148F, 0x3072)},	/* Ralink 3072 */
 	{USB_DEVICE(0x0DB0, 0x3820)},	/* Ralink 3070 */
+	{USB_DEVICE(0x0DB0, 0x871C)},	/* Ralink 3070 */
+	{USB_DEVICE(0x0DB0, 0x822C)},	/* Ralink 3070 */
+	{USB_DEVICE(0x0DB0, 0x871B)},	/* Ralink 3070 */
+	{USB_DEVICE(0x0DB0, 0x822B)},	/* Ralink 3070 */
 	{USB_DEVICE(0x0DF6, 0x003E)},	/* Sitecom 3070 */
 	{USB_DEVICE(0x0DF6, 0x0042)},	/* Sitecom 3072 */
+	{USB_DEVICE(0x0DF6, 0x0048)},	/* Sitecom 3070 */
+	{USB_DEVICE(0x0DF6, 0x0047)},	/* Sitecom 3071 */
 	{USB_DEVICE(0x14B2, 0x3C12)},	/* AL 3070 */
 	{USB_DEVICE(0x18C5, 0x0012)},	/* Corega 3070 */
 	{USB_DEVICE(0x083A, 0x7511)},	/* Arcadyan 3070 */
+	{USB_DEVICE(0x083A, 0xA701)},	/* SMC 3070 */
+	{USB_DEVICE(0x083A, 0xA702)},	/* SMC 3072 */
 	{USB_DEVICE(0x1740, 0x9703)},	/* EnGenius 3070 */
 	{USB_DEVICE(0x1740, 0x9705)},	/* EnGenius 3071 */
 	{USB_DEVICE(0x1740, 0x9706)},	/* EnGenius 3072 */
+	{USB_DEVICE(0x1740, 0x9707)},	/* EnGenius 3070 */
+	{USB_DEVICE(0x1740, 0x9708)},	/* EnGenius 3071 */
+	{USB_DEVICE(0x1740, 0x9709)},	/* EnGenius 3072 */
 	{USB_DEVICE(0x13D3, 0x3273)},	/* AzureWave 3070 */
+	{USB_DEVICE(0x13D3, 0x3305)},	/* AzureWave 3070*/
 	{USB_DEVICE(0x1044, 0x800D)},	/* Gigabyte GN-WB32L 3070 */
 	{USB_DEVICE(0x2019, 0xAB25)},	/* Planex Communications, Inc. RT3070 */
 	{USB_DEVICE(0x07B8, 0x3070)},	/* AboCom 3070 */
@@ -132,14 +147,36 @@ struct usb_device_id rtusb_usb_id[] = {
 	{USB_DEVICE(0x07D1, 0x3C0D)},	/* D-Link 3070 */
 	{USB_DEVICE(0x07D1, 0x3C0E)},	/* D-Link 3070 */
 	{USB_DEVICE(0x07D1, 0x3C0F)},	/* D-Link 3070 */
+	{USB_DEVICE(0x07D1, 0x3C16)},	/* D-Link 3070 */
+	{USB_DEVICE(0x07D1, 0x3C17)},	/* D-Link 8070 */
 	{USB_DEVICE(0x1D4D, 0x000C)},	/* Pegatron Corporation 3070 */
 	{USB_DEVICE(0x1D4D, 0x000E)},	/* Pegatron Corporation 3070 */
 	{USB_DEVICE(0x5A57, 0x5257)},	/* Zinwell 3070 */
 	{USB_DEVICE(0x5A57, 0x0283)},	/* Zinwell 3072 */
 	{USB_DEVICE(0x04BB, 0x0945)},	/* I-O DATA 3072 */
+	{USB_DEVICE(0x04BB, 0x0947)},	/* I-O DATA 3070 */
+	{USB_DEVICE(0x04BB, 0x0948)},	/* I-O DATA 3072 */
 	{USB_DEVICE(0x203D, 0x1480)},	/* Encore 3070 */
+	{USB_DEVICE(0x20B8, 0x8888)},	/* PARA INDUSTRIAL 3070 */
+	{USB_DEVICE(0x0B05, 0x1784)},	/* Asus 3072 */
+	{USB_DEVICE(0x203D, 0x14A9)},	/* Encore 3070*/
+	{USB_DEVICE(0x0DB0, 0x899A)},	/* MSI 3070*/
+	{USB_DEVICE(0x0DB0, 0x3870)},	/* MSI 3070*/
+	{USB_DEVICE(0x0DB0, 0x870A)},	/* MSI 3070*/
+	{USB_DEVICE(0x0DB0, 0x6899)},	/* MSI 3070 */
+	{USB_DEVICE(0x0DB0, 0x3822)},	/* MSI 3070 */
+	{USB_DEVICE(0x0DB0, 0x3871)},	/* MSI 3070 */
+	{USB_DEVICE(0x0DB0, 0x871A)},	/* MSI 3070 */
+	{USB_DEVICE(0x0DB0, 0x822A)},	/* MSI 3070 */
+	{USB_DEVICE(0x0DB0, 0x3821)},	/* Ralink 3070 */
+	{USB_DEVICE(0x0DB0, 0x821A)},	/* Ralink 3070 */
+	{USB_DEVICE(0x083A, 0xA703)},	/* IO-MAGIC */
+	{USB_DEVICE(0x13D3, 0x3307)},	/* Azurewave */
+	{USB_DEVICE(0x13D3, 0x3321)},	/* Azurewave */
+	{USB_DEVICE(0x07FA, 0x7712)},	/* Edimax */
+	{USB_DEVICE(0x0789, 0x0166)},	/* Edimax */
+	{USB_DEVICE(0x148F, 0x2070)},	/* Edimax */
 #endif /* RT3070 // */
-	{USB_DEVICE(0x0DF6, 0x003F)},	/* Sitecom WL-608 */
 	{USB_DEVICE(0x1737, 0x0077)},	/* Linksys WUSB54GC-EU v3 */
 	{USB_DEVICE(0x2001, 0x3C09)},	/* D-Link */
 	{USB_DEVICE(0x2001, 0x3C0A)},	/* D-Link 3072 */


