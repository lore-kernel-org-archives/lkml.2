Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754789Ab2KNHPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:15:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:46661 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751662Ab2KNHPp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:15:45 -0500
Date: Wed, 14 Nov 2012 18:15:36 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Linus <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-Id: <20121114181536.3ec35e5ec622e7eaec791e00@canb.auug.org.au>
In-Reply-To: <20121113225635.a848fd6c.akpm@linux-foundation.org>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
	<20121113213742.292f3ace.akpm@linux-foundation.org>
	<20121114064726.GA2537@gmail.com>
	<20121113225635.a848fd6c.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Nov_2012_18_15_36_+1100_JqukoJnhi.zclYoD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Nov_2012_18_15_36_+1100_JqukoJnhi.zclYoD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 13 Nov 2012 22:56:35 -0800 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Wed, 14 Nov 2012 07:47:26 +0100 Ingo Molnar <mingo@kernel.org> wrote:
>=20
> > * Andrew Morton <akpm@linux-foundation.org> wrote:
> >=20
> > > It would help if the old sched/numa code wasn't in -next while=20
> > > you're away.  That would give me a clean run at 3.7 and will=20
> > > make it easier for others to integrate and test the four(!)=20
> > > different autoschednumacore implementations on top of=20
> > > linux-next.
> > >=20
> > > Pretty please?
> >=20
> > The next integration should have this solved: I have removed the=20
> > old sched/numa bits, replaced by the latest rebased/reworked=20
> > numa/core bits.
>=20
> That solves one problem, but I still need to route around the numa
> stuff when preparing the 3.8-rc1 merge.  Again!

I am not sure what is actually involved here, but would it help if I
made you a new akpm-base with the old tip tree replaced by the new one
that Ingo just pushed out?  Or are there still problematic things in the
tip tree?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Nov_2012_18_15_36_+1100_JqukoJnhi.zclYoD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQo0UYAAoJEECxmPOUX5FEGfsP/jmobljjz25OTVZz+HZINjO1
A9AkAEjr6hu5Eq6/FpMKNp97DiOSOr/mhhcqT0pVwZ8ytgsaMa64l+fjNyUH5Tid
hJrJqlHIGWKdLU2qbS1PBXPb+Q8LSOGXDUFM7N4EYajnGo9/n6dcqzJIYWukDUqC
FyfYmkXhwjsO/JSrdNfWZQbwHjGH6mDYLXvAhGemUka03QiUQxmbPl1lSMo5wLKn
Nk+iqPKifHjyUX5juJJeJAzE3rq5IT0nyZ2l7a9CR3Pe44k2iPUzXWrr66+/lN6L
6npgHeX9nTIQoYIQr9ebgN0rVnKBm8iBHdg418s8s1lCWfIsG64aZYjuq7rGx6Te
Q/AoR8fe4BQ80lMksrEj/R8QLeJ6WCMP3moj22f2eH53ZbZ4bUjXQ0F+eqRTM+mu
/ARJuVp7FxAnStadkn4WNrL++pu+5zCnjA2kS9hnkYJxPAsfQqgxyIs9SeodRXB2
1aBgd/fUJwDHUBcKdvAtZuxrXkQwYae8ji07qtveA2E+hwzzFrW8cQYeesFlAS7I
1k+1eTBSZEuT4TEvpdsGuyRZ5ATTLSuunHtp9uaKMNS0sYjMiFwig2dd3sSzzuGC
4iHroW+lk4IITuRp7x505DaZjJjG6BodVylyi2lcoypMizfOA2WhW1DxolLa3zGc
lpFaZPDxtJR/SmxSFZj8
=jXfQ
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Nov_2012_18_15_36_+1100_JqukoJnhi.zclYoD--
