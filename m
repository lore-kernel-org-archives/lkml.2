Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753149Ab2HYLE7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 07:04:59 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:33561 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433Ab2HYLE5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 07:04:57 -0400
Message-ID: <1345892692.1815.1.camel@kyv>
Subject: Re: [PATCH 7/14] drivers/mtd/maps/rbtx4939-flash.c: delete unneeded
 test
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Julia Lawall <Julia.Lawall@lip6.fr>
Cc: David Woodhouse <dwmw2@infradead.org>, kernel-janitors@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-kernel@vger.kernel.org
Date: Sat, 25 Aug 2012 14:04:52 +0300
In-Reply-To: <1345365870-29831-8-git-send-email-Julia.Lawall@lip6.fr>
References: <1345365870-29831-1-git-send-email-Julia.Lawall@lip6.fr>
	 <1345365870-29831-8-git-send-email-Julia.Lawall@lip6.fr>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-rstieTBhcE4zXoZVHmDP"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-rstieTBhcE4zXoZVHmDP
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-08-19 at 10:44 +0200, Julia Lawall wrote:
> From: Julia Lawall <Julia.Lawall@lip6.fr>
>=20
> Err has only been initialized to 0 at this, so it is not possible that th=
is
> test can be true.
>=20
> A simplified version of the semantic match that finds this problem is as
> follows: (http://coccinelle.lip6.fr/)

Pushed to l2-mt.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-rstieTBhcE4zXoZVHmDP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQOLFUAAoJECmIfjd9wqK024IP/Ra7ygyqMPeCbTaRUUVTP7G2
mNMuCqahzZJaB1oGHt0aqHM53T715nyR7Tip4k0C/k4uOTQ3y5ClTrLyIhNTVoFJ
zanj7osxapaxO97GNwcb5NhJZOAxoCepEFG42h0U3MPDkQzQlNRVzN6Aj4b8v/I6
6nAlgAslwQZRyU2Zp95o4O4VvxmCTeRckSN+XyXvT/8+UnbTohvQkuAl9DIMSWGm
kU39EFGDSbMH7Yh3sUkRYLgbjHyHbCt70GL6cjKsrS5Py+NH0vOg3q0nBWitLD9t
PR+80D9NpRlcuEu9aBvHeuvV8sjgNz6qwiyqa+b4FuVFaUAm07ikaP/LyGmyki0u
p2/ORzwa2bMerbPfREu10Q+FpIV7sMCP0zn6HBgHeSHOgOZ2I2Xl0FYH4pQ1qnHK
9IUeeXqm18izmktnZC7xzigcXUsQ8f+UKxsqp9AmzPvuFNs+fp5i8PCycLMc4JE9
H6MO7UGbctDvh5Lu7AHVkV9cCegaHKdRRGsjMDYO8OeQ9PZrOOy8O4+yhrTy/nBn
MYJGkRIhgG7pInKfRHvLAYfTiIk1pYrulyNshIWRf1TD0v0clJHQIMq58xo/TZX5
AeV0Sff2nWDx+SFftgq/2AgTRx6loljGdCE6XwAVQiPB7FwcHEpslOXJ4z6cDNNF
XuJnMU9bMAw7oRPMmo2g
=xMxu
-----END PGP SIGNATURE-----

--=-rstieTBhcE4zXoZVHmDP--

