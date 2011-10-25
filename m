Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933413Ab1JYQG1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 12:06:27 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:39494 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751451Ab1JYQG0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 12:06:26 -0400
Message-ID: <1319558749.11727.6.camel@deadeye>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
From: Ben Hutchings <ben@decadent.org.uk>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Randy Dunlap <rdunlap@xenotime.net>,
        LKML <linux-kernel@vger.kernel.org>, Dave Jones <davej@redhat.com>,
        Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Tue, 25 Oct 2011 18:05:49 +0200
In-Reply-To: <20111025153855.GA24779@elliptictech.com>
References: <1319461948.31243.31.camel@deadeye>
	 <4EA57CBF.2050901@xenotime.net> <87k47tpvvm.fsf@rustcorp.com.au>
	 <20111025153855.GA24779@elliptictech.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-U8XN+aT28KBlU4vpvp+C"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 85.13.70.251
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-U8XN+aT28KBlU4vpvp+C
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-10-25 at 11:38 -0400, Nick Bowler wrote:
> On 2011-10-25 14:26 +1030, Rusty Russell wrote:
> > From: Ben Hutchings <ben@decadent.org.uk>
> > Subject: module,bug: Add TAINT_OOT_MODULE flag for modules not built in=
-tree
> > Date: Mon, 24 Oct 2011 15:12:28 +0200
> >=20
> > Use of the GPL or a compatible licence doesn't necessarily make the cod=
e
> > any good.  We already consider staging modules to be suspect, and this
> > should also be true for out-of-tree modules which may receive very
> > little review.
> >=20
> > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > Reviewed-by: Dave Jones <davej@redhat.com>
> > Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
> > Signed-off-by: Rusty Russell <rusty@rustcorp.com.au> (patched oops-trac=
ing.txt)
> > ---
> >  Documentation/oops-tracing.txt |    2 ++
> >  include/linux/kernel.h         |    1 +
> >  kernel/module.c                |    5 +++++
> >  kernel/panic.c                 |    2 ++
> >  scripts/mod/modpost.c          |    7 +++++++
> >  5 files changed, 17 insertions(+)
>=20
> This patch prevents the use of lockdep for debugging out of tree
> modules, which is rather mean.

It was already disabled for staging modules, which seems equally
unhelpful.  Maybe it should print taint flags at the top of its warnings
instead.

Ben.

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-U8XN+aT28KBlU4vpvp+C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATqbeXee/yOyVhhEJAQrslg//U0R8PUtXH718072OArGpLfstjwQX+L0U
oTMXOBWBX9Y2hheKlmQ8GklSWpjxW1/jA7xaku5IwNvb7Mc5+3leSW0p5a5n/5Qg
IHHBIpxwNrgqFaaKwL4jLi7sDmrJWBsB4JoIUK36MXPDQSd2Z5t52QbYyKgjRVfv
L+fOBYqv1YFp12YD9F9/7uSLBx9PSjDZz/De+9LPqDFlJY688iQ8PBg2affX49uZ
eVjIlWLHbq0zcETUWyt5VRTAwABQUbF2phRsKB/JTpjkovTZ/4OaToHzCjC/+X0d
LZsB3WaWVLx1+2JfCC/05Ce1Q3i/GRN+IjbOE4fpVtbMqkXaRCPU4ih3Dv9gQyXz
aqxkdQu3LY0jahJ7wU5ZCbJfZaxP4jAZm5L+UiWc4LJ/uHiIDLrEJsTr5rylpxy/
M3G7bkceG/QEZl01flUhy2wmHMTRqKmMHBxdy1JyMiRstndpNNXcsqMAE24mXIAr
jY9UHzpsbNgHAHYLM/FBYXeuv1++T6JwfxXw8aGxQrBQeN2t8bwLjk2ejawKXen0
sMY/u0XfZ9HDpmxhlULsi3gphJ4+03nE3KvTqbvkhgABohqs2LX2Gefijo+MyvmZ
CrupVyoC/g5xWHL0co1t+3yPAv/vp3/r4KGmkTRYAIN+9L/Ft8gb8r33Q3ucprEX
Yhcu9ZXS9pM=
=TQbG
-----END PGP SIGNATURE-----

--=-U8XN+aT28KBlU4vpvp+C--
