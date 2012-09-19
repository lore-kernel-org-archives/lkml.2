Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab2ISAV2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 20:21:28 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:46781 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab2ISAVY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 20:21:24 -0400
Date: Tue, 18 Sep 2012 21:21:15 -0300
From: Gustavo Padovan <gustavo@padovan.org>
To: linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: pull request: bluetooth 2012-09-18
Message-ID: <20120919002115.GE24689@joana>
Mail-Followup-To: Gustavo Padovan <gustavo@padovan.org>,
	linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	linux-bluetooth@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20120919001143.GD24689@joana>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="W/nzBZO5zC0uMSeA"
Content-Disposition: inline
In-Reply-To: <20120919001143.GD24689@joana>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--W/nzBZO5zC0uMSeA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Forgot to sign this..

* Gustavo Padovan <gustavo@padovan.org> [2012-09-18 21:11:43 -0300]:

> Hi John,
>=20
> Here goes probably my last update to 3.6. It includes the two patches you
> were ok last week(from Andrzej Kaczmarek), those are critical ones, and t=
wo
> other fixes one for a system crash and the other for a missing lockdep
> annotation.
>=20
> Please pull or let me know of any problems!
>=20
> 	Gustavo
>=20
> ---
> The following changes since commit e020a83d0942a5aceac35986500c9834efc870=
7d:
>=20
>   brcmfmac: Fix big endian host configuration data. (2012-09-12 14:15:31 =
-0400)
>=20
> are available in the git repository at:
>=20
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth master
>=20
> for you to fetch changes up to 78c04c0bf52360dc2f7185e99c8e9aa05d73ae5a:
>=20
>   Bluetooth: Fix not removing power_off delayed work (2012-09-18 20:13:02=
 -0300)
>=20
> ----------------------------------------------------------------
> Andrei Emeltchenko (1):
>       Bluetooth: Fix freeing uninitialized delayed works
>=20
> Andrzej Kaczmarek (2):
>       Bluetooth: mgmt: Fix enabling SSP while powered off
>       Bluetooth: mgmt: Fix enabling LE while powered off
>=20
> Vinicius Costa Gomes (1):
>       Bluetooth: Fix not removing power_off delayed work
>=20
>  net/bluetooth/hci_core.c   |  2 ++
>  net/bluetooth/l2cap_core.c |  2 +-
>  net/bluetooth/mgmt.c       | 16 ++++++++++++++++
>  3 files changed, 19 insertions(+), 1 deletion(-)
>=20

	Gustavo

--W/nzBZO5zC0uMSeA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQWQ/7AAoJEPs3PUX4s20oqtMP/AqoZSXYo3bXB1NOH63yMd4E
Uh0a/MaDQQgXU+eDP5ngswVPiohO8VXiII5nEozj5mZdcG9z3sW1C5yQjoqtH4Mz
44AcjYl7JAU9kg71dbxoSb2+6LK5dJljJZwAn+G/UStG7ORaya3LLnj0+nUVUwCu
/5oC4qRYuDNcf7vi/e/l4qFFGC2Ml9u4fWOS4O9M2dgk+X89QNWPGBrolbcyuVXS
A/VpYJIGJr8FAY69PVgJ/9ws4Owbi+EkmG0mqC1T7mQohgOR8vOcoiP8v+oWhnt+
JRvNmty8XiA7f+4crxFe94xrYpIwnqwMo776b/Z4kMTdf6c0qd9DUFNBzYNFZDiP
jNDMOgDAkuTMPem+jdITr8NHhCAdBIhBhUn1fQGhrFSSrE4BgfjJscmUNodjhIuh
8XN4urKA4E/wlL4LVw/U6HoKCbvPHcF1BevfNUkfdFAxuvS71PxGc6fcQ4TD0vzC
kPSb9j6YwrGhCKfUaFjcX72jy0QKYVqCgoZYhkul1DBJ9V+2puSi3vJZ51vjbxXE
d792NMtKfEEIYYGQvOqFoHVFPvPITKq185hfdbh5lh0OoZBUF2QVT/GBWhuHMmmY
J9yDVXolsPKg4twdRtsEtsQJ30pV5SUfeGKfZh5sXCtOlEtaEKCgNUnm9Jqx5EPB
ZD47mZm/E4c0XzAjj2QX
=oRie
-----END PGP SIGNATURE-----

--W/nzBZO5zC0uMSeA--
