Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1LUAn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 19:43:56 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:44644 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753691Ab1LUAnw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 19:43:52 -0500
Date: Wed, 21 Dec 2011 11:43:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Theodore Ts'o" <tytso@mit.edu>
Subject: Re: linux-next: manual merge of the vfs tree with the ext4 tree
Message-Id: <20111221114344.dbe58177e02e83e572811e9e@canb.auug.org.au>
In-Reply-To: <20111221111801.75611ea16ad03f68e9856bd2@canb.auug.org.au>
References: <20111221111801.75611ea16ad03f68e9856bd2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__21_Dec_2011_11_43_44_+1100_WVVW.i5CZYVfz=UK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__21_Dec_2011_11_43_44_+1100_WVVW.i5CZYVfz=UK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

On Wed, 21 Dec 2011 11:18:01 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the vfs tree got a conflict in
> fs/ext4/ioctl.c between commit 5e8af306ef80 ("ext4: fix potential
> deadlock with setuid files and EXT4_IOC_MOVE_EXT") from theext4  tree and
> commit 99b4f71273d9 ("vfs: mnt_drop_write_file()") from the vfs tree.
>=20
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

Of course, the build still failed (see yesterday's report) :-(
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__21_Dec_2011_11_43_44_+1100_WVVW.i5CZYVfz=UK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO8SvAAAoJEECxmPOUX5FEv5sP/0qB8wU813ARFqGspoA39kkn
H7aAhD19IyjyzgC3+uDjk1g0QtxhfFi2vfk3noGNewYbERKBNqt9KOUC1ovPCYAx
GnooTiTTvbnM7rGPi76AxsKazvGqqH/uuuPat6ood1Pz80k3etKiJzqdRcc1uV43
ot9M+9mmNqThWJA4aZ7W/VMACBFbe40jcdhBZb9TTWs8mI/YS9bKr02RrgiQEhxT
fvLLRGUOtM5xrdu9KkGclvWCFe028LTP6wP/WzFk//12cXzn3mr75XBWU+UdUUt1
qWhVn2s04dVN51AfaypFnwjjs2FLAgqM8dZEu+IwCZLycnFORXXEn7KZA1ptjl31
Lva/QENl3uvKafzpuNaGlbVe8QHug+KwHHhEbPnsZMd69VcbSiucDq50ey4ounxf
jZC4psPIRI/KumTxnpibjYBWwUxSd8c+6v+wbcf27BJrF4HvhQQMST5SZteLKhTe
dVSi0U7jQixnZkqEMQ3ALu6Ndl9EPtMKxEEtyZLgH86Zu/10MARntZf8LdnMHKlQ
EEVJIwmplxKThdIsTXZLBgJj3G7+xnDq/BvJOOcGQYlTEVOU+J6C+81UH8gZguTV
zK/HMdwS34spu0PHmKuh242no+oLNHQsoNTYRfhL8Xt3VFP+8OdrLsi3hPLZftM5
S/ieaGS7e937f2yBitoW
=PniR
-----END PGP SIGNATURE-----

--Signature=_Wed__21_Dec_2011_11_43_44_+1100_WVVW.i5CZYVfz=UK--
