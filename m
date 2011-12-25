Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753431Ab1LYX4M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Dec 2011 18:56:12 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:56930 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751042Ab1LYX4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Dec 2011 18:56:06 -0500
Date: Mon, 26 Dec 2011 10:55:53 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: sedat.dilek@gmail.com
Cc: Sedat Dilek <sedat.dilek@googlemail.com>,
        linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: linux-next: Tree for Dec 21
Message-Id: <20111226105553.fa2d0a56eeed088a4c4f58cb@canb.auug.org.au>
In-Reply-To: <CA+icZUWYC1kYf19Zw1Jg2onAOpj3P4pRVt5h6HJp5RxuowTXZw@mail.gmail.com>
References: <20111221174733.9ba0861e762e8d96844b060b@canb.auug.org.au>
	<CA+icZUWYC1kYf19Zw1Jg2onAOpj3P4pRVt5h6HJp5RxuowTXZw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Dec_2011_10_55_53_+1100_KRcEnnd00INPGHpU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Dec_2011_10_55_53_+1100_KRcEnnd00INPGHpU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Sedat,

On Sun, 25 Dec 2011 17:08:24 +0100 Sedat Dilek <sedat.dilek@googlemail.com>=
 wrote:
>
> [ CC mjg59 ]
>=20
> What happened to drivers-x86 listed in [1]?
>=20
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/mjg59/platform-=
drivers-x86
> Cloning into 'platform-drivers-x86'...
> fatal: The remote end hung up unexpectedly

It is just one of many trees that have not been resurrected on kernel.org
yet since the rebuild.  The version I have (from the last time it was
fetchable) contains nothing.

Matthew, is it ever coming back?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Dec_2011_10_55_53_+1100_KRcEnnd00INPGHpU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO97gJAAoJEECxmPOUX5FEzYwQAKPFbPJiAYlMfxA3bX0OCk1/
ZmTamYdYjtraXzAB1VoH9Mj4JwuNy/JBQLb141tQvk9eUMZZCDhZO4VDKJrRZSIt
JiYrdwOehjvLOA+vyxihJU/0F093F4lQcMgsfOq75tcPvaDiyd8Q0XEV3Db3XDpJ
mCttWg47BvSNQkQtPJL8HFWIES9xkqdKvxDUiYDVElmAI6NnP1oYtf5VvhfrVTmH
msHm+sven/Lfqc6K0bM8hRadmWFccyLtmjya7zlfg6CxPLDvwhtY+3Cm0EA1xTd5
flkdTtrSkQL16V6isiycqS0f0EiEdBf0/kiQr9/fMRaOMqOWQ7XCaaQUcLoIkqmg
QRVNyN6bj/2Z7yyUCPVJMp4Wfbme2iy/O6Uh970EcgDLbAKC2F0UriVMzl6Fhj07
nEonNXUXJ4Tq5GLnQ7q/xBZOrrxfVaHN2pMe3JEtPN1y5BFGyymxmeD3bdICYe9W
BjMiv0HFiQWIf6KINjORIFObmmvIa4TBh5Mu/OWwygXtjxRXEoXeMePPp2e6pKHu
TmCM3dDxHQC2mpunHCDSWmg2bTfeqSJ6YA4zyVj9KD/yhfF9oD9FwVB3fqVbhw9V
1iUoRKcOwVmYz6vycjVNNFb/7Mud0y97Q+bSzZ2qQe8W63hMGpnD3t9VscTHibQb
yF+mA1U27o8CmGkY7QEt
=hstO
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Dec_2011_10_55_53_+1100_KRcEnnd00INPGHpU--
