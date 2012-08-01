Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab2HAKml (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 06:42:41 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45898 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751127Ab2HAKmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 06:42:40 -0400
Date: Wed, 1 Aug 2012 20:42:26 +1000
From: NeilBrown <neilb@suse.de>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, james.t.kukunas@linux.intel.com,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch] x86, avx: don't use avx instructions with "noxsave"
 boot param
Message-ID: <20120801204226.0b05b63b@notabene.brown>
In-Reply-To: <1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com>
References: <1343688375.3696.597.camel@sbsiddha-desk.sc.intel.com>
	<20120731142049.7d0ab5f9@notabene.brown>
	<7b101443-b8d7-4474-ab54-03692d232469@email.android.com>
	<1343752022.3696.602.camel@sbsiddha-desk.sc.intel.com>
	<50180B2A.6070602@zytor.com>
	<1343755754.2041.2.camel@sbsiddha-desk.sc.intel.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/D28gM1dotlTwWTIm6Ij54XT"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/D28gM1dotlTwWTIm6Ij54XT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 31 Jul 2012 10:29:14 -0700 Suresh Siddha <suresh.b.siddha@intel.com>
wrote:

> On Tue, 2012-07-31 at 09:43 -0700, H. Peter Anvin wrote:
> > My main reason for thinking that it would be good to clear the bits is=
=20
> > that it plays a lot nicer with alternatives and with static_cpu_has().
>=20
> Fair enough. Neil, can you please drop the previous patch and Peter,
> please queue this for v3.6. Thanks.
>

Dropped.  Thanks,

NeilBrown

--Sig_/D28gM1dotlTwWTIm6Ij54XT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUBkIEjnsnt1WYoG5AQIN1RAAreqApbiRaX7d/TdxdFWfjhRQKxVI6few
l2R+AMsAJ10WjWn8eY16MQdzXgVkzKP+znxIsiY0gtDh9cn+hpMKh4cVmflyB9Hx
LRlySCPnWawkbLQ4Aiu9M8H6u58Ayl1XcRIh6K2BIyG6QC/L8mun0Qch3dWRzexF
VWSk14YHoULdGwwjJ09JL+iYr7vF5oIlmZl1LrSWBlqnEs940enfS6uI5V/COnWV
TUIRbLrvRX+YI/O2yHtzmt0GgWOhfei0hQTZCdyCzufL5edAMMtEBpQp/aOfedtv
H60WwO7T7zIQzQNF6WAAw0QLIP7T9g/kWmL02vlQkEfzJK5WW+eWGehFSv7C1cRZ
Pj4EKevG1qQLpTVJNQU8DW1Q9NJ+aTxS7489CT+RHUteYdrTyI8z6DbOeJV8sEI/
Y0XdxvBuj8D3/R+BsuLbmJep2AciXhuhLiNfD+nys2QDkzHqZRkHG+AcvpLVgF8w
ZN999y+yC4mjiSuZR8bKuEM9l6JDHGZ+3K4EqU1RT9EuejLKkAxwF6eqSq//U1g+
OHx+abyltz385i6nnCAsr682DgCYtsLXdwGCmgMIy4oFtVmPG5kD/+RRu54kaQwZ
UDAJToJNgYFwP5cHdjVIZv5a4HKUb+cA/eHkE3BBfzlFT+hNSYSusMANkbnq0Ag7
/eflH9lZuQw=
=/xvO
-----END PGP SIGNATURE-----

--Sig_/D28gM1dotlTwWTIm6Ij54XT--
