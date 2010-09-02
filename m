Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab0IBDdv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Sep 2010 23:33:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:59192 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753078Ab0IBDdt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Sep 2010 23:33:49 -0400
Date: Thu, 2 Sep 2010 13:33:42 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: Tree for September 1
Message-Id: <20100902133342.4d3206b9.sfr@canb.auug.org.au>
In-Reply-To: <20100901.183835.219746796.davem@davemloft.net>
References: <20100901133614.2580f238.sfr@canb.auug.org.au>
	<20100901.183835.219746796.davem@davemloft.net>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__2_Sep_2010_13_33_42_+1000_rJBCfAXucY8=WsX1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Sep_2010_13_33_42_+1000_rJBCfAXucY8=WsX1
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Wed, 01 Sep 2010 18:38:35 -0700 (PDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Wed, 1 Sep 2010 13:36:14 +1000
>=20
> > The net tree still has its build failure for which I have reverted a
> > commit.
>=20
> Stephen I'm about to commit the following to net-next-2.6 in the meantime
> to deal with that so you don't have to revert whilst Fujita works on
> the more cleaner solution.

OK, thanks.  I still reverted the commit today as I fetched your tree
before you committed this.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__2_Sep_2010_13_33_42_+1000_rJBCfAXucY8=WsX1
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMfxsWAAoJEDMEi1NhKgbsg5wIAJVHoS2g1F0+7mTZnkR8YiUT
q9tWOoyaZaLh2eTY8LpmAidAr4HNdaeZxoyqt92IKvOgkt+nu4WK7V3at+Ojffc7
Y4EruzoIAf5B1WjmpE5s0cdFMfpMvqOLT841QUZRqeKcS4XFO9LGo9sfdy9mF+wq
/hK6Nclm8Q1XAa/o61SR033Nck9iBcH3yjaDA63y49Gwfv/CXBo3QqGeffSFLzCu
B9DZKuOnZ9y1v9YQyBh8APWmSIN0zQAjy8ztGaaM46gtfbdLF4VSUPG6ExE6sRFH
aVTzCA4c7jqsgaCBAsK6+rerxLln2rmtJCLji7RahG1Il0qbtrPsABZwotXjbug=
=Sh0N
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Sep_2010_13_33_42_+1000_rJBCfAXucY8=WsX1--
