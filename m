Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935591Ab2JaNz3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 09:55:29 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:38789 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932970Ab2JaNzZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 09:55:25 -0400
Message-ID: <1351691714.13356.31.camel@deadeye.wl.decadent.org.uk>
Subject: Re: linux-next: manual merge of the block tree with Linus' tree
From: Ben Hutchings <ben@decadent.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Jens Axboe <axboe@kernel.dk>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Date: Wed, 31 Oct 2012 13:55:14 +0000
In-Reply-To: <20121031130439.7242d3f12fa7002624c3b1e6@canb.auug.org.au>
References: <20121031130439.7242d3f12fa7002624c3b1e6@canb.auug.org.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-p2oPsb+fnX+Dqn3/hrjD"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-p2oPsb+fnX+Dqn3/hrjD
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-10-31 at 13:04 +1100, Stephen Rothwell wrote:
> Hi Jens,
>=20
> Today's linux-next merge of the block tree got a conflict in
> drivers/block/floppy.c between a set of common patches from Linus' tree
> and commit b33d002f4b6b ("genhd: Make put_disk() safe for disks that have
> not been registered") from the block tree.
>=20
> I fixed it up (by using the block tree version) and can carry the fix as
> necessary (no action is required).

commit b33d002f4b6b ("genhd: Make put_disk() safe for disks that have
not been registered") was supposed to be dropped or reverted; I don't
why it's hanging around.

Ben.

--=20
Ben Hutchings
I'm always amazed by the number of people who take up solipsism because
they heard someone else explain it. - E*Borg on alt.fan.pratchett

--=-p2oPsb+fnX+Dqn3/hrjD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUJEtwue/yOyVhhEJAQry/w/9H1+BWEn7razJYpHeZeQi4fE+onF99HeQ
Bm8HmkGr1/EYrw2bRLVDVFSkn1nrd1J0D+/c73vNLLR/JimlQXtTU5kbATbk1JHy
DyyVPMmVFTG/iJehdtz3WshOB4msnQoT5h0+jEg36fIiIx11iDTzJMZlUsHpAbWQ
DQUo0OgttdG2BACtna4zzeV4Y/05p+w6TikGMjQIl2jNx6Z4762RwrU4Q4vTOx9e
CHGPDBSEzx2qKVMlpuUMx1KbyQ2RpNC6EPyZwHH2fCSooLWVxcz+wevEwEwnWQ1D
F9z7JEZmo7wixuyM5yw44ijBeBKAO4cQUcLB3J6/qo580sLwAd611VrCpemeVcVe
59qBCf77mMC4s9hxNvpum0C7fKPEhR7lDAgIAHFoXiS7RttNZvLXF1HXxkRgNRRC
uh9+8J9L+bcGHfXjqEWF+Qaf429TZq4fbmN5xrWtpIyUeS+TrETEQXP+w9OHqbym
M9r5xO6bjCdtxBW6n/Zh7X1Jj1PRL3iOaFxpX0YOnCfGDwzsSlJ3Y/OdQqNYrufG
wpghuJ8wh7TGmJPjw0WdFJXV0hr0HvKi50O6Mu0qsGnYEemN72MuUa5hipMy4JQK
YxdJ5jg/GpLJ7fx7EEg64kuWKNP2XVjfbtm2XVQ6GJ2BGqQXcbop58+EbPHbfRha
9URfTqhotDA=
=u0kT
-----END PGP SIGNATURE-----

--=-p2oPsb+fnX+Dqn3/hrjD--
