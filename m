Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753515Ab1FIJoB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 05:44:01 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:53976 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752247Ab1FIJn6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 05:43:58 -0400
Date: Thu, 9 Jun 2011 12:43:45 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tatyana Brokhman <tlinder@codeaurora.org>
Cc: greg@kroah.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        balbi@ti.com, ablay@codeaurora.org,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH/RESEND v15 1/10] usb: Add usb_endpoint_descriptor to be
 part of the struct usb_ep
Message-ID: <20110609094343.GB13552@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="N+dhEFW7Y2Uiel/w"
Content-Disposition: inline
In-Reply-To: <1307360469-29120-1-git-send-email-tlinder@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--N+dhEFW7Y2Uiel/w
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jun 06, 2011 at 02:40:45PM +0300, Tatyana Brokhman wrote:
> Change usb_ep_enable() prototype to use endpoint descriptor from usb_ep.
> This optimization spares the FDs from saving the endpoint chosen
> descriptor. This optimization is not full though. To fully exploit this
> change one needs to update all the UDCs as well since in the current
> implementation each of them saves the endpoint descriptor in it's
> internal (and extended) endpoint structure.
>=20
> Signed-off-by: Tatyana Brokhman <tlinder@codeaurora.org>

applied to gadget branch, thanks

--=20
balbi

--N+dhEFW7Y2Uiel/w
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8JXPAAoJEAv8Txj19kN1zLcIAIPDPldmu+WQ61blIKKqAQ2d
ZN+9ayxL+spSS5mKnwCIerbXzbt8HmPFqt0XzFnca0NAdijqv+3TZpOLh6fS4GnU
a1WXyC/vviNDZo0tHZzo8EYPazCIHqu+ubmPy3huiWzYMll/Ibbhlg++Hwgov968
1vjQ0CymetS7tM8krmzMPJwAjBM3Dgnc5DT5tBkKESiASJgxif1hMWrYu++fVivf
zzWlDnhpwiN3cuP9mwNky+72w8Az1X5NaoU7sTp6AYBQ/8FeTAWzUxOeH/RcXI+1
fz9kZY+DzuSeXHUsxu8u24TpPJVAUlKF4mpc3P+JPe4K8BUwRu014ey46nfpdDk=
=OQwF
-----END PGP SIGNATURE-----

--N+dhEFW7Y2Uiel/w--
