Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab2EBG13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 02:27:29 -0400
Received: from cantor2.suse.de ([195.135.220.15]:55713 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754073Ab2EBG11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 02:27:27 -0400
Date: Wed, 2 May 2012 16:27:22 +1000
From: NeilBrown <neilb@suse.de>
To: Evgeniy Polyakov <zbr@ioremap.net>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 2/2] ARM: omap_hdq: use wait_event_timeout to wait for
 read to complete.
Message-ID: <20120502162722.2592421f@notabene.brown>
In-Reply-To: <20120501214219.GB15560@ioremap.net>
References: <20120425124153.2afa318b@notabene.brown>
	<20120501214219.GB15560@ioremap.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SgbCGLDWKtR50uByREKpLXv"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/SgbCGLDWKtR50uByREKpLXv
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 May 2012 01:42:19 +0400 Evgeniy Polyakov <zbr@ioremap.net> wrote:

> On Wed, Apr 25, 2012 at 12:41:53PM +1000, NeilBrown (neilb@suse.de) wrote:
> > There is no gain in having a loop - there is no risk of missing the
> > interrupt with wait_event_timeout.
> >=20
> > Signed-off-by: NeilBrown <neilb@suse.de>
>=20
> Both patches look good, thank you
> Feel free to add my ack if needed
>=20

Thanks.  I'll add that and resent to GregKH.

NeilBrown

--Sig_/SgbCGLDWKtR50uByREKpLXv
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT6DTyjnsnt1WYoG5AQLTWQ/9G+mBBvex7OsrePrFEjnJGH5GSc5jiDKt
dhLLLqukLWUOjr4PDW9gpFm1BJDRFeOcwAEaAvRWQu9oTi4EKYDIlMjkIo3tJ3wS
aInXLeoysrF+kd/NL0v+tBUzDRy9EswylMhRwe/pdiCx/TBdGTWp1pqnmXzWBK8c
THrmAk3CamUe0Wp3GHHBpj7z9kcSeURkZ8XfSxjnyZ7e4nsB+DkCE3FfdGVBitJI
l/OZYuichxEMah2EFyk/vefsrJ8hYKvZ8vIQHn3JLmz6qADHp2UtCCeRVTRSSzD1
kgwAIOdHx/Wh4sN0pImCg2TV2iBUKFFHKKAtMpw7LqOa4jJ2DG3nNeSrumkr5T92
ZnawWM1UPm2OYrpG66RKJdof36p/alPfycVCStziGnytLoJ2TymGH4NzmcKda+h7
O22gWucMvnGUgCkKhZgBAptYPv112RWIrvlHKjFyHOPhK0cdYnFUw/CPT7YPvE2b
6tkn7tVnN7ERdikJvhGSYSKrZfIzArBpKSsAUkme4cxB+VdjB9LY2vrh4/bI/CWY
WNiDUWZwzUStDRKz7VrhQcUyP9dpnXuioQmavL1487qNRgbWs0mYbTC/p3bzREJE
8ERkiHz4w/87O7T5eHYpAUyRXeN3vKfNehPNR8ihkUa4KB9nrqxB7R3PMcsZuFO7
1CtzNtI5iK8=
=fJCe
-----END PGP SIGNATURE-----

--Sig_/SgbCGLDWKtR50uByREKpLXv--
