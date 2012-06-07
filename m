Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759035Ab2FHAyy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:54:54 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:58672 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753744Ab2FHAyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:54:53 -0400
Date: Fri, 8 Jun 2012 07:29:12 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120607232911.GQ14525@opensource.wolfsonmicro.com>
References: <1339060101.5274.5.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jsrFa/5v3cIbBmG8"
Content-Disposition: inline
In-Reply-To: <1339060101.5274.5.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH RFC/RFT] regulator: palmas: Clear
 PALMAS_SMPS12_CTRL_MODE_ACTIVE_MASK bits in palmas_set_mode_smps
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jsrFa/5v3cIbBmG8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jun 07, 2012 at 05:08:21PM +0800, Axel Lin wrote:
> Current code actually clears more bits than PALMAS_SMPS12_CTRL_MODE_ACTIV=
E_MASK bits.
>=20

Applied, thanks.

--jsrFa/5v3cIbBmG8
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0Tk4AAoJEBus8iNuMP3dDhgP/Ri7mRfmcD6NfoasEe1mfjem
0rafMpRejtRByDC/yVGnY42M+ZW7d3b51hp1gV2xJlSzM1coK2nS7EmeCNUzmn3N
AHfOMQiFQmw7MNjD6+fqjcZk/AhYEtW+wX7T8tKMBzqW7KqDIgucH24Zo9inmXJ9
glj9KuP7xSIxHp+o3CETsEm+kvgTDbDYB7uOlr5O4n6LmF/SPuPbsOw1KxEl8a7J
s/mxjABith+q1FC7moFNB68GyVPtD+cXQYgVNr5DpAdoOYp296dbLZbjaWsD92TQ
P5NoHT9wV+kc+5PP92iDQuxZwT6ojFF998FfWGcL1soBv/WjyGmOdAdBzTRPNzul
P5G+60/XxQGsYZqoWR2Y/mgV20uybrPM6QKGxCbBFYer7cezTxIdPYy8w6KVIIZW
TMZKOiYk4fv65eqTm7/z+hAomNxt8bx4zJNC2b8y0sfkr15gOVdIUpRxo47YO/Eq
2cXnvbmjyAz5ufY4wbULdZ72QdOqZjl6fcPRXzyqna6s2vpPkqyOY/r36I/VOTvZ
xq822bgHURw/cPQsln+vnZDcXHufR5NbQTH9GQJZ0EJDANBnXUtxVVKE8aJZjKxn
zN3HCJwGt6d16ClXV/n368uWNxgsdvD+384+EC1h8bbk2a7KyqclnfmOou5f2h/B
PHAYfRYZUo7CZSxyX1rB
=M2a9
-----END PGP SIGNATURE-----

--jsrFa/5v3cIbBmG8--
