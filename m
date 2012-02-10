Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759928Ab2BJTA6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Feb 2012 14:00:58 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:51916 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759822Ab2BJTA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Feb 2012 14:00:57 -0500
Message-ID: <1328900585.22240.98.camel@sauron.fi.intel.com>
Subject: Re: [Cocci] Re: [PATCH] scripts/coccinelle/misc/boolinit.cocci:
 semantic patch for bool issues
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, Michal Marek <mmarek@suse.cz>,
        Gilles Muller <Gilles.Muller@lip6.fr>, bruce.w.allan@intel.com,
        rusty@rustcorp.com.au, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org, cocci@diku.dk,
        Julia Lawall <julia@diku.dk>
Date: Fri, 10 Feb 2012 21:03:05 +0200
In-Reply-To: <1328900144.22240.94.camel@sauron.fi.intel.com>
References: <1328893887-28932-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1328895943.14197.1.camel@joe2Laptop>
	 <1328899454.22240.91.camel@sauron.fi.intel.com>
	 <1328899861.14197.7.camel@joe2Laptop>
	 <1328900144.22240.94.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-Y2nL2cu/dsGvS5adkfda"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-Y2nL2cu/dsGvS5adkfda
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2012-02-10 at 20:55 +0200, Artem Bityutskiy wrote:
> On Fri, 2012-02-10 at 10:51 -0800, Joe Perches wrote:
> > On Fri, 2012-02-10 at 20:44 +0200, Artem Bityutskiy wrote:
> > > On Fri, 2012-02-10 at 09:45 -0800, Joe Perches wrote:
> > > > On Fri, 2012-02-10 at 18:11 +0100, Julia Lawall wrote:
> > > > > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > > > Thanks Julia.  It seems to work well.
> > > I wonder though, why would we want to change if (a =3D=3D true) with =
if (a)
> > > etc? Julia did not provide the explanation in the commit message but
> > > referred to you and Rusty in the semantic patch.
> >=20
> > Testing booleans against specific values is poor form.
> > booleans should be tested or !tested.
>=20
> OK, so this is about taste, I thought there is a more serious reason.

But let me be clear - I am all for having this spatch in the kernel tree
- it is good for code hygiene.

--=20
Best Regards,
Artem Bityutskiy

--=-Y2nL2cu/dsGvS5adkfda
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPNWnpAAoJECmIfjd9wqK0bcwQAMoYpXEBdM+Ji/Cq0WkC2Uwq
6/7UG+jogP/xDiVT6uc2hZHsyp6bTnPKTxAiarvs1C+SSk9O8tIwzzL3as3AIcm1
5eXruN1FXH9IlQG2SPr+X2H8AIM2I1KeGvSZERIgWod0/pwNGU1zFGSK7B012FG2
meFWp/LlKWa4Bz9EJy2CFddrrFTpSCM8y/V8VThjIKUG91eJIqveoFBjDzbZGKBR
ObkHeU4A/shpsiuVfC0dahafBDwEnfqPjqNttnf3miotXjcdNj7F+xOs7HMshv6m
MqHsriycf6bcVdPwFggCGeeZfAUN4LUPTbpxUAYuq6C01em736RTwlbIaSLY/KcA
1KTBWd2H8cXuG1qDKwByHkKw/z2gTnpFZn/lbA1m1x7nHyIYo7Zl7PlTWSiCgErw
PGiHcH2P+XnyeGelvkMsGrxEYByLAXJ7JCDHcfpU0PK7JgRWHG2s42VsB5J25Km4
IgeL/5RUcUOaI1oI35IjzSdKMnIfXdys/lASHQmdqozD7++x2+tdfp6aTvfF9TXV
d/n4uryCTR36mb/Z86zS6P9nP2MXQAi6E4Jd/F1j9/bmK4xIDsh4wZMNLPOcQvJ4
nZrTX0Fr5r9sUDr6Da2XRd5PR8OK4Gx8xB/N04tw7p/Aa5wxzLpwbIEuCzpghxEh
aguZkcywtTYjemdBm1uI
=G/Se
-----END PGP SIGNATURE-----

--=-Y2nL2cu/dsGvS5adkfda--

