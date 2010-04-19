Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752677Ab0DSSmg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Apr 2010 14:42:36 -0400
Received: from diva.malsain.org ([91.121.19.57]:35646 "EHLO diva.malsain.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751209Ab0DSSmf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Apr 2010 14:42:35 -0400
Subject: Re: Athlon L110 CPU and powernow-k8
From: Josselin Mouette <joss@debian.org>
To: "Langsdorf, Mark" <mark.langsdorf@amd.com>
Cc: "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
In-Reply-To: <DDE95BDD51FB774B804A9C029E735EE103E9BF5129@sausexmbp02.amd.com>
References: <20100418102608.GA29846@a1.tnic>
	 <DDE95BDD51FB774B804A9C029E735EE103E9BF5129@sausexmbp02.amd.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-n2LVgSr+A9bPte0jJO0v"
Date: Mon, 19 Apr 2010 20:42:14 +0200
Message-ID: <1271702534.6445.9.camel@tomoyo>
Mime-Version: 1.0
X-Mailer: Evolution 2.29.92.1 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-n2LVgSr+A9bPte0jJO0v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lundi 19 avril 2010 =C3=A0 06:43 -0700, Langsdorf, Mark a =C3=A9crit :=
=20
> > I wonder what is possible to do to support this CPU correctly in the
> > kernel. The only sane solution I can think of is to hardcode the
> > P-states for this CPU model in the powernow-k8 driver itself.=20
>=20
> I think that hard-coding P-states into the PowerNow=20
> driver is not a mantainable solution.

I agree this is not optimal, but I think there are similar bits in other
drivers.=20

> I don't quite understand why the you think that
> a custom DSDT as a BIOS hack, but think that
> adding custom frequencies to the driver itself is
> acceptable.

The first solution implies building a custom kernel before being able to
use the system. The second solution does not. I=E2=80=99m looking for a sol=
ution
that works out of the box, and does not require to be able to compile
ASL code nor a kernel.

> The last time this issue came up on cpufreq, Dave
> Jones nixed a general solution to add custom P-states
> through the driver on the grounds that people would
> undervolt their systems, causing a lot of screwy,
> unpredictable behavior.  I agreed with his opinion
> then and I don't see anything in this mesage to
> change that view.

If you want to screw your system, this is already feasible by hacking
the DSDT table itself. Granted, this is not the kind of stuff the
average n00b would do.

Given how Acer doesn=E2=80=99t give a shit about OSes other than XP - not e=
ven
other Windows versions - I don=E2=80=99t think they are likely to provide a
fixed BIOS. If they can be convinced, I don=E2=80=99t know how. And if they
can=E2=80=99t - what are we left with?

Cheers,
--=20
 .''`.      Josselin Mouette
: :' :
`. `'  =E2=80=9CIf you behave this way because you are blackmailed by someo=
ne,
  `-    [=E2=80=A6] I will see what I can do for you.=E2=80=9D  -- J=C3=B6r=
g Schilling

--=-n2LVgSr+A9bPte0jJO0v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iD8DBQBLzKP0rSla4ddfhTMRAkzWAKDAXEW79oa3Z737GcBo9EI8lVL5qwCdFg+s
fGdu05IeoHTy5cVkjEoyCJs=
=UsIZ
-----END PGP SIGNATURE-----

--=-n2LVgSr+A9bPte0jJO0v--

