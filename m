Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab1LETEc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:04:32 -0500
Received: from oproxy3-pub.bluehost.com ([69.89.21.8]:36694 "HELO
	oproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932118Ab1LETEb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:04:31 -0500
Date: Mon, 5 Dec 2011 11:07:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Zac Storer <zac.3.14159@gmail.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 31/31] Drivers: pci: probe: fixed a brace coding style
 issue
Message-ID: <20111205110705.401d2a3d@jbarnes-desktop>
In-Reply-To: <1321596469-11180-1-git-send-email-zac.3.14159@gmail.com>
References: <1321596469-11180-1-git-send-email-zac.3.14159@gmail.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/re/KzJCa2Ix0E0ySXS_hXcF"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/re/KzJCa2Ix0E0ySXS_hXcF
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Nov 2011 23:07:49 -0700
Zac Storer <zac.3.14159@gmail.com> wrote:

> Fixed a brace coding style issue.
>=20
> Signed-off-by: Zac Storer <zac.3.14159@gmail.com>
> ---
>  drivers/pci/probe.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/drivers/pci/probe.c b/drivers/pci/probe.c
> index 04e74f4..d5d0ab8 100644
> --- a/drivers/pci/probe.c
> +++ b/drivers/pci/probe.c
> @@ -1534,7 +1534,7 @@ struct pci_bus * pci_create_bus(struct device *pare=
nt,
>  		return NULL;
> =20
>  	dev =3D kzalloc(sizeof(*dev), GFP_KERNEL);
> -	if (!dev){
> +	if (!dev) {
>  		kfree(b);
>  		return NULL;
>  	}

Applied to linux-next, thanks.  Would be even better if you found a
32/31 with an actual bug fix in it though. :)

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/re/KzJCa2Ix0E0ySXS_hXcF
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RZZAAoJEIEoDkX4Qk9hozMP/R29rgIfQ/yR+Hl7FIBP+uT0
xrDxP5xa0afQUlngs8+MIJjOZ8YlbENvqkXaIONDmdxPQa7KeCZitT0xrTKa8BCs
uC2iS2IoZkU3AqAD33bhEMIwzV0Nu7XKM1yvs3t1WOOI2PWIUM935/U2lOmVkoI5
D1GMndVziWJMenH/hPfUdw/KUPL60l/uYs642UidT1ifnn45D9XHsLOAi1W03LVT
IGCe08erqjbOMwQTZx836dVsdB4o5ZSKanHsYrE15lyokZvMx7pOxzXaRzQVO/iq
G5dwDIznxBGGDDogNi1fnL38QyrdULBIx6fMNc6M64PmV+tY8vsSJkoIQ2CFuXF+
sBY7+iTnbnxNFU9Ckx4VY2Hh8l2gK9KAIUMtdcA3UNfChcYZvyRllhUsYN/CBy89
MagSB3OsKtZRwGztm3z5/EhnRhcgsmiaY63XV4ZJ4/5ymk4S9cuahvjouRIsNWGz
Y3QtvWkZn+wETRslvTrd5QhnMdZMEIskZ0rmbuW6aZeQG6VPShAkzxpKdKSKV3/l
y8XzRrxaSFgIxvwEpzrFuDAz+z1oLsKxtJHWUmv6pdL5bG/RN6D2Uo4taa/VPvkM
ScGtemmFjTU7+LMDOmChV6oWM53hBRAAuXnE98yPK4O6S0rsxy5h19/Yw9p6AB1v
CKz5W1yhG//8p9MGa3LH
=7iAe
-----END PGP SIGNATURE-----

--Sig_/re/KzJCa2Ix0E0ySXS_hXcF--
