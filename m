Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753437Ab1GZOet (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 10:34:49 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:50242 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752491Ab1GZOem (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 10:34:42 -0400
Date: Tue, 26 Jul 2011 17:34:34 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com, kishon@ti.com
Subject: Re: [PATCH] mfd: omap-usb-host: fix clock API usage on
 usbhs_disable()
Message-ID: <20110726143433.GX32582@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1311340170-28773-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NAuYj0K7Umiq33rm"
Content-Disposition: inline
In-Reply-To: <1311340170-28773-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NAuYj0K7Umiq33rm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 22, 2011 at 06:39:30PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> usbhs_disable function was invoking clk_enable() instead of
> clk_disable(), thus only increasing the clock usage counter and
> preventing this particular clock from being ever turned off.
> Because of this, the power domain of omap4 the USB Host subsystem
> would never reach lower power states.This patch calls clk_disable()
> in usbhs_disable function
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

Samuel, I guess you can take this via MFD ?

--=20
balbi

--NAuYj0K7Umiq33rm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEbBAEBAgAGBQJOLtB5AAoJEAv8Txj19kN1f0YH+Pwg1oUbEOrPgDMMdlAJHC/Q
c76bwUVnnP6PF4JT8erfKcgAsHQWTtXn54J07l5DBfKjlhKCy8bvzzJZCD06N3Nr
oZu8oWbeZEgJX141F26cjniUzLOL8RwraIqxKW5JwxX1FcV93MG6ukW2lu7VsrkF
Ga8gO81XproFSCcRG8mnJmSHAfjW5HFTPFdcKYD5ePVD/csJlUAaMdVV+oLjcGH+
b0VKpq81SBeZfTCEyOuka+a3Z6Y6b22LRNKRrVA4L5jiC0y0MGQrMOdCgaKHKOtv
g4zv9mJcPg150HBWNiqkxN9+h4KL4yyWpGj8h12q+E/RgPt2xPuDYuBB4mrHGA==
=Fb9y
-----END PGP SIGNATURE-----

--NAuYj0K7Umiq33rm--
