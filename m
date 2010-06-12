Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751545Ab0FLPh3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Jun 2010 11:37:29 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:42192 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750866Ab0FLPh0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Jun 2010 11:37:26 -0400
Date: Sun, 13 Jun 2010 01:37:18 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: akpm@linux-foundation.org
Cc: mm-commits@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: mmotm 2010-06-11-16-40 uploaded
Message-Id: <20100613013718.e724d5e0.sfr@canb.auug.org.au>
In-Reply-To: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
References: <201006120008.o5C08gC3027843@imap1.linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__13_Jun_2010_01_37_18_+1000_icSjl8ju6wtHDJIK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__13_Jun_2010_01_37_18_+1000_icSjl8ju6wtHDJIK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 11 Jun 2010 16:40:13 -0700 akpm@linux-foundation.org wrote:
>
> The mm-of-the-moment snapshot 2010-06-11-16-40 has been uploaded to
>=20
>    http://userweb.kernel.org/~akpm/mmotm/
>=20
> and will soon be available at
>=20
>    git://zen-kernel.org/kernel/mmotm.git

The version in this git tree stops just before patch
scsi-remove-private-bit-macros.patch.  I suspect that is because "git am"
doe not like that patch (it has "a/./drivers..." as the file names).

There are a few later patches that "git am" also does not like - because
either they have no commit message, no From: line, or do not apply
without some fuzz.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__13_Jun_2010_01_37_18_+1000_icSjl8ju6wtHDJIK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwTqa4ACgkQjjKRsyhoI8yl5ACggoxHvXq3/kjjZCOdd+ESkflc
YyQAn36N0ILBXwejfRSsXOZQXY3kRuWg
=7HZY
-----END PGP SIGNATURE-----

--Signature=_Sun__13_Jun_2010_01_37_18_+1000_icSjl8ju6wtHDJIK--
