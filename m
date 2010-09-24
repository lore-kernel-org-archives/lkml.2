Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755513Ab0IXLNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 07:13:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753079Ab0IXLNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 07:13:44 -0400
Date: Fri, 24 Sep 2010 07:13:36 -0400
From: Jeff Layton <jlayton@redhat.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Steve French <smfrench@gmail.com>, <linux-cifs@vger.kernel.org>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build warning after merge of the cifs tree
Message-ID: <20100924071336.6def0437@corrin.poochiereds.net>
In-Reply-To: <20100924134841.161d18d3.sfr@canb.auug.org.au>
References: <20100924134841.161d18d3.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/G9yeT8oKoqHFfj.1zLjnskP"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/G9yeT8oKoqHFfj.1zLjnskP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 24 Sep 2010 13:48:41 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi all,
>=20
> After merging the cifs tree, today's linux-next build (powerpc
> ppc64_defconfig) produced this warning:
>=20
> fs/cifs/dir.c: In function 'cifs_new_fileinfo':
> fs/cifs/dir.c:140: warning: unused variable 'cifs_sb'
>=20
> Introduced by commit 9a6124e7e18fa30d8693055e6a4526afb4c3fabc ("cifs:
> have cifs_new_fileinfo take a tcon arg").
>=20

That's fixed in the next patch in the multiuser mount series. It
probably should have been part of the patch above.

--=20
Jeff Layton <jlayton@redhat.com>

--Sig_/G9yeT8oKoqHFfj.1zLjnskP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.16 (GNU/Linux)

iEYEARECAAYFAkych+kACgkQojH4PzJJfGXreQCfZ3sUwYbi/6Td8aLJivU8gn9a
VlIAoMJEYVKnGgjVpQC+Tq+AL6pFIiZR
=RXtu
-----END PGP SIGNATURE-----

--Sig_/G9yeT8oKoqHFfj.1zLjnskP--
