Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932313Ab0FKLd6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 07:33:58 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:54203 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755797Ab0FKLd5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 07:33:57 -0400
Date: Fri, 11 Jun 2010 13:33:42 +0200
From: Luotao Fu <l.fu@pengutronix.de>
To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>
Cc: Luotao Fu <l.fu@pengutronix.de>, Samuel Ortiz <sameo@linux.intel.com>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] mfd: add STMPE811 core support
Message-ID: <20100611113342.GA4078@pengutronix.de>
Mail-Followup-To: Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
	Luotao Fu <l.fu@pengutronix.de>,
	Samuel Ortiz <sameo@linux.intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
References: <1276251195-22981-1-git-send-email-l.fu@pengutronix.de>
 <1276251195-22981-2-git-send-email-l.fu@pengutronix.de>
 <4C1217E9.80606@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UlVJffcvxoiEqYs2"
Content-Disposition: inline
In-Reply-To: <4C1217E9.80606@jic23.retrosnub.co.uk>
X-PGP-Key-ID: 0xE5325261
X-URL: http://www.pengutronix.de/
X-Sent-From: Pengutronix Hildesheim
X-IRC: #ptxdist @freenode
X-Accept-Language: de,en
X-Accept-Content-Type: text/plain
X-Uptime: 13:32:44 up  5:29, 12 users,  load average: 0.00, 0.00, 0.00
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:250:baff:feac:3723
X-SA-Exim-Mail-From: l.fu@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UlVJffcvxoiEqYs2
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Fri, Jun 11, 2010 at 12:03:05PM +0100, Jonathan Cameron wrote:
> On 06/11/10 11:13, Luotao Fu wrote:
>=20
> Hi couple of really minor comments inline.
>=20
> Looks good to me,
>=20
> Acked-by: Jonathan Cameron<jic23@cam.ac.uk>

Thanks for reviewing the code. Will fix the stuff you pointed out in V2.

cheers
Luotao Fu
--=20
Pengutronix e.K.                           | Dipl.-Ing. Luotao Fu        |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |

--UlVJffcvxoiEqYs2
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwSHxYACgkQkLuxfMCkDTZRJQCfRWtcL8ph+pIul68336ys2AeZ
7BkAn1282Z2y+u6Z7svpIdjnJ5vpzd98
=9JZ5
-----END PGP SIGNATURE-----

--UlVJffcvxoiEqYs2--
