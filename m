Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab1GGAYp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 20:24:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59278 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753882Ab1GGAYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 20:24:44 -0400
Date: Thu, 7 Jul 2011 10:24:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg Ungerer <gerg@snapgear.com>
Cc: Jonas Bonn <jonas@southpole.se>, Rusty Russell <rusty@rustcorp.com.au>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Greg Ungerer <gerg@uclinux.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: linux-next: manual merge of the rr tree with the  tree
Message-Id: <20110707102432.5a779744e247652be005b592@canb.auug.org.au>
In-Reply-To: <4E14F373.1020307@snapgear.com>
References: <20110705135932.de7f0526.sfr@canb.auug.org.au>
	<1309967847.3393.44.camel@jerome>
	<4E14F373.1020307@snapgear.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__7_Jul_2011_10_24_32_+1000_oaSG6s=1nA_zH1My"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__7_Jul_2011_10_24_32_+1000_oaSG6s=1nA_zH1My
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Thu, 7 Jul 2011 09:44:51 +1000 Greg Ungerer <gerg@snapgear.com> wrote:
>
> On 07/07/11 01:57, Jonas Bonn wrote:
> >
> > On Tue, 2011-07-05 at 13:59 +1000, Stephen Rothwell wrote:
> >>
> >> Today's linux-next merge of the rr tree got a conflict in
> >> arch/m68k/kernel/module_mm.c arch/m68k/kernel/module_no.c between comm=
it
> >> 4528acce2607 ("m68k: merge the non-mmu and mmu versions of module.c")
> >> from the m68knommu tree and commit 7b935befe6bc ("modules: make arch's
> >> use default loader hooks") from the rr tree.
> >>
> >> The former removes these files, so I did that.
> >>
> >> I then added this merge fix up patch (which I can carry as necessary a=
nd
> >> may not be coorrect):
> >>
> >> From: Stephen Rothwell<sfr@canb.auug.org.au>
> >> Date: Tue, 5 Jul 2011 13:12:26 +1000
> >> Subject: [PATCH] modules/m68k: make arch's use default loader hooks
> >>
> >> Signed-off-by: Stephen Rothwell<sfr@canb.auug.org.au>
> >> ---
> >>   arch/m68k/kernel/module.c |   27 ---------------------------
> >>   1 files changed, 0 insertions(+), 27 deletions(-)
> >>
> >
> > That patch looks good to me.
> >
> > Acked-by: Jonas Bonn<jonas@southpole.se>
>=20
> Looks fine to me too:
>=20
> Acked-by: Greg Ungerer <gerg@uclinux.org>

OK, so now someone just has to remember to apply it (or tell Linus, or
fix up the trees) during the merge window.   That person probably won't
be me (since I will not be online next week (assuming Linus follows
through and opens the merge window next week).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__7_Jul_2011_10_24_32_+1000_oaSG6s=1nA_zH1My
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOFPzAAAoJEDMEi1NhKgbsk2QH/Rk8iHqypkN4tZNQcVdovfqL
44f+un/83SfwncOuAOr4cjJylt+2EGpAH/yyf0Bn9u2xFkNqbZTIymtn4PYEwOZM
mlcAg1/c4mGFhGKVvbKupVzf/0DgvH7uCDYr/09h7c9M2ABKTNyl8+vYbQbeclTt
cEfgS/w28NtI6GBz5hu0yQh6QCRVKsEPzxzDw9spP3SIFI4PNFggbSFT/r8m9ht8
vZ5KDFluyMftjbB3jFRDO65E6DsBCBXBlGrIK7coTcAUIOpHHf5vdwSRpGl7qM3R
4C45C+2Jpmq4LMn/Y4I5/eeURFDHgcqbTTFYnlezn5uVtSPvJMIrM/rx23vdHY4=
=S1Ec
-----END PGP SIGNATURE-----

--Signature=_Thu__7_Jul_2011_10_24_32_+1000_oaSG6s=1nA_zH1My--
