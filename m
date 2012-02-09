Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756610Ab2BIH7j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 02:59:39 -0500
Received: from na3sys009aog103.obsmtp.com ([74.125.149.71]:43756 "EHLO
	na3sys009aog103.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751701Ab2BIH7i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 02:59:38 -0500
Date: Thu, 9 Feb 2012 09:59:34 +0200
From: Felipe Balbi <balbi@ti.com>
To: Tomoya MORINAGA <tomoya.rohm@gmail.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        qi.wang@intel.com, yong.y.wang@intel.com, joel.clark@intel.com,
        kok.howg.ewe@intel.com
Subject: Re: [PATCH 2/3] pch_udc: Detecting VBUS through GPIO with interrupt
Message-ID: <20120209075934.GM1121@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1328253259-9343-1-git-send-email-tomoya.rohm@gmail.com>
 <1328253259-9343-2-git-send-email-tomoya.rohm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="HxQt9wRz9wbL5Edg"
Content-Disposition: inline
In-Reply-To: <1328253259-9343-2-git-send-email-tomoya.rohm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--HxQt9wRz9wbL5Edg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 03, 2012 at 04:14:18PM +0900, Tomoya MORINAGA wrote:
> Problem:
>  pch_udc continues operation even if VBUS becomes Low.
>  pch_udc performs D+ pulling up before VBUS becomes High.
>  USB device should be controlled according to VBUS state.
>=20
> Root cause:
>  The current pch_udc is not always monitoring VBUS.
>=20
> Solution:
>  The change of VBUS is detected using an interrupt of GPIO.
>  If VBUS became Low, pch_udc handles 'disconnect'.
>  After VBUS became High, a pull improves D+, and pch_udc
>  handles 'connect'.
>=20
> Signed-off-by: Tomoya MORINAGA <tomoya.rohm@gmail.com>

applied my fixed version
thanks

--=20
balbi

--HxQt9wRz9wbL5Edg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPM3zlAAoJEIaOsuA1yqRE0V0QALIaKQYdY0gU/ygXHNS6QVDA
dMHwxaATqUs0Tx2NCsI6Ky6rAU77kpopR+Dp8qWIgm+5XGuobef/y3q3NDFd2SNU
3wru9eogImR9pm0IFuA/8H3f2AH4i9slpJ3tVdZDIDpQt1zkdu/naZE/qoO6iNVZ
m+6sv+5zu8QGKR8trapCm2T1OckYR6PpvvanX5qucgfLkmbOcn8sXiU/2a9fuBsc
uI+uPsCZCY0otGcNZXdLXAvcCvfFcpyTk9j8c5aXycw5JK5TQ4TdvlKj5UJiq2ks
HyVYUAHkEstibcsGOj32ZArY8ljuH9b8gPs3XfWH6O3dAb2DC8dCT/ELjX/R/zp7
MH/xut85ygoXMnvPDIY6UhG//DbF/Q/l1dmCRggcYeZoS0zmfFqHreP9tNIzFxXI
ZneURrZuAIyg4u/480oPS3HjWcpZzN+GtXuyWrrT0gZRPf2iBWEPnTkYcD4P65Fj
BITaBFlvK/+nnI7GWUq3hWwL/m9P9n+npt97nOgNMtt20WUCQnaXRZU4Z3pRwspZ
tVvLOPCYABB8/3kFdg3vs16eYe++DSWeZWi1hERFtDo6BUWYhBZMrU4ivRrQtAKO
8FL+3PELuZvjqR4nHgngyG72NqrMrN7zJ2+L6WbUlrF6AP8RXof5bhWYp7poijd+
AhvdZEqXhGjBGjILtr/a
=aQlK
-----END PGP SIGNATURE-----

--HxQt9wRz9wbL5Edg--
