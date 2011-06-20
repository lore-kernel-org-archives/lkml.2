Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab1FTPPd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 11:15:33 -0400
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:59945 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751276Ab1FTPPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 11:15:31 -0400
Date: Mon, 20 Jun 2011 18:15:23 +0300
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Viliam Mateicka <viliam.mateicka@gmail.com>,
        Ben Dooks <ben-linux@fluff.org>, Kukjin Kim <kgene.kim@samsung.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] s3c2410_udc: fix custom UDC command handling
Message-ID: <20110620151522.GN14262@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <BANLkTimWM2oew2f9uWxoD1kw1=2bSYFFuw@mail.gmail.com>
 <Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="68uOmRXIw+u8y5pO"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106201105430.2113-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--68uOmRXIw+u8y5pO
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 20, 2011 at 11:07:51AM -0400, Alan Stern wrote:
> On Mon, 20 Jun 2011, Viliam Mateicka wrote:
>=20
> > So, will somebody at least react/reply (or just fix) ?
>=20
> Have some patience.  You did not address your email message to either
> of the driver's authors or to the current Gadget maintainer.  Also,
> David Brownell is deceased and Greg KH is on vacation.

besides, the patch formatting is wrong. That was noted before and the
reply was less than acceptably polite, so unless the patch comes
Perfect(TM), I'm not looking into it.

--=20
balbi

--68uOmRXIw+u8y5pO
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN/2QKAAoJEAv8Txj19kN1dW0H/jh8iZgkmf4RUli64aaGzLwP
nQCPSr20mFLE93c447v1o2Gs4XKU2SeUIbDSrTgvcNyPH2w6zzsplGKCLGPN5Ct7
9djpIBksFCnupxgNw7Mi+p18H/g0Dc7MFoyh4DT1HT5gU7w3aWXUKvjE37WqX2IK
2O5YUOR3LlZ0VogvRL1g89Xpd7gVZJA62L/BOATcD2h4BHmvBQZi9WWHWvhVMIWU
VXR3FEXLuDeET5Ir5x0vgLuWxk2W4SfIMO66/udkmXmzuQx2UWAsfhHgdbsBfmYu
+nMUk8LGVprErtFQ2QjJ2KT5/gAT+flm+Oq9YjbBlEt5Z5l9xSIPhx0Irnm0Qac=
=IyPU
-----END PGP SIGNATURE-----

--68uOmRXIw+u8y5pO--
