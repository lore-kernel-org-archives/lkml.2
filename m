Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753859Ab0GAXh6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:37:58 -0400
Received: from doppler.zen.co.uk ([212.23.3.27]:51400 "EHLO doppler.zen.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750875Ab0GAXh4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:37:56 -0400
X-Greylist: delayed 13660 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Jul 2010 19:37:56 EDT
From: "Andrew Bird (Sphere Systems)" <ajb@spheresystems.co.uk>
Organization: Sphere Systems Ltd
To: gregkh@suse.de
Subject: New PIDs for Qualcomm gobi 2000 (qcserial)
Date: Thu, 1 Jul 2010 20:50:07 +0100
User-Agent: KMail/1.13.3 (Linux/2.6.30.10-105.2.23.fc11.x86_64; KDE/4.4.3; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_wFPLMlAH2/VcRQx"
Message-Id: <201007012050.08881.ajb@spheresystems.co.uk>
X-Originating-Smarthost03-IP: [82.71.70.22]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Boundary-00=_wFPLMlAH2/VcRQx
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

Hi Greg,
	Attached is a patch to add a new pair of pids for the qcserial driver. It 
adds support for the Qualcomm generic GOBI 2000 WWAN UMTS/CDMA modem. I wonder 
if it's possible to squeeze into 2.6.35? I've successfully tested this against 
2.6.35rc3 with the gobi_loader program 0.5, the patch is against Linus' 
current git.


Thanks,


Andrew

--Boundary-00=_wFPLMlAH2/VcRQx
Content-Type: text/x-patch;
  charset="UTF-8";
  name="0001-Add-new-pair-of-PIDs-to-qcserial-gobi-driver.patch"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
	filename="0001-Add-new-pair-of-PIDs-to-qcserial-gobi-driver.patch"

=46rom ea89f1b22b450560da78c36ab9e5027d97729b9b Mon Sep 17 00:00:00 2001
=46rom: Andrew Bird <ajb@spheresytems.co.uk>
Date: Thu, 1 Jul 2010 20:35:16 +0100
Subject: [PATCH] Add new pair of PIDs to qcserial gobi driver

Adds support for the Generic Qualcomm Gobi 2000 WWAN UMTS/CDMA modem

Signed-off-by: Andrew Bird <ajb@spheresytems.co.uk>
=2D--
 drivers/usb/serial/qcserial.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/serial/qcserial.c b/drivers/usb/serial/qcserial.c
index 93d72eb..cde67ca 100644
=2D-- a/drivers/usb/serial/qcserial.c
+++ b/drivers/usb/serial/qcserial.c
@@ -51,6 +51,8 @@ static const struct usb_device_id id_table[] =3D {
 	{USB_DEVICE(0x1f45, 0x0001)},	/* Unknown Gobi QDL device */
 	{USB_DEVICE(0x413c, 0x8185)},	/* Dell Gobi 2000 QDL device (N0218, VU936)=
 */
 	{USB_DEVICE(0x413c, 0x8186)},	/* Dell Gobi 2000 Modem device (N0218, VU93=
6) */
+	{USB_DEVICE(0x05c6, 0x9208)},	/* Generic Gobi 2000 QDL device */
+	{USB_DEVICE(0x05c6, 0x920b)},	/* Generic Gobi 2000 Modem device */
 	{USB_DEVICE(0x05c6, 0x9224)},	/* Sony Gobi 2000 QDL device (N0279, VU730)=
 */
 	{USB_DEVICE(0x05c6, 0x9225)},	/* Sony Gobi 2000 Modem device (N0279, VU73=
0) */
 	{USB_DEVICE(0x05c6, 0x9244)},	/* Samsung Gobi 2000 QDL device (VL176) */
=2D-=20
1.6.2.5


--Boundary-00=_wFPLMlAH2/VcRQx--
