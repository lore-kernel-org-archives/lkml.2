Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751600Ab1EBEZG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 May 2011 00:25:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58655 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882Ab1EBEZA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 May 2011 00:25:00 -0400
Date: Mon, 2 May 2011 14:24:54 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Jones <davej@redhat.com>
Cc: Michal Marek <mmarek@suse.cz>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>
Subject: Re: linux-next: build warning after merge of the kbuild tree
Message-Id: <20110502142454.a7091ad5.sfr@canb.auug.org.au>
In-Reply-To: <20110502134524.40da4245.sfr@canb.auug.org.au>
References: <20110502121817.645d544e.sfr@canb.auug.org.au>
	<20110502022417.GA11804@redhat.com>
	<20110502134524.40da4245.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_May_2011_14_24_54_+1000_XXx0AoRL4obQTmFo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_May_2011_14_24_54_+1000_XXx0AoRL4obQTmFo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Mon, 2 May 2011 13:45:24 +1000 Stephen Rothwell <sfr@canb.auug.org.au> w=
rote:
>
> On Sun, 1 May 2011 22:24:18 -0400 Dave Jones <davej@redhat.com> wrote:
> >
> > Which version of the patch got merged ? This should be guarded by cc-op=
tion checks.
>=20
> It looks right to me (that's why I wrote "though I don't see why") but
> empirically we have a problem.

I do not get it for every compile fo a file, just a few times during a
whole kernel build.  Some config/arches do not produce any (like sparc32
defconfig).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_May_2011_14_24_54_+1000_XXx0AoRL4obQTmFo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNvjIWAAoJEDMEi1NhKgbsghMH/jJU6pOH7A3UYffvpiHi628V
QTOEyxJpqB/JDt9/THHBO+7G7j9emsf8UZbGLNgbbxg+G8mTI2DDSeie0OyYSR1b
S2K1pY4m08P+6rCzPKoMdbDkgKu5dMsaG8vVa34TpK8Jx7Z5KvjOiV9FJLcMA9V1
TlsXGqU8ftG1daFCoIsdKBSDXYXxZJSLnQQ1rz07tGwQQi8BYVHHIB6/xkAOfhxd
aNevqCGCFb82uBNoo2jj8CaYuS6v4VyiibHxJiFYSYbPjRfKvB/gY+jo3qcD5OsU
A6c5qU+6G6DejzLFk9kntfjiEW2FtC0Q/HyGKIfOAHB5bC4YseX8BBKYBPmiyj8=
=7IYO
-----END PGP SIGNATURE-----

--Signature=_Mon__2_May_2011_14_24_54_+1000_XXx0AoRL4obQTmFo--
