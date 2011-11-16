Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752719Ab1KPSf4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Nov 2011 13:35:56 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:38325 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1KPSfz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Nov 2011 13:35:55 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Joe Perches <joe@perches.com>
Subject: Re: [PATCH] MAINTAINERS: update maintainers for blackfin arch and drivers.
Date: Wed, 16 Nov 2011 13:35:54 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: uclinux-dist-devel@blackfin.uclinux.org, Sonic Zhang <sonic.adi@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
References: <1321429708-13862-1-git-send-email-sonic.adi@gmail.com> <201111161211.03784.vapier@gentoo.org> <1321465409.16820.12.camel@Joe-Laptop>
In-Reply-To: <1321465409.16820.12.camel@Joe-Laptop>
MIME-Version: 1.0
Message-Id: <201111161335.55744.vapier@gentoo.org>
Content-Type: multipart/signed;
  boundary="nextPart1983429.PDM65mmKre";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1983429.PDM65mmKre
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Wednesday 16 November 2011 12:43:29 Joe Perches wrote:
> On Wed, 2011-11-16 at 12:11 -0500, Mike Frysinger wrote:
> > On Wednesday 16 November 2011 11:36:15 Joe Perches wrote:
> > > On Wed, 2011-11-16 at 10:20 -0500, Mike Frysinger wrote:
> > > > On Wednesday 16 November 2011 08:12:06 Joe Perches wrote:
> > > > > Drivers or arches without specific people to maintain
> > > > > them really should not have "S: Supported".
> > > > > These should really be "S: Orphan".
> > > >=20
> > > > all the drivers are still maintained.  use the L: option to find the
> > > > maintainer.
> > >=20
> > > I believe I know how the MAINTAINERS
> > > entries work.
> > >=20
> > > From MAINTAINERS:
> > > 	M: Mail patches to: FullName <address@domain>
> > > 	L: Mailing list that is relevant to this area
> > >=20
> > > Mailing lists aren't maintainers.
> >=20
> > they contain all the maintainers
>=20
> That's akin to lkml as the kernel maintainer.

no it isn't

> > > Maybe Analog Devices should create
> > > an email address alias like
> > > linux-devel@analog.com
> >=20
> > so we should duplicate the ml into an alias to keep MAINTAINERS happy ?
>=20
> When there is a company but not individuals responsible for
> an arch or drivers, then yes.

and that company already has a documented contact point.  have you found a=
=20
time when a Blackfin question posted to the list wasn't answered ?  i doubt=
 it.

> > makes no sense.  use the ml.
>=20
> You mean the list that bounces my email?

your e-mail isn't bouncing.  i specifically configured things to silently=20
moderate/accept e-mail from people.
	http://thread.gmane.org/gmane.linux.hardware.blackfin.kernel.devel/6125
(i'd show you this thread, but gmane has a bug when multiple lists are list=
ed=20
and things only get archived under one -- lkml in this case)

and i just checked the configuration.  your e-mail is explicitly listed und=
er=20
the accept_these_nonmembers field.

and i received your original replies via the blackfin ml.  i'm not subscrib=
ed=20
to lkml, so there's no other way i could have seen your posts.
=2Dmike

--nextPart1983429.PDM65mmKre
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOxAKLAAoJEEFjO5/oN/WBuHEQAIJwBBBwBGLiOc3eW0LbzoM/
RQyviGnv6552SFTABBbX6VfgHI8+W+pb1Hx/YmOZ+D4QCqJQNUAopZrZwtSsx82X
+QBa4P5EpOC9L3bs+3KcKx8TslPkn4LcJo4cF7NActORc/pOMnzaZp/4tYhB7+BU
eoeYTt2XaT+dIibUf9YfDesDpR1pSG4hJPie+frx/n4BKpHYbsDrrte4D5muSAA1
7nQImFw/IAflQD0l3v1b4e3htfLPR3X/LvL81kJKwEp3NBEAhqHafN/1pxPvQTKa
1CIouAUM/huVsUvvI3fKNDhGe2/QClWJ/dd3YzWoNhNhdqxrC5R0F2XQOlPv4IsS
e7rvMVV7PBRsnPs+YKvh4DlQ0Gtlkz4CFuQGoPRddhUqBvF4X1b7O3nouW0KAH1I
JFCBtT1Em1SkdtlL5WljYT8Q7TVftLyQNJz+PX11TtJZpHOPUq6sP8YTdwH9Vk4F
gTF0P/DBpgEug3rFJ5GjLKx4R6EbOOa4Xz8T5ei/o6mqmLMRv8JEsT92e8P6uIXA
YJ1l8EbnglYZtC6biuWwAaCQzoKpAsd2z9/3FIXVGoXjvYA62mgoJB09aBN967sE
zMBJQtwRqtouR/1NVUcW2luU1rh6zXAG+qbXAMklRe06JC0SeYa2OE7PwTf6LQaY
ob042vRGygTr9G4QNsTr
=ZgeA
-----END PGP SIGNATURE-----

--nextPart1983429.PDM65mmKre--
