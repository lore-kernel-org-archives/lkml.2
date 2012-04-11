Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647Ab2DKEsR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Apr 2012 00:48:17 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60148 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929Ab2DKEsQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Apr 2012 00:48:16 -0400
Date: Wed, 11 Apr 2012 14:48:06 +1000
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jim Kukunas <james.t.kukunas@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: linux-next: build failure after merge of the md tree
Message-ID: <20120411144806.7664d38b@notabene.brown>
In-Reply-To: <20120411134259.61f755a90055b23a6876687b@canb.auug.org.au>
References: <20120411134259.61f755a90055b23a6876687b@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_//zSAz9FQY5pWkpGQyz.Abta"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_//zSAz9FQY5pWkpGQyz.Abta
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Apr 2012 13:42:59 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> After merging the md tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> lib/raid6/recov.c: In function 'raid6_has_ssse3':
> lib/raid6/recov.c:27:2: error: implicit declaration of function 'boot_cpu=
_has' [-Werror=3Dimplicit-function-declaration]
> lib/raid6/recov.c:27:22: error: 'X86_FEATURE_XMM' undeclared (first use i=
n this function)
> lib/raid6/recov.c:27:22: note: each undeclared identifier is reported onl=
y once for each function it appears in
> lib/raid6/recov.c:28:16: error: 'X86_FEATURE_XMM2' undeclared (first use =
in this function)
> lib/raid6/recov.c:29:16: error: 'X86_FEATURE_SSSE3' undeclared (first use=
 in this function)
> lib/raid6/recov.c: At top level:
> lib/raid6/recov.c:25:12: warning: 'raid6_has_ssse3' defined but not used =
[-Wunused-function]
>=20
> Caused by commit 56d3ac7ef905 ("lib/raid6: Add SSSE3 optimized recovery
> functions").  All the world is not X86 :-)
>=20
> I have used the md tree from next-20120410 for today.

Thanks Stephen,
I've removed that set of patches from my for-next pending further review and
revision.

Thanks,
NeilBrown

--Sig_//zSAz9FQY5pWkpGQyz.Abta
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4UNBjnsnt1WYoG5AQIu5Q//fozzyiSS+Uo0qcUU664Ux0igMWbMQ0JA
p7q5U8r6If2Hwbid4JaV33uyu3Fs9sd1QYydlDNu7V+u8oKoxORZQeuom15J1aww
cTlR/NbMtD390Dt6m1isfrhd706b5CwuLV19NXtQpo8o4Nxzw5QTEs+GfU2qn4lx
NrLoaWVRE+PxJ1Ohml+rUnpBmXV+vMcvPQBkarYWjoO3+f3//WqgVWtdoo4Rr8dM
ZgLT8wWpONExrbrpsFgKvDKa7UQH8pNxdIohy8ZZyUDwHb5X520ReBfNDCX2NbXX
wV3q4mn3KuBdX1pDDc6vVAYFmGldUiVNtAvt1Tk+JLG8ZceQwfesc1a16sDs/F93
tJ1VVnltUvnOtWJA8H1IyDbnjtdndIt0r9VRxiiItKu9roOzWAccOMCgzi4ujkHX
3nOEFA/e56/UzfyaLKXaKNEk0nKk1GNBQMZ5akrfPzw4pmIN6tSeZrdotl4Gng7c
YQifa/EjyFAxnyNRXfZtKdg9cCbKQOxTcNU4VtC4cwtx38wCXz8SBDpDhExHVVmA
bYILMjOdXhrDpnB5wBj5HgZUdamEJT63N5d0JU7gz2YNwc84U0ZMg9Isab5iPq0f
9NsF+l1HIyr4vo4PRSNSVEnoIgYBx+rIrJUuKQWDm/eYV8YLie8f6hPKyFwzBTjQ
oQp1DZyNNkc=
=o7yP
-----END PGP SIGNATURE-----

--Sig_//zSAz9FQY5pWkpGQyz.Abta--
