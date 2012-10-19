Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965098Ab2JSC5c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 22:57:32 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38536 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab2JSC52 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 22:57:28 -0400
Date: Fri, 19 Oct 2012 13:57:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: gerald.schaefer@de.ibm.com
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Ralf Baechle <ralf@linux-mips.org>
Subject: Re: linux-next: build failure after merge of the final tree
 (tip/s390 trees related)
Message-Id: <20121019135726.289acddb5301586444724c6a@canb.auug.org.au>
In-Reply-To: <20121018182642.2a541275@thinkpad>
References: <20121018172201.b81dcc8fe40868256f532364@canb.auug.org.au>
	<20121018182642.2a541275@thinkpad>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__19_Oct_2012_13_57_26_+1100_CaJ+LBuINQ6_ARUI"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__19_Oct_2012_13_57_26_+1100_CaJ+LBuINQ6_ARUI
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gerald,

On Thu, 18 Oct 2012 18:26:42 +0200 Gerald Schaefer <gerald.schaefer@de.ibm.=
com> wrote:
>
> On Thu, 18 Oct 2012 17:22:01 +1100
> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>=20
> > After merging the final tree, today's linux-next build (s390 allyesconf=
ig)
> > failed like this:
> >=20
> > mm/huge_memory.c:1424:2: error: implicit declaration of function 'pmd_p=
gprot' [-Werror=3Dimplicit-function-declaration]
> > mm/huge_memory.c:1424:7: error: incompatible types when assigning to ty=
pe 'pgprot_t' from type 'int'
> >=20
> > (see http://kisskb.ellerman.id.au/kisskb/buildresult/7383823/)
> >=20
> > Caused by commit 35d3d3427314 ("s390/thp: select
> > HAVE_ARCH_TRANSPARENT_HUGEPAGE") from the s390 tree interacting with
> > commit 93c9d633bd9e ("mm/thp: Preserve pgprot across huge page split")
> > from the tip tree.
> >=20
> > N.B. Mips also selects HAVE_ARCH_TRANSPARENT_HUGEPAGE as of commit
> > e21a828a1bba ("MIPS: Transparent Huge Pages support") from the mips tree
> > and so will be broken in some configs now as well.
> >=20
> > Anyone have suggested merge fix patches I can apply?
>=20
> Subject: [PATCH] s390/thp: implement pmd_pgprot() for s390
>=20
> git commit "mm/thp: Preserve pgprot across huge page split" in
> linux-next introduced a pmd_pgprot() function, which is missing on
> s390, resulting in a compile error when transparent huge pages are
> enabled. This patch adds an implementation of pmd_pgprot() for s390.
>=20
> Signed-off-by: Gerald Schaefer <gerald.schaefer@de.ibm.com>

I have added that to linux-next today as a merge fix.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__19_Oct_2012_13_57_26_+1100_CaJ+LBuINQ6_ARUI
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQgMGWAAoJEECxmPOUX5FE4PgQAKTrBYSVjas6b50MFxNz7t0M
0H18+g708N17qZl61JIYFWgodNPxrPClyNMoOOplEb+xWAiOPzuk4Nk/FZ/CKu3d
4Iqlmw+xQ77bJqeNjVxN7/0y3bYJvxSy/cMHxAnAlQkbPvaHc9dSH0x5Ro31MSme
CUueNS3iKc3CaaztrPoU28+q/XwqVkm+AqQvO2JgtXet0clexNASCrziPbn9SOhG
9IUB7HYnHzwHQD9tcbdYSdVZprsL/5e9h+S9h2/9RLMyd+VrE1nSjSEQzQ1coe+z
BROu3KxbQL2CdMweRImyK3PsLAyOFRM+RxrdbhnnAB2WSr0+2KQVBaOEA+S4QVc7
2PUXDfNhLyI6irzOwlZOjZq2q8QugyP74TMU2MwPahXWNBPYn3GLskfCrApZ/TRX
FFd/TbDwwd8J4Zan8Wc1d6JD0krwQA4nC6ModydidDvkgETDUL3wyQW2o21iqDh8
kvYWp39aLdMcql/hFAg73jFDb0h4AmcOhUtMseTqXVw9lRP5U4z3PpoB580rUpsj
eJbtc8HnghDXxV9PEd0ctiTtHtW8D0BzpvJktsUmdQrs7+TMy1Ml0XWlso5Nlw+f
/+UP0cD54VTOt3+t4NnibXfpvg56ta//nk3vFz3LVX6Q1XwOUE5aRTovY2r43Eqo
2F0YEJx7e1CfHkBPHUmB
=LuFi
-----END PGP SIGNATURE-----

--Signature=_Fri__19_Oct_2012_13_57_26_+1100_CaJ+LBuINQ6_ARUI--
