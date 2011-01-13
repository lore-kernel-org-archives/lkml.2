Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754873Ab1AMDsP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 22:48:15 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:49917 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750978Ab1AMDsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 22:48:13 -0500
Date: Thu, 13 Jan 2011 14:48:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Andrew Morton <akpm@linux-foundation.org>,
        Randy Dunlap <randy.dunlap@oracle.com>, linux-acpi@vger.kernel.org,
        Zhang Rui <rui.zhang@intel.com>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Zimny Lech <napohybelskurwysynom2010@gmail.com>,
        Michal Marek <mmarek@suse.cz>, Linus <torvalds@linux-foundation.org>
Subject: Re: on builds/randconfigs (was: [PATCH -next] thermal: depends on
 NET)
Message-Id: <20110113144803.ab311f36.sfr@canb.auug.org.au>
In-Reply-To: <1294890340.26623.383.camel@gandalf.stny.rr.com>
References: <20101213163607.0b0a7c3a.sfr@canb.auug.org.au>
	<alpine.LFD.2.02.1101121257580.18873@x980>
	<20110112131800.d64c1a86.akpm@linux-foundation.org>
	<201101122224.54330.rjw@sisk.pl>
	<alpine.LFD.2.02.1101121654000.19754@x980>
	<20110113114446.cba7a01f.sfr@canb.auug.org.au>
	<1294890340.26623.383.camel@gandalf.stny.rr.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__13_Jan_2011_14_48_03_+1100_17ZRlN9txrA8Vv26"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Jan_2011_14_48_03_+1100_17ZRlN9txrA8Vv26
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Steve,

On Wed, 12 Jan 2011 22:45:40 -0500 Steven Rostedt <rostedt@goodmis.org> wro=
te:
>
> What happens if you have foo depends on bar || fib ?
>=20
> Do you automatically enable bar and fib?

The plan was to error out and let the user decide ... or behave as we do
and just warn?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__13_Jan_2011_14_48_03_+1100_17ZRlN9txrA8Vv26
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNLnXzAAoJEDMEi1NhKgbscz8H/iavKAqEV0vwH0OJLBvuvNJk
H6v2XR1FXZnFTAxwhqBkhKXFHPyr6o/O6pqiyXRjIIjs0cnmJwd3JTGeqEemtuq1
rl5JxuqkSRDvV9kYkkX8dJDHGflGFs71jvS7ujLOjr0pUiNauPONEugIIB+ACDXr
yJRdteM8oMLNNffXzeMtueupDEg+xqkOCS9dyQXvSSFpHf5iS5PlUKgIH3Q8p3pw
qb4fKxdlCIj1etfQ5CV7xEiCWNaZyFmG5HonfW7CBEZWJjqFtV/JL9XdGrw8Ccdk
0Rz9YgDKjlj1oinf4ewBrWodrNWFd/HwwFTYFEPymMfG7EvZSkyELklMlYFtRPA=
=uAh8
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Jan_2011_14_48_03_+1100_17ZRlN9txrA8Vv26--
