Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932080Ab0DHHXZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 03:23:25 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37195 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509Ab0DHHXW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 03:23:22 -0400
Date: Thu, 8 Apr 2010 17:23:16 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Timo =?UTF-8?B?VGVyw6Rz?= <timo.teras@iki.fi>
Cc: David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
       linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: powerpc boot failure
Message-Id: <20100408172316.e6ee451d.sfr@canb.auug.org.au>
In-Reply-To: <4BBD81B3.3030500@iki.fi>
References: <20100408165848.38f75f40.sfr@canb.auug.org.au>
	<4BBD81B3.3030500@iki.fi>
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__8_Apr_2010_17_23_16_+1000_D7omye96nAmT_nIw"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__8_Apr_2010_17_23_16_+1000_D7omye96nAmT_nIw
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 08 Apr 2010 10:11:47 +0300 Timo Ter=C3=A4s <timo.teras@iki.fi> wrot=
e:
>
> > The above pc is in this piece of code (I think - I don't have the actual
> > kernel) from __xfrm_lookup (in net/xfrm/xfrm_policy.c):
> >=20
> >         if ((flags & XFRM_LOOKUP_ICMP) &&
> >             !(pols[0]->flags & XFRM_POLICY_ICMP)) {
> >                 err =3D -ENOENT;
> >                 goto error;
> >         }
> >=20
> >         for (i =3D 0; i < num_pols; i++)
> >                 pols[i]->curlft.use_time =3D get_seconds(); <-------- (=
line 1845)
> >=20
> > And the 0x200000025 is probably &(pols[i]) (which actually seems unlike=
ly
> > since pols is an array on the stack).
>=20
> What kind of xfrm policies the system has?

I don't even know what an xfrm policy is :-).  This is a pretty normal Ubun=
tu
Gutsy install and wouldn't have anything special in its network setup.

The above code fragment may be not quite the right place, sorry.  But it
is the right function.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__8_Apr_2010_17_23_16_+1000_D7omye96nAmT_nIw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAku9hGQACgkQjjKRsyhoI8wgXQCfaeReplvND7MU7mEqdWjg5BHQ
JcgAn0mk/CV/Tf0rKXMPrw9poFgPbd9K
=19fy
-----END PGP SIGNATURE-----

--Signature=_Thu__8_Apr_2010_17_23_16_+1000_D7omye96nAmT_nIw--
