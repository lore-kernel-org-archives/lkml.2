Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752843Ab0ELJac (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 05:30:32 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:41882 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab0ELJab (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 05:30:31 -0400
Date: Wed, 12 May 2010 11:30:15 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: "Arce, Abraham" <x0066660@ti.com>
Cc: "trivial@kernel.org" <trivial@kernel.org>,
       "khali@linux-fr.org" <khali@linux-fr.org>,
       "greg@kroah.com" <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/3] EEPROM: Header file cleanup
Message-ID: <20100512093015.GE13984@pengutronix.de>
References: <27F9C60D11D683428E133F85D2BB4A53043DFD5808@dlee03.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="y2zxS2PfCDLh6JVG"
Content-Disposition: inline
In-Reply-To: <27F9C60D11D683428E133F85D2BB4A53043DFD5808@dlee03.ent.ti.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--y2zxS2PfCDLh6JVG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 11, 2010 at 01:08:15PM -0500, Arce, Abraham wrote:
> Change eeprom.c header file to format as in conventions
>=20
> Signed-off-by: Abraham Arce <x0066660@ti.com>
> ---
>  drivers/misc/eeprom/eeprom.c |   40 ++++++++++++++++++++----------------=
----
>  1 files changed, 20 insertions(+), 20 deletions(-)
>=20
> diff --git a/drivers/misc/eeprom/eeprom.c b/drivers/misc/eeprom/eeprom.c
> index f939ebc..fffa2e8 100644
> --- a/drivers/misc/eeprom/eeprom.c
> +++ b/drivers/misc/eeprom/eeprom.c
> @@ -1,24 +1,24 @@
>  /*
> -    Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
> -			       Philip Edelbrock <phil@netroedge.com>
> -    Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
> -    Copyright (C) 2003 IBM Corp.
> -    Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
> -
> -    This program is free software; you can redistribute it and/or modify
> -    it under the terms of the GNU General Public License as published by
> -    the Free Software Foundation; either version 2 of the License, or
> -    (at your option) any later version.
> -
> -    This program is distributed in the hope that it will be useful,
> -    but WITHOUT ANY WARRANTY; without even the implied warranty of
> -    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> -    GNU General Public License for more details.
> -
> -    You should have received a copy of the GNU General Public License
> -    along with this program; if not, write to the Free Software
> -    Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> -*/
> + * Copyright (C) 1998, 1999  Frodo Looijaard <frodol@dds.nl> and
> + *                           Philip Edelbrock <phil@netroedge.com>
> + * Copyright (C) 2003 Greg Kroah-Hartman <greg@kroah.com>
> + * Copyright (C) 2003 IBM Corp.
> + * Copyright (C) 2004 Jean Delvare <khali@linux-fr.org>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> + */

If you are touching this anyhow, could you also update the address of the F=
SF?
(or maybe remove the address block if the original authors are fine with it=
).
Same for patch 2.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--y2zxS2PfCDLh6JVG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkvqdScACgkQD27XaX1/VRu2BQCgop4at6wiRxIpVBjKrFWiSxIt
S5EAoJRMuTAsw2vDRtVAlpKDKr0QGPhA
=g1zf
-----END PGP SIGNATURE-----

--y2zxS2PfCDLh6JVG--
