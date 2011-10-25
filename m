Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756162Ab1JYJxP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 05:53:15 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:36755 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752392Ab1JYJxO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 05:53:14 -0400
Message-ID: <1319536366.11727.0.camel@deadeye>
Subject: Re: [PATCH] module,bug: Add TAINT_OOT_MODULE flag for modules not
 built in-tree
From: Ben Hutchings <ben@decadent.org.uk>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Randy Dunlap <rdunlap@xenotime.net>, LKML <linux-kernel@vger.kernel.org>,
        Dave Jones <davej@redhat.com>, Greg KH <greg@kroah.com>,
        Debian kernel maintainers <debian-kernel@lists.debian.org>
Date: Tue, 25 Oct 2011 11:52:46 +0200
In-Reply-To: <87k47tpvvm.fsf@rustcorp.com.au>
References: <1319461948.31243.31.camel@deadeye>
	 <4EA57CBF.2050901@xenotime.net> <87k47tpvvm.fsf@rustcorp.com.au>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-tqstAQ04gcueVb92HXqG"
X-Mailer: Evolution 3.0.3-2 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 85.13.70.251
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-tqstAQ04gcueVb92HXqG
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2011-10-25 at 14:26 +1030, Rusty Russell wrote:
> On Mon, 24 Oct 2011 07:57:03 -0700, Randy Dunlap <rdunlap@xenotime.net> w=
rote:
> > On 10/24/11 06:12, Ben Hutchings wrote:
> > > Use of the GPL or a compatible licence doesn't necessarily make the c=
ode
> > > any good.  We already consider staging modules to be suspect, and thi=
s
> > > should also be true for out-of-tree modules which may receive very
> > > little review.
> > >=20
> > > Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> > > ---
> > > Debian has been carrying this for the last few kernel versions.  The
> > > recent thread '[RFC] virtualbox tainting.' and discussions at KS sugg=
est
> > > that this might be more generally useful.
> > >=20
> > > Ben.
> > >=20
> > >  include/linux/kernel.h |    1 +
> > >  kernel/module.c        |    5 +++++
> > >  kernel/panic.c         |    2 ++
> > >  scripts/mod/modpost.c  |    7 +++++++
> > >  4 files changed, 15 insertions(+), 0 deletions(-)
> >=20
> > Hi,
> >=20
> > Please add 'O' to Documentation/oops-tracing.txt.

Sorry, this is the second time I've missed that now...

> I did that, and applied the patch.  See below.
[...]

Thanks to everyone.

Ben.

--=20
Ben Hutchings
DNRC Motto:  I can please only one person per day.
Today is not your day.  Tomorrow isn't looking good either.

--=-tqstAQ04gcueVb92HXqG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATqaG7ue/yOyVhhEJAQoBHBAAoIZ/IVe1jtL/FBQ6xC6zs6xL19Y3dIVM
C1h7N5Ta6BqgNPWmRaP2vi9p7iMP1JZv8e8HKIZbzcZcgZXclU0XrYTZ6lF7jVUP
f3JK3cbNCqv7sP49/kKd+c9NBRaDabazVz032FecAi1CxBkHDDCjzWGG/UceSDI4
5mM2zlIA4DnCslekz7xmzk8kC6FWE/4G6uQFUeUrqr69tMC4V8nCOigT3OfbwKUI
xG8JhJzbf16sCjBm3M424y3dYnMPQUFLxPWyfPkaDlM3agaHNAN6mmOG04WHCvr4
MukctG7AXLOY0WyDbCZHTKeCb601k92F4G2Vk7244zIndTlfQ7i7uEb9jakJIu20
KXsWILN4IKDChbMnQYQiEIuB/G+HwYhaYT3mMgo3gWS8KNgu6mmjxr1s9G9zNyLO
+5xd1+ZmU+SOzaLckDaQIc78ARgm9KaZX84JFh9+HMMZiQyWjFC35YLltK6ySihz
mP+BjTEAnA0lMjMIFeoovfrBLMgBshclN5lm3SaoEcdbk4OXuphchffxhYBXxt+m
wj3NLDXbWvwKDF4Bs3SMaq51YMNnqLnBXtkZoUddlIL3/QgDD0Pbsph6feibQ+40
dvdM1nuSGW06vh8u9b7dogDyNpoY5w6PQMPWlnhAde9OoHcIRqMOOpqDsnq9IEG9
gelza3X3tHQ=
=xz0B
-----END PGP SIGNATURE-----

--=-tqstAQ04gcueVb92HXqG--
