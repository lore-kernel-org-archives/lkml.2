Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752988Ab1JJIty (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 04:49:54 -0400
Received: from na3sys009aog123.obsmtp.com ([74.125.149.149]:55541 "EHLO
	na3sys009aog123.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752789Ab1JJItx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 04:49:53 -0400
Date: Mon, 10 Oct 2011 11:49:48 +0300
From: Felipe Balbi <balbi@ti.com>
To: Klaus Schwarzkopf <schwarzkopf@sensortherm.de>
Cc: balbi@ti.com, gregkh@suse.de, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, sshtylyov@ru.mvista.com
Subject: Re: [PATCH v3] usb: add new usb gadget for ACM and mass storage
Message-ID: <20111010084947.GD6685@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1315506287-31368-1-git-send-email-schwarzkopf@sensortherm.de>
 <1318059850-3336-1-git-send-email-schwarzkopf@sensortherm.de>
 <20111010055010.GC31653@legolas.emea.dhcp.ti.com>
 <4E92ADBD.2010404@sensortherm.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NklN7DEeGtkPCoo3"
Content-Disposition: inline
In-Reply-To: <4E92ADBD.2010404@sensortherm.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NklN7DEeGtkPCoo3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Oct 10, 2011 at 10:33:01AM +0200, Klaus Schwarzkopf wrote:
> >>+static struct usb_device_descriptor device_desc =3D {
> >>+	.bLength =3D		sizeof device_desc,
> >>+	.bDescriptorType =3D	USB_DT_DEVICE,
> >>+
> >>+	.bcdUSB =3D		cpu_to_le16(0x0200),
> >>+
> >>+	.bDeviceClass =3D		USB_CLASS_COMM,
> >>+	.bDeviceSubClass =3D	0,
> >>+	.bDeviceProtocol =3D	0,
>=20
> Should bDeviceClass, bDeviceSubClass, and bDeviceProtocol have the
> same value like in the file multi.c?
>=20
> 	.bDeviceClass =3D		USB_CLASS_MISC /* 0xEF */,
> 	.bDeviceSubClass =3D	2,
> 	.bDeviceProtocol =3D	1,

maybe, you gotta check CDC and MSC specs to find out.

--=20
balbi

--NklN7DEeGtkPCoo3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOkrGrAAoJEIaOsuA1yqREklEQAJjykB7h3azyRPoWtSMX32+4
De6R7TRhbF+pIa5i1qFuLnpkSrJZROROdmI/LM9a/suxSOq4SKc1hFvNPqWliWWl
L9+TUyYNaQsy5W9PBkyID8m0Ig4bCp/HKoBiOguTy3B7j47PwiiE6cB2kNASaR6u
T3FiTtlb8YcHyz6tYwrEQ6Ia+pfxJE1bCBx2Kho1ANRwAe6hKvfxr94MiNcRtXvz
mxXq3dyS9XBzvXKhTZtWrCI+mCQl2L2K53MLeJlQXYqG3QIFYMHY5j+mTiN+2aTt
8hz399n7VWPiR5ZXr8F/hwcaQhwpsCDqqrn3eCxVZa8t9LKqkZLYePJ1XdNn7bXF
nuov8bRlkr3iw8llxa0et19p45d6D1UQymVV7q4pic/j/ROv5/UMMwC06hEESLd5
7pwIbnWJY1mZFWd00Fxf8edcvAuuqiabsfV2YkGJAZv7xBzfYtJhtln0Ae9EwWhs
yBLCqwUnABBqj/huyqqOMWsoFZOD/40G1GeXUMHpQSiQ5AbJ77iRqJKZLwsq0sCX
zbaQ13sR0sBpJm5AGRLfluxnhfcEXbB5FhAfHEnktB3/5tJqiUej65sB4Dl2U0j/
zgsm5hpNHT9xN9EfFy7YW7clT443zpaElAYjOUt0xVIGWbvymETM2xkZP3dkBtWI
gisOT8frYbjP/sToDXOG
=uuhb
-----END PGP SIGNATURE-----

--NklN7DEeGtkPCoo3--
