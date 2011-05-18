Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab1ERKsT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:48:19 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:53342 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757101Ab1ERKsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:48:16 -0400
Date: Wed, 18 May 2011 13:48:09 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com
Subject: Re: [RESEND][PATCH 4/5] arm: omap: usb: Runtime PM support
Message-ID: <20110518104806.GB13908@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305538732-21087-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="R3G7APHDIzY6R/pk"
Content-Disposition: inline
In-Reply-To: <1305538732-21087-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--R3G7APHDIzY6R/pk
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2011 at 03:08:52PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> The usbhs core driver does not enable/disable the intefrace and
> fucntional clocks; These clocks are handled by hwmod and runtime pm,
> hence insted of the clock enable/disable, the runtime pm APIS are
> used. however,the port clocks and tll clocks are handled
> by the usbhs core.
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

Samuel how do we solve this series ? I can take the arch/arm/*omap*/
patches through Tony's tree, can you take the drivers/mfd/* via you
tree ?

--=20
balbi

--R3G7APHDIzY6R/pk
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN06PmAAoJEAv8Txj19kN1gZUH/jVzKJ6ekhJ+hYSTgRRcQ+bo
hRzW+WkjEQgibIJfO5lB7tRo+LdT5sAq6h8eDmBozu68M501BTatdEGjQrKxpCaJ
q+x1crAzum5m37rFunkIgYd9UBcdQo/yteQBhPKjED+eO5aSWIBCJUlJJ03OGBC+
mlr4LYenorZyvM4o1HENA8QrEbdgbEUegUgDn8cWqccbeFIIz7frBjh2e/O81FuZ
wd2+Ryv2znJtEsYTMKP7G6ndrAF7epfd23CItHzGSqUh/ghyPNAxUt6oiNxBzPpa
qewlDkoNjqXZ+x4OCHqqwUEkXFLyMQnc1ayhbQrmkhbnM+l+h1n3aZGKFnk4XRw=
=JI2p
-----END PGP SIGNATURE-----

--R3G7APHDIzY6R/pk--
