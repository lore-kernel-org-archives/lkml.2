Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752495Ab2H3WHM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Aug 2012 18:07:12 -0400
Received: from quickstop.soohrt.org ([85.131.246.152]:54158 "EHLO
	quickstop.soohrt.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558Ab2H3WHK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Aug 2012 18:07:10 -0400
Date: Fri, 31 Aug 2012 00:00:28 +0200
From: Horst Schirmeier <horst@schirmeier.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, jhovold@gmail.com
Cc: USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: [PATCH] ftdi_sio: PID for NZR SEM 16+ USB
Message-ID: <20120830220026.GS5326@quickstop.soohrt.org>
Mail-Followup-To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	jhovold@gmail.com, USB list <linux-usb@vger.kernel.org>,
	Kernel development list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EkxpYdHiqGHPYbUt"
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--EkxpYdHiqGHPYbUt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

This adds the USB PID for the NZR SEM 16+ USB energy monitor device
<http://www.nzr.de>.  It works perfectly with the GPL software on
<http://schou.dk/linux/sparometer/>.

Signed-off-by: Horst Schirmeier <horst@schirmeier.com>

---
 drivers/usb/serial/ftdi_sio.c     |    1 +
 drivers/usb/serial/ftdi_sio_ids.h |    3 +++
 2 files changed, 4 insertions(+)
diff --git a/drivers/usb/serial/ftdi_sio.c b/drivers/usb/serial/ftdi_sio.c
index 5620db6..5cae2a1 100644
--- a/drivers/usb/serial/ftdi_sio.c
+++ b/drivers/usb/serial/ftdi_sio.c
@@ -704,6 +704,7 @@ static struct usb_device_id id_table_combined [] =3D {
 	{ USB_DEVICE(FTDI_VID, FTDI_PCDJ_DAC2_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_RRCIRKITS_LOCOBUFFER_PID) },
 	{ USB_DEVICE(FTDI_VID, FTDI_ASK_RDR400_PID) },
+	{ USB_DEVICE(FTDI_VID, FTDI_NZR_SEM_USB_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_1_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_OPC_U_UC_PID) },
 	{ USB_DEVICE(ICOM_VID, ICOM_ID_RP2C1_PID) },
diff --git a/drivers/usb/serial/ftdi_sio_ids.h b/drivers/usb/serial/ftdi_si=
o_ids.h
index 5dd96ca..117f42b 100644
--- a/drivers/usb/serial/ftdi_sio_ids.h
+++ b/drivers/usb/serial/ftdi_sio_ids.h
@@ -75,6 +75,9 @@
 #define FTDI_OPENDCC_GATEWAY_PID	0xBFDB
 #define FTDI_OPENDCC_GBM_PID	0xBFDC
=20
+/* NZR SEM 16+ USB (http://www.nzr.de) */
+#define FTDI_NZR_SEM_USB_PID	0xC1E0	/* NZR SEM-LOG16+ */
+
 /*
  * RR-CirKits LocoBuffer USB (http://www.rr-cirkits.com)
  */

--=20
PGP-Key 0xD40E0E7A

--EkxpYdHiqGHPYbUt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAlA/4noACgkQB6mkGNQODnpC7wCg7MCY5LRtZDYktcOqKU++zYy6
vE0AnjYgs0OtdfNo+sMF47qvDyd7QSoQ
=CVzV
-----END PGP SIGNATURE-----

--EkxpYdHiqGHPYbUt--
