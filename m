Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754211Ab2BSBEQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 20:04:16 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39560 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753879Ab2BSBEO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 20:04:14 -0500
Message-ID: <1329613455.3258.45.camel@deadeye>
Subject: Re: pull request: linux-firmware: update cxgb* firmwares
From: Ben Hutchings <ben@decadent.org.uk>
To: Divy Le Ray <divy@chelsio.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org,
        Neil Horman <nhorman@tuxdriver.com>
Date: Sun, 19 Feb 2012 01:04:15 +0000
In-Reply-To: <1329613104.3258.44.camel@deadeye>
References: <4F35DB79.6070104@chelsio.com>
	 <20120211140701.GA5194@neilslaptop.think-freely.org>
	 <4F38A526.70900@chelsio.com> <4F3CADB7.1030802@chelsio.com>
	 <1329450094.3258.34.camel@deadeye> <4F3EAAE3.5070705@chelsio.com>
	 <1329613104.3258.44.camel@deadeye>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-EAWcFWNwSohR9orJhsMD"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-EAWcFWNwSohR9orJhsMD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-02-19 at 00:58 +0000, Ben Hutchings wrote:
> On Fri, 2012-02-17 at 11:30 -0800, Divy Le Ray wrote:
> > On 2/16/2012 7:41 PM, Ben Hutchings wrote:
[...]
> > > Are there any versions of the cxgb4 driver that will specifically
> > > request cxgb4/t4fw-1.3.10.0.bin?  If not, what's the point of keeping=
 it
> > > around after changing the cxgb4/t4fw.bin symlink?
> >=20
> > Hi Ben,
> >=20
> > I originally removed cxgb4/t4fw-1.3.10.0.bin when I posted the request=
=20
> > against David's tree.
> > Subsequent review from Neil requested to keep it around at least for a=
=20
> > while (https://lkml.org/lkml/2012/2/11/61).
> > Either way is fine to me.
>=20
> No, Neil said you need to maintain cxgb4/t4fw.bin, but it's perfectly
> fine for that to be a symlink.

So I've pulled your changes and then deleted the cxgb4/t4fw-1.3.10.0.bin
as a separate commit.

Ben.

--=20
Ben Hutchings
Every program is either trivial or else contains at least one bug

--=-EAWcFWNwSohR9orJhsMD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUAT0BKj+e/yOyVhhEJAQpeQQ/+Ks0R4l5NvV+X6ESXx5RB2T45bVMP0Oik
vaY+J0cxjo45T8AD4ENkN3a/P1v5xt2239K8ias4MXmueKJRfeZr84EDWLPLu3xR
5VcalsX6oU5WvjeSEW624TbYR9aeeu6bPLjnihnojgdfPoq6iY5LtkD8RhyK5jj3
K6C9IMi6Sm4T4Akr48U2GNmgbobE68lEPwopNnC3dk5FGqdinN6HaOpcrahPu/lU
vMCrwgwM77o2ZxO3lSrL/tLgdhLsU8O+Ln0NwRI6BKnX9b/EvL+3MruyUAlh3PM/
o6T27dgaLOPiECfIrP83Zl+RKF5AUnJhTonV1ZNh6lmLdvLNZ2Z5gZbkVvXS48na
vZUta6GXOp8zZA/o3VIHv+VFDI0jBMmyu/hWUsXAfz97WkrmbQP4GH1FRRavynWQ
diNmCuxErc5ev6ZKXlT8wbEJULAlfqpXDSIgLDLI41q5JkUtFKeySbA2v3A9DRzB
0mEDTwpkceIY598lKnNVkI+dRdd7cCtHCS3gHNBspjzN2JBRMvae5BxZObZS+/Kq
z02n13/+syas5HSGU4rOaREr0Esy44UtOjW6emWdw/9Ajj72HzecEUPiRkmVzjEi
bk+b2+bno3TfaSYL0NFSxk/qJ3uc1gS27nxj+RMAd4sH98+Wn361oyQgGh7Ub77I
GR4ttcDSOuw=
=VU2X
-----END PGP SIGNATURE-----

--=-EAWcFWNwSohR9orJhsMD--
