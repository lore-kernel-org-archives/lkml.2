Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756684Ab2EHTsA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 15:48:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45213 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755244Ab2EHTr7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 15:47:59 -0400
Date: Wed, 9 May 2012 05:47:51 +1000
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] twl-regulator: make TWL4030_ALLOW_UNSUPPORTED more
 configurable.
Message-ID: <20120509054751.7bc749c2@notabene.brown>
In-Reply-To: <20120508184048.GM15893@opensource.wolfsonmicro.com>
References: <20120501204259.27026.40156.stgit@notabene.brown>
	<20120501204450.27026.40239.stgit@notabene.brown>
	<20120508184048.GM15893@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H5T_uqgNKv=aeQLuYPgyaQR"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/H5T_uqgNKv=aeQLuYPgyaQR
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 8 May 2012 19:40:49 +0100 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, May 02, 2012 at 06:44:50AM +1000, NeilBrown wrote:
> > The regulators in the twl4030 can provide some voltage settings
> > that are not offically supported.
> > These settings are disabled by default, but can be enabled with
>=20
> This doesn't apply against current code, please submit against current
> development versions.

Hi Mark,
 I hope linux-next is suitably current - it did cause a conflict as you say
 which was fortunately easy to resolve.

 I've also fixed up the subject lines (I wonder if MAINTAINERS and
 checkpatch.pl need to learn about preferred subject lines :-) and added
 Samuel Ortez to the 'To:' list.

Thanks for your help,
NeilBrown

--Sig_/H5T_uqgNKv=aeQLuYPgyaQR
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6l4Zznsnt1WYoG5AQLD9BAAiaNkPjI4BoCCWntY/L/Bs6cxVFfNWTdF
cZeJJxmlZUqDEc+Izl97drsEgU/j2P1TujLlXjODWK98745cHZY/L3hLB4CC6Xu6
c263Q+DScC2TfDU/FYq41FMm89Vjd85qUS00rspiY/ptpqdJVlPbP00t5vHHk1yp
c20UF2D0JfgvBdL9EjsoOdR6b1uG27aSUcBf0fA1Y1WxHBLvEbfIuKxh1VVBttoB
WgkYTjUv8ZcMqNvFyG372s05uFuz/UAvTe+pwdjh83HkkJDNXdW+5k7onqZfOo8E
mWAcyE2I0MIIf82fqZjX/e2JqI3hOM/sfHOwK71BxvuNzUKOmgj0inleeDmBsTeA
wYEJjO8hq7yGYL/D7udJ6CJVvmaBq8kbTRZn5JhwmoLjeqaNq913XQy8qHg33y2f
J7QPGnBbXOQNLYqJLqwBMqyIh+jRrZr2kJIHBFhF1D1S9odnSsOfGotucnjd8bPU
KVzzFRDLFKNIbtZuJyynIS+bvhVuCaQE1/EwSxkvLHRX1h9k1088CJiBgun1e9Xg
vOef2h23t81vDcromZE5D3LANI9Gq46/o0+x+eKuBYBLfsTM8TCna+vHl3uUK7Z+
vBq9nkHrfErxHLTffMYoMokiaBHBlTdb4JgxQyJdvZybCWyRh2niv4CT3/j2v/vI
35YQ7B7hfIo=
=SW+Z
-----END PGP SIGNATURE-----

--Sig_/H5T_uqgNKv=aeQLuYPgyaQR--
