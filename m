Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754802Ab1KXXNw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 18:13:52 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:44495 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753487Ab1KXXNv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 18:13:51 -0500
Date: Fri, 25 Nov 2011 10:13:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: linux-next: manual merge of the cgroup tree with the pm tree
Message-Id: <20111125101341.d05da222778d1bd380003e20@canb.auug.org.au>
In-Reply-To: <CAOS58YP146w66g2hyJSn10hWjtWmSjQBo36BaJ4ZibZcJAB0nw@mail.gmail.com>
References: <20111124152018.66ee4f15447837dd01443fdb@canb.auug.org.au>
	<CAOS58YP146w66g2hyJSn10hWjtWmSjQBo36BaJ4ZibZcJAB0nw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__25_Nov_2011_10_13_41_+1100_1QfnLD2dptZQ4cVy"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__25_Nov_2011_10_13_41_+1100_1QfnLD2dptZQ4cVy
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

On Thu, 24 Nov 2011 13:12:29 -0800 Tejun Heo <tj@kernel.org> wrote:
>
> On Wed, Nov 23, 2011 at 8:20 PM, Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
> > Today's linux-next merge of the cgroup tree got a conflict in
> > kernel/cgroup_freezer.c between commit 6907483b4e80 ("freezer: make
> > freezing indicate freeze condition in effect") from the pm tree and
> > commit 41dfa07cedcc ("cgroup_freezer: fix freezing groups with stopped
> > tasks") from the cgroup tree.
> >
> > I think that the latter is a superset of the former (but I may be wrong=
),
> > so I used that.
>=20
> We'll need to do freezing() || is_task_frozen_enough() there. I'll
> update pm-freezer after I push cgroup fix upstream next week.

Thanks, I have updated my merge resolution.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__25_Nov_2011_10_13_41_+1100_1QfnLD2dptZQ4cVy
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzs+lAAoJEECxmPOUX5FEf+0P/iDqOHiKTxRqQbdJVvGg2PmV
z9ln/SdYEkwpnRXLOEZ/46FzjcP0aCzjDxynT9rMgdHi5dJK1vhI/6BulxsH0L1p
LkXHJxN89gTa6vZGA/sErQTMMHSsoJkkZgqfFaRoMB5t/1Kkw7Hf6cy6kG22Lm4y
9ELHiMoCNHZsSIC3Aq4o6sb4JHcEG7TlDLB+jcItmGRrCM9AtlgP5rsHO35S83zG
hNsgdhmLjPLgRGNmzznT+XeTXM/MNab8Ybw8Z4d45z83daAOyWcinHpwTayz49T4
4uN91EWyo9S3+HpzPZgKK/7ANN2IAGccCH6IHhE/y34PUQfCeio29P5/cgGKKYyB
kT1roGd8Ny9zD51kGfzpJKxwiGDqUGtUqL3PvP2BgXqL76+WhNQ2xZ61DBwSX6tv
tVSZD+uJpH45mXgeR6OA8JQMqptlzNYjIyQMP6bD+ev8Qm/DKQds4lTI3w1WEIg3
Btx2IzCIv2F16lEfUF4JruUV9tZDvU3iYTm5f4LaIag/Elu0/z7jL2Wvmy9JZbU5
sRSejlSSzPPatzJgwEweUagSeU3oI7vkdRF8JvyMbe5lGnFn8a5NKTIFFmcwlirB
gDmwCVu5KwoNWugMLp03xTa2SIGT1C8tCd2kE+cu3bvikqUQoJgbeTeFTc58jMHO
PTa0ybugnoeXxL8yI2hG
=PRym
-----END PGP SIGNATURE-----

--Signature=_Fri__25_Nov_2011_10_13_41_+1100_1QfnLD2dptZQ4cVy--
