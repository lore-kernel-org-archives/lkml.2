Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752052Ab0FWDIt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 23:08:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56315 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750994Ab0FWDIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 23:08:47 -0400
Date: Wed, 23 Jun 2010 13:08:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       Adrian Hunter <adrian.hunter@nokia.com>,
       "linux-mmc" <linux-mmc@vger.kernel.org>,
       "linux-pm" <linux-pm@lists.linux-foundation.org>,
       "linux-kernel" <linux-kernel@vger.kernel.org>,
       Philip Langdale <philipl@overt.org>,
       Pierre Ossman <drzeus-list@drzeus.cx>
Subject: MMC tree (Was: Re: [PATCH 1/2] MMC: fix all hangs related to mmc/sd
 card insert/removal during suspend/resume.)
Message-Id: <20100623130837.eaa40f99.sfr@canb.auug.org.au>
In-Reply-To: <20100622152006.d0ec0cef.akpm@linux-foundation.org>
References: <1276809695.28201.13.camel@maxim-laptop>
	<201006221119.06210.rjw@sisk.pl>
	<1277241450.10907.4.camel@maxim-laptop>
	<201006222353.21349.rjw@sisk.pl>
	<20100622152006.d0ec0cef.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Jun_2010_13_08_37_+1000_Z8FcY.AGmnt+_+eV"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Jun_2010_13_08_37_+1000_Z8FcY.AGmnt+_+eV
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Tue, 22 Jun 2010 15:20:06 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Tue, 22 Jun 2010 23:53:21 +0200 "Rafael J. Wysocki" <rjw@sisk.pl> wrot=
e:
> >
> > Andrew, who's maintaining MMC now?
>=20
> Pierre stopped doing it, so I'm now pretending to.

So I guess I should remove the mmc tree (currently empty) from
linux-next, then?

> I actually pretend to maintain a huge number of subsystems and should
> sprinkle akpms all over MAINTAINERS so stuff doesn't get lost.

How about splitting these subsystems out of -mm and adding them to
linux-next?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Jun_2010_13_08_37_+1000_Z8FcY.AGmnt+_+eV
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkwherUACgkQjjKRsyhoI8yeXgCeJcv3/agHa9Ob0z3v1l7dYu6Y
olgAn29DzJRIBKtmuE4GV9WMWmECG5T7
=yUFg
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Jun_2010_13_08_37_+1000_Z8FcY.AGmnt+_+eV--
