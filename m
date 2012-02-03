Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753545Ab2BCHcz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 02:32:55 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:39840 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751153Ab2BCHcy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 02:32:54 -0500
Date: Fri, 3 Feb 2012 09:32:48 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 1/3 v2] pch_udc: Detecting VBUS through GPIO
Message-ID: <20120203073247.GD24297@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328254526-9447-1-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="at6+YcpfzWZg/htY"
Content-Disposition: inline
In-Reply-To: <1328254526-9447-1-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--at6+YcpfzWZg/htY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Feb 03, 2012 at 04:35:26PM +0900, Tomoya MORINAGA wrote:
> Problem:
>  In USB Suspend, pch_udc handles 'disconnect'.
>=20
> Root cause:
>  The current pch_udc is not monitoring VBUS.
>  When USB cable is disconnected, USB Device Controller generates
>  an interrupt of USB Suspend.
>  pch_udc cannot distinguish it is USB Suspend or disconnect.
>  Therefore, pch_udc handles 'disconnect' after an interrupt of
>  USB Suspend happend.
>=20
> Solution:
>  VBUS is detected through GPIO.
>  After an interrupt produced USB Suspend, if VBUS is Low,
>  pch_udc handles 'disconnect'.
>  If VBUS is High, pch_udc handles 'suspend'.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

Next time, please reply to the v1 of the patch. git send-email has this
--in-reply-to option which helps with that ;-)

--=20
balbi

--at6+YcpfzWZg/htY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPK42fAAoJEIaOsuA1yqRE2YMP/RhSxpTWUeigbgwoo+yTMvHC
NFjssbylyauRw4a1N8XGjn/necUF60PqVxwjZ0sy9GNdAe5Z0aOZX6LqSTe7P4Mo
n4hj+0M28PYd7LKUDcuLO0nu3R9trvTPmEPYb6ZjlPY6vKJFW5GhcCnVfhxNIyiP
5OWImlMtzsrN9oMQ37Mi8CFd6CpJmURSs+g7ZeCxV2KoDQMLsjwuyrx0QqZr9ELw
z5PQ2zmmviF4GdWQk7YLmth0ljd9EqJAM89F7+1d842uzKT+X+sy3y8T74uUiW+H
UNXphfTTKdmFotlOjKi8gzhT7w0QR5h3VgjzZedwaIDl1gnRmExQ5HVVRWcvrC6/
7xen6uBKFonMdrgQf94ICuPexN6zk1pRWCpubWBR6yLBN9ReftB+VlYZOe2NAH60
5Omw/17NHgPqtUB6qtAqY5Yf7Lz4eRgeO2qd07xJwj6JJFzPO5gmgdLjyFcaNxHk
6rzIMrbFq9QSLTpJdDH67411QiUvf0lltOOmLeryH5wfiVTv49in9dSpeOiVAOpx
VXmUYsiiQ2Ipa2jXXsEICN1BTlidQKhpMKQdSJNd7aBkObXcmicqJ3OKpk6WLiwb
oMq4T3+04LMp6sFRohOCxpHIFkHNqQiQFfbHcYDpRo2PT07beaRRhCYQ2BREmxGb
9Q2X3iBRzM/pHPl4r+hc
=V5se
-----END PGP SIGNATURE-----

--at6+YcpfzWZg/htY--
