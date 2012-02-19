Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751331Ab2BSXEx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Feb 2012 18:04:53 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:37419 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750951Ab2BSXEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Feb 2012 18:04:52 -0500
Date: Mon, 20 Feb 2012 10:04:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Konstantin Khlebnikov <khlebnikov@openvz.org>
Subject: Re: linux-next: build failure after merge of the final tree (akpm
 tree related)
Message-Id: <20120220100436.5fbbf5cc1b1df539ed8aca24@canb.auug.org.au>
In-Reply-To: <20120217212037.0859c427418b73b2cb17428d@canb.auug.org.au>
References: <20120217212037.0859c427418b73b2cb17428d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__20_Feb_2012_10_04_36_+1100_aRB96W==pfjIDOTg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Feb_2012_10_04_36_+1100_aRB96W==pfjIDOTg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Fri, 17 Feb 2012 21:20:37 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next fails to build (s390 allnoconfig) like this:
>=20
> In file included from arch/s390/mm/maccess.c:15:
> include/linux/gfp.h: In function 'gfp_zonelist':
> include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA' undeclared (first=
 use in this function)
> include/linux/gfp.h:267: error: (Each undeclared identifier is reported o=
nly once
> include/linux/gfp.h:267: error: for each function it appears in.)
> include/linux/gfp.h:267: error: '__enabled_CONFIG_NUMA_MODULE' undeclared=
 (first use in this function)
>=20
> and many more.  This also happens in other architectures and configs but
> (obviously) not all builds.
>=20
> Presumably caused by commit 053361e1a072 ("mm: replace NUMA_BUILD with
> IS_ENABLED(CONFIG_NUMA)").

I have removed that patch from the akpm tree until a solution is worked out.

Everything seemed to rebase ok with out it and I can't see much actually
depending on it.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__20_Feb_2012_10_04_36_+1100_aRB96W==pfjIDOTg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPQYAEAAoJEECxmPOUX5FENcAP/iaOmtpVjXtJD3iL0apA/sb1
Tr53SqiuNsf9n+1cqhuScN5ZkF04KYV2zIWzKA8UugHI6V2ROCa+LfMrxPxd64Zq
pOF0v1UB1lCkZe+xZGHQL2BaUwKZia3lBLv0WowVF1ggTF7wcUL/6oYkiEEfblnO
dDhGwJzIZddofYV7QuYR52JZFBXGbTcj3c9fwQ/71ItLdUPXFoQsoabf3i0oqjdc
EmUzcYpG3Ko1UZePWGu+r88wGoBJWKa3RY1WnTVdkmla4JODXpdw7stMRZsR5Jtu
7Q9ICODJEa1NWnItCnmn8fbsJwOcez0aNQlpviKkwoiX3sK+bLmzee80HYuvyhPQ
ZTio1H1+KH7EUbMV5f5ZUO8NVvY87XT1NH5wTtk00WSRLPdzsoiZryAZVDSqo6oN
LNO3oNmf4DkBTHybCMdz9+adLJI6m8dHF/pZ/SmHoPH2qieIhZ6y9OQXDUGXW0Cx
dImXhpDDyOijyTEh1EwsRUUVZzp2ncRQ9+k6bD9u+cZInOKnYrziU1kWQjrAypWI
bomLbNy6wpdX6Vdj+OTrEGVr59Kl+7MFN8N/jpNv0Hd1RN6d2PNlP0FbmuFfdjKM
vHWkPknTgNDFqhHT21m3rDGohj3g9JvHQw08MKdujdAA43A5XVOS4nYt5awPkzJt
wlloE0f1XGGcDiThWmm9
=MZhW
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Feb_2012_10_04_36_+1100_aRB96W==pfjIDOTg--
