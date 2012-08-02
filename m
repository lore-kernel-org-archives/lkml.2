Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab2HBWKf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 18:10:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34301 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab2HBWKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 18:10:25 -0400
Date: Fri, 3 Aug 2012 08:10:14 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Schrober <franzschrober@yahoo.de>
Cc: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] checkpatch: Add control statement test to
 SINGLE_STATEMENT_DO_WHILE_MACRO
Message-Id: <20120803081014.aa093277df2293baadb2ba86@canb.auug.org.au>
In-Reply-To: <14936868.DMgLzkV3C3@bentobox>
References: <4204029.7cYAuJfu4T@bentobox>
	<1343921213.2011.9.camel@joe2Laptop>
	<20120802162322.GI2501@dm>
	<14936868.DMgLzkV3C3@bentobox>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__3_Aug_2012_08_10_14_+1000_.z7ym4reDRkSy.NS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__3_Aug_2012_08_10_14_+1000_.z7ym4reDRkSy.NS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Franz,

On Thu, 02 Aug 2012 18:44:57 +0200 Schrober <franzschrober@yahoo.de> wrote:
>
> On Thursday 02 August 2012 17:23:22 Andy Whitcroft wrote:
> > > diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> > > index 913d6bd..ca05ba2 100755
> > > --- a/scripts/checkpatch.pl
> > > +++ b/scripts/checkpatch.pl
> > > @@ -3016,7 +3016,8 @@ sub process {
> > >=20
> > >  					$herectx .=3D raw_line($linenr, $n) . "\n";
> > >  			=09
> > >  				}
> > >=20
> > > -				if (($stmts =3D~ tr/;/;/) =3D=3D 1) {
> > > +				if (($stmts =3D~ tr/;/;/) =3D=3D 1 &&
> > > +				    $stmts !~ /^\s*(if|while|for|switch)\b/) {
> > >=20
> > >  					WARN("SINGLE_STATEMENT_DO_WHILE_MACRO",
> > >  				=09
> > >  					     "Single statement macros should not use a do {} while=20
> (0)
> > >  					     loop\n" . "$herectx");>  			=09
> > >  				}
> >=20
> > Looks reasonable enough.
> >=20
> > Acked-by: Andy Whitcroft <apw@canonical.com>
>=20
> Works well for me, thanks
>=20
> Just as note: I think this test was accidently added twice. Once in commi=
t=20
> b13edf7ff2dd0fef95e981170fa71fa6b60421b0 and one time in=20
> 7d64ef43914a734990e48a80bc60686c8db21946 (just checked linux-next, and St=
ephen=20
> added it again). Maybe Andrew Morton's tree is out of sync.

This can happen with Andrew's stuff since I rebase it onto linux-next
each day.  The rebase is sometimes happy to apply already applied
patches.  I will remove the second one today (unless Andrew beats me to
it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__3_Aug_2012_08_10_14_+1000_.z7ym4reDRkSy.NS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQGvrGAAoJEECxmPOUX5FE/O0P/iX61yayo4hcZNE4B/91K+xP
G3WLPhc9/jJDvkZMJdWBzVMWXvufyJ/MoCOjxtgy531eQOJKFwStXqO2Jtx7Pf2Q
Ae5cPZhNf+HR5d7RzUdQ0pzu4MNNSPhPv3aouKuyWZlSVmlyacNbBqXrUloGIdTM
HdVOEPIN7+GVHWV6ZVPSGYdWf0MYXwT/bC3ftcK7eECFlgDpoMitbi+Jt9fvYtk5
HIKxdd13nrHdV4iKnWFFZJdYKpGvQ2SnYKc608xt5mN+nK+gCG0UJS9uEIw3kOKs
j+1Nf91eUSUlK1wCr2X4bJ2bmheoVqfJRDS4Qu48R9J/JwSSPKhvMX34l5Tcz352
xv4Ic0lNtUUMSFEnn+VCdCBqtv9JlVW0POYz/h0EtBUxE6/MU5N2H3o2L//opk+l
9fjI/1lm+lZD8Z8LvHuR+PKVcFgqRPQYAcDzJuRzhvkMjOLWoo/a2rVAv4J9NsLZ
7upWD29XDIhHd20Kbsa6LfBFX270myMdWfY0rX06ux/aoRGKwqsa3JtPlefBDFft
y+7nuKApy4xDxPj0iovuYLiLVGJkCDn7DiaM0QgD/AaVaHE5CnVxSI6V0+V5j8wt
rilYwi6E13iFVUgwoLaxfOo0LVUp+e6KPIpu0+andLLsq0cE+udE8RBenEupOmgZ
CQxWocum/OSIIXvBgHah
=vpok
-----END PGP SIGNATURE-----

--Signature=_Fri__3_Aug_2012_08_10_14_+1000_.z7ym4reDRkSy.NS--
