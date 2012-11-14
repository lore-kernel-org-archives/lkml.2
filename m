Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab2KNHDT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 02:03:19 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:39095 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754789Ab2KNHDQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 02:03:16 -0500
Date: Wed, 14 Nov 2012 18:03:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Linus <torvalds@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Hugh Dickins <hughd@google.com>
Subject: Re: linux-next: Tree for Nov 14
Message-Id: <20121114180308.f73a78863ea357796490e2f7@canb.auug.org.au>
In-Reply-To: <20121114175528.819d9ac5b2582053b5de4b99@canb.auug.org.au>
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
	<20121113213742.292f3ace.akpm@linux-foundation.org>
	<20121114175528.819d9ac5b2582053b5de4b99@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__14_Nov_2012_18_03_08_+1100_OOO5enPsgK2yHdXX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__14_Nov_2012_18_03_08_+1100_OOO5enPsgK2yHdXX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Nov 2012 17:55:28 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> On Tue, 13 Nov 2012 21:37:42 -0800 Andrew Morton <akpm@linux-foundation.o=
rg> wrote:
> >
> > It would help if the old sched/numa code wasn't in -next while you're
> > away.  That would give me a clean run at 3.7 and will make it easier
> > for others to integrate and test the four(!) different
> > autoschednumacore implementations on top of linux-next.
> >=20
> > Pretty please?
>=20
> So, your understanding is that the "old sched/numa code" won't (and
> shouldn't) be merged into Linus' tree (for v3.7, or ever)?
>=20
> In that case, what I can do is give you a tree that is the same as
> akpm-base but with one of the merges in the tip tree reverted (and, in
> fact, I could push that into akpm-base to make things easier for you).
> I guess that would be the merge of the numa/core branch which would
> result in the following commits being reverted:

Ok, ignore all this :-(

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__14_Nov_2012_18_03_08_+1100_OOO5enPsgK2yHdXX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQo0IsAAoJEECxmPOUX5FEPI0P/1qPzfVBRNRDMHX72tWy04bb
9pM6HR3S9URzBj1lI5xD7K2+wZSfkZ8mCSgpaSbt0hUl0Mxc9ygFkAcjxGe5kKml
+7U8qGrm5QLFaqKizzsxNlz9hZpdME9EQNAssEH278yFPsMauuxSmjcR0q8Tf4Id
CVoRxjj/vzhysq0fnRCfRjKg38Xk5N33eJd2Ftc0VPqNic8bug5k8fr4WTABSAmZ
A/V4J4mF8rCJABhc95E2qRImLt0QgERj2d5hKbE5maP/loo7ouPJ6+xzPpUdPy5M
U2QJfUdCSrdCa+spsiLjWlOVSlY/oaYqmtwdF1mZA9demJzZ3Gnw11z8VX0NXzJI
rcpCqsndF/JbJSUty+OxIw3m2EK2yz19tzAqc0WdnC923pkmVJcmh29mzG+8A4i7
nq3eb14YW6Xw0U9PUuxlbhWoI+6txuFk8NhFMui8G8+bIYFCgbdq8EgFg4ejfFQy
i/pRKEt083kRo5J86YFpiA7OZiIUo0h4DT2x4jTBHrrwRvfmpMZ7AVVfDxSaySrE
x198v7w8qIGxxNUoES25Xqou3htRGdmR9+BlqIYGMLhjM0zRV09TQ0Zl8RQRqHfj
ut8mphpjOvlvNZKRWA2FHGAirZF56xFOjFi84Phm/ChSIamfe+p0f/U4Tf0M/0DR
6sCATyLRftjMsg5w3Vh7
=YJLz
-----END PGP SIGNATURE-----

--Signature=_Wed__14_Nov_2012_18_03_08_+1100_OOO5enPsgK2yHdXX--
