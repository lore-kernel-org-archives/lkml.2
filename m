Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502Ab3AHKTc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 05:19:32 -0500
Received: from ozlabs.org ([203.10.76.45]:44762 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754920Ab3AHKTb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 05:19:31 -0500
Date: Tue, 8 Jan 2013 19:37:34 +1100
From: David Gibson <david@gibson.dropbear.id.au>
To: Pantelis Antoniou <panto@antoniou-consulting.com>
Cc: Jon Loeliger <jdl@jdl.com>, Matt Porter <mporter@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Russ Dill <Russ.Dill@ti.com>
Subject: Re: Fix test relying in wrong behavior of is_printable
Message-ID: <20130108083734.GA9055@truffula.fritz.box>
References: <1357326968-13124-1-git-send-email-panto@antoniou-consulting.com>
 <20130106035809.GG4674@truffula.fritz.box>
 <5B13DF52-26BE-4BA1-8BD7-25863B04A3B6@antoniou-consulting.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
In-Reply-To: <5B13DF52-26BE-4BA1-8BD7-25863B04A3B6@antoniou-consulting.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 06, 2013 at 01:41:56PM +0200, Pantelis Antoniou wrote:
> Hi David
>=20
> =CE=91=CF=80=CF=8C =CF=84=CE=BF iPhone =CE=BC=CE=BF=CF=85
>=20
> 6 =CE=99=CE=B1=CE=BD 2013, 5:58, =CE=BF/=CE=B7 David Gibson <david@gibson=
=2Edropbear.id.au> =CE=AD=CE=B3=CF=81=CE=B1=CF=88=CE=B5:
>=20
> > On Fri, Jan 04, 2013 at 09:16:08PM +0200, Pantelis Antoniou wrote:
> >> After fixing the is_printable bug the test suite fails.
> >> Fix it with this patch
> >>=20
> >> Signed-off-by: Pantelis Antoniou <panto@antoniou-consulting.com>
> >=20
> > Rather than just removing the test, it would be better to still run it
> > using an explicit -t bi to force the byte output.
>=20
> Perhaps it wasn't exactly clear in the patch. The old test case
> output is commented out but there is test case output for the new
> patch.

I realise that, but that's not my point.  Rather than replacing the
test for the old behaviour with the new one, I'd prefer to keep the
one checking the old behaviour, forcing that behaviour from fdtget
using -t bi

--=20
David Gibson			| I'll have my music baroque, and my code
david AT gibson.dropbear.id.au	| minimalist, thank you.  NOT _the_ _other_
				| _way_ _around_!
http://www.ozlabs.org/~dgibson

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlDr2s4ACgkQaILKxv3ab8bcTQCcCWwSVGgtW22gP1YLmjw3jNlF
VjoAn0tBy6jwuB1wayEYQ1Sq6KkwjUJt
=qU1p
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--
