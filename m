Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933543Ab1JEI0K (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 04:26:10 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37821 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab1JEI0I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 04:26:08 -0400
Date: Wed, 5 Oct 2011 19:26:01 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: rmody@brocade.com, netdev@vger.kernel.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        rdunlap@xenotime.net, huangj@brocade.com,
        adapter_linux_open_src_team@brocade.com
Subject: Re: [net-next 1/1] bna: Multiple Definition and Interface Setup Fix
Message-Id: <20111005192601.fa947a78b188f4a021042a5e@canb.auug.org.au>
In-Reply-To: <20111004.232713.1345786533613742751.davem@davemloft.net>
References: <1317781880-26515-1-git-send-email-rmody@brocade.com>
	<20111004.232713.1345786533613742751.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__5_Oct_2011_19_26_01_+1100_SQp.ZCGy9p2wn1mz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__5_Oct_2011_19_26_01_+1100_SQp.ZCGy9p2wn1mz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, 04 Oct 2011 23:27:13 -0400 (EDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Rasesh Mody <rmody@brocade.com>
> Date: Tue, 4 Oct 2011 19:31:20 -0700
>=20
> > drivers/net/built-in.o: In function `bfa_ioc_ct2_poweron':
> > (.text+0xcdc90): multiple definition of `bfa_ioc_ct2_poweron'
> > drivers/scsi/built-in.o:(.text+0x17f9a0): first defined here
> >=20
> > This patch renames bfa_ioc_ct2_poweron() to bfa_nw_ioc_ct2_poweron() to=
 avoid
> > multiple definition with Brocade scsi driver. It also modifies asic spe=
cific
> > interface setup to allocate MSIX resources at power on in case of 1860 =
HW with
> > no asic block and warns if the asic gen is neither BFI_ASIC_GEN_CT nor
> > BFI_ASIC_GEN_CT2.
> >=20
> > Reported-by: Randy Dunlap <rdunlap@xenotime.net>
> > Signed-off-by: Rasesh Mody <rmody@brocade.com>
>=20
> Applied, thanks.

I also manually applied this to linux-next today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__5_Oct_2011_19_26_01_+1100_SQp.ZCGy9p2wn1mz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjBSZAAoJEECxmPOUX5FEP3IP/R0Z9V/eP3U4G2DXmMzyzwsH
kcjAoSwVEikENiQbSRh4FnIapD9CkL8VqY0Vov5oP6KqOB7QtouaeR2fmXF/vwsH
WK6vpBfarrfFQw2Ye4CXsmKrJGOOyaHixROnQE4XKuM/KkB8TheqIC3EzDTHVeRX
aDpiCimIsBU7hjepy0gaAZ33/SHSUjqJqfoONBJGN082tMBDOae29MgOMlrM7esN
/czw3U5JIXzz9XiSJBySCBDq8WgurZzSwTKZHEyl1X6T10W9Np0k0B0SkkKMxAum
0o9+WrN7wwZVpb1OW3vKZsy5iQ3BtGpJ/GjlLvI3LJ2RRLXI25Ribt6WH/oC7Lu1
9W2SNS6gHrTyKqDiAE1w5r7dcxWyfr3XT+qZRvrMW8MYIdwj/mjDGi27iHuYh6P3
ebe6VBeEf5S5cZBKuwu1BGIhB3jZtZlTshJWyMcKIwnV2IRpR+ml2zoQyhw8Gei3
n4nm27CsIIzZdmbHyE/2Jn3OQkTIs77Ua6Dbzd3J1RF+uHoG/Excv7zmt8cludbV
7e+xBw7n3EHk1/ZqEAKSLElNX1BrG6PkUi5x/kdC6P5dG29TR0c4KrJVuJDysxhC
Pbdxf8aZ5ojqe/bXgqY8TyXWG8bPkjrV5V6rsY2YYh8mhnc3OWQBD7G9lrQvOXnm
F0dVhoLdh3UQm9G71UbZ
=1R/c
-----END PGP SIGNATURE-----

--Signature=_Wed__5_Oct_2011_19_26_01_+1100_SQp.ZCGy9p2wn1mz--
