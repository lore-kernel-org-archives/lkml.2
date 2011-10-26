Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752880Ab1JZUkO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 16:40:14 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:37892 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752221Ab1JZUkM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 16:40:12 -0400
Date: Thu, 27 Oct 2011 07:40:02 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Randy Dunlap <rdunlap@xenotime.net>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, target-devel@vger.kernel.org,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: Re: linux-next: Tree for Oct 25 (target)
Message-Id: <20111027074002.8cd56b32b3f1200070abc4d9@canb.auug.org.au>
In-Reply-To: <1319658791.21607.5.camel@haakon2.linux-iscsi.org>
References: <20111025203628.40a1b8a475e32053aa34dabe@canb.auug.org.au>
	<4EA853F2.4040503@xenotime.net>
	<1319658791.21607.5.camel@haakon2.linux-iscsi.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Oct_2011_07_40_02_+1100_a_PCbYs9cqTjorj0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Oct_2011_07_40_02_+1100_a_PCbYs9cqTjorj0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 26 Oct 2011 12:53:11 -0700 "Nicholas A. Bellinger" <nab@linux-iscsi=
.org> wrote:
>
> On Wed, 2011-10-26 at 11:39 -0700, Randy Dunlap wrote:
> > On 10/25/11 02:36, Stephen Rothwell wrote:
> > > Hi all,
> >=20
> > target_core_cdb.c needs to include <linux/export.h>:
> >=20
> > drivers/target/target_core_cdb.c:1316:1: warning: data definition has n=
o type or storage class [enabled by default]
> > drivers/target/target_core_cdb.c:1316:1: warning: type defaults to 'int=
' in declaration of 'EXPORT_SYMBOL' [-Wimplicit-int]
> > drivers/target/target_core_cdb.c:1316:1: warning: parameter names (with=
out types) in function declaration [enabled by default]
> >=20
> >=20
>=20
> This one had been addressed in target-pending.git/for-next with a
> module.h include for target_core_cdb.c, but I'll change this now to use
> the proper export.h.

Except that export.h does not exist in Linus' tree yet.  Just leave the
module.h there and it will be changed sometime later.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__27_Oct_2011_07_40_02_+1100_a_PCbYs9cqTjorj0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOqHAiAAoJEECxmPOUX5FEcZcP/R5SDD3yRMo3L55e/dz55zRh
rF483pFNYDwxnNcQaXHJaRD/pg4Ugah6+rhOGd+/HIhscMTmO7i5A6dCztmFvBA9
Y7i8XoOCxlSUt+QWmOcD5P0UQmtt/VQvrgU91aIgOsMRDRVnBLv7XocwZ0y6pUct
nkRxKjHztLOr5XcQbhAYhMbHGZrEXM2jeUvxH9Y9zVPmRGqFeuTHcUUYn0UTuc5i
nuN9bISH/SbXv+58/DwIBpqi4X2bBVOMejLiQScs7hHzRiIcuSwNkLkRBaVAl08e
5TIO5Jus+r+WOIFMhWsHVuO1TLZjcKj5hYXCfOnDUPF5EnWcH5rdKxcn+lnarQSI
UN1wdCk5Azag0UTYUpGy2ad5FZEETCKcS8whpS2KIGB79cVGWFFo7We5w3zd2Nx7
OUkWxdrdK8b2AfAu3Zwit/agk28QXdSyesNKULfZpion3BoBbOBIev8X5QIWhTP4
PX2p4oktEEBYn3kdrHLmw3uSFzB6F+5N7bpWdg5EN1Iyl4Vs44VEcCd4KOcOPZNZ
Gab8DtVaGm04jiP/GyZFco6ndlMEPy0uTglxzzsIUNy1vm12IbwuFJXD+m1XjYpw
//DMpdluRPZJZSC4ImD2U65N3+9jXCoUq6PuX1OcFekUvDyvIup1GsVZ0/xstKlB
j7hqfD9qL93RY+Z6OrYN
=yjM7
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Oct_2011_07_40_02_+1100_a_PCbYs9cqTjorj0--
