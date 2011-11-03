Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1KCBDR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 21:03:17 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34131 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab1KCBDO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 21:03:14 -0400
Date: Thu, 3 Nov 2011 12:02:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: =?UTF-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Cc: Prasad Joshi <prasadjoshi.linux@gmail.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Josef Bacik <josef@redhat.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: linux-next: manual merge of the logfs tree with Linus' tree
Message-Id: <20111103120257.c0c13ebacc8d245ca75edbf1@canb.auug.org.au>
In-Reply-To: <20111102190046.GB3485@logfs.org>
References: <20111101141000.3531dbfbf0490c6d3521d6b6@canb.auug.org.au>
	<20111102190046.GB3485@logfs.org>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_12_02_57_+1100_HUUhplcr8I6F8gDg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_12_02_57_+1100_HUUhplcr8I6F8gDg
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi J=C3=B6rn,

On Wed, 2 Nov 2011 20:00:46 +0100 J=C3=B6rn Engel <joern@logfs.org> wrote:
>
> On Tue, 1 November 2011 14:10:00 +1100, Stephen Rothwell wrote:
> >=20
> > Today's linux-next merge of the logfs tree got a conflict in
> > fs/logfs/file.c between commit 02c24a82187d ("fs: push i_mutex and
> > filemap_write_and_wait down into ->fsync() handlers") from Linus' tree
> > and commit 39da12ef4bbe ("logfs: take write mutex lock during fsync and
> > sync") from the logfs tree.
> >=20
> > I have no idea what needs to be done here.  I fixed it like below to ma=
ke
> > it build, but a better fix is needed.
>=20
> From a code perspective your fix below is correct, to the best of my
> judgement.  I'm less sure what to do from a git perspective.
> Explicitly tell Linus about it in the logfs pull request?

I was concered about the locking order (or if both locks were needed at
all).  And, yes, tell Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_12_02_57_+1100_HUUhplcr8I6F8gDg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsehBAAoJEECxmPOUX5FEelIP/Rra1ApIW6Xo6UdNF0JQ8mB8
XZdepsBlzEQ9xmoLrIa9pOuCkFZLy/ozyk1lGIzRkEiHHLfWr/42of5rsgne//r0
M3m9Gsyk2zvT24BO9XpKutlOzSJLrYNxXMF/hKws5bEIVWR+qS4vGquCEXhX5iNA
HrunnVyoMDHnz+GhgjFlbvaN58snwBd1qp0w4FeCjHQwKlSGpo435ry5WRDuwXT+
wC/hSPKBTWw0q6FCrt+Krh4P1Ov9oA2eiByjtAQr2JJS8+NQBDchkH3TdPVOQswr
eEton0qL0apnpJaVLHZezwe+ZMsGuwhVwNBMUlGNollmrQuJkkCHuU5LN7Im6sof
z2Q5iewkucYTPUCx03xxeJ0Lnwwu3vcAe8VOu2KMVM16iuCug9jvphUN7XPvlJqj
yWz/5pxT2dkYuGIlzFwFmwxCZaV1+AzA4wqZSi1sfqs/jZCQJXScVeabLR5DAict
XLjMx8MadKTLUptPhp0z28D/4i7Qiil3OrllhhyFZ6RXupeVeWEdVR1kbWPnyCRh
ltMi24wXl+TC8K/2/UgqTvdb0OZXk5gFR06WtaVhCv/Dpq+9k1xYhjoxgGjKWGn2
fFQ9CJ+XyqrOWiw8TbpN/1cr5gzDz2UVfgJ2uRZBLYfzOFUl/7NLhLO1V5bRaZhQ
p2FTFYAyHZHQGf29sbrt
=WHh7
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_12_02_57_+1100_HUUhplcr8I6F8gDg--
