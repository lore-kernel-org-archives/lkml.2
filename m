Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab2D3XgF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 19:36:05 -0400
Received: from cantor2.suse.de ([195.135.220.15]:40788 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756638Ab2D3XgD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 19:36:03 -0400
Date: Tue, 1 May 2012 09:35:59 +1000
From: NeilBrown <neilb@suse.de>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-serial@vger.kernel.org, linux-pm@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: Question:  How to power-manage UART-attached devices.
Message-ID: <20120501093559.5c14087d@notabene.brown>
In-Reply-To: <20120430223322.GA3951@sirena.org.uk>
References: <20120501082209.0b560708@notabene.brown>
	<20120430223322.GA3951@sirena.org.uk>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rSH_kM2jiGHyad894vRlAGW"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/rSH_kM2jiGHyad894vRlAGW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Apr 2012 23:33:22 +0100 Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:

> On Tue, May 01, 2012 at 08:22:09AM +1000, NeilBrown wrote:
>=20
> >  The question is how can user-space tell the kernel that these devices =
are
> >  'inactive'?
>=20
> >  I would like to integrate this into Linux in the most  "natural" way t=
hat I
> >  can but am having trouble.  My current approach involves using "rfkill=
" but
> >  that doesn't work very well for reasons that are probably not very rel=
evant
> >  here.  It probably does make sense for powering the GPS antenna, but n=
ot
> >  much else.
>=20
> The userspace consumer was added for users like this that live entirely
> in userspace.

Hi Mark,
 thanks for the reply.

 I assume you mean REGULATOR_VIRTUAL_CONSUMER (drivers/regulator/virtual.c)?

 The one where the Kconfig entry says:
    This is mainly useful for test purposes.

 That certainly was useful for test purposes but I want to move beyond
 testing.

 One of the purposes of an operating system is to provide useful abstractio=
ns
 and hide irrelevant details, so I don't want user-space to have to
 explicitly enable a regulator.
 I could cope with an 'on/off switch' abstraction.  It might then enable a
 regulator. In the case of the GPS device it would need to both enable a
 regulator and toggle a GPIO line.  I really don't want user-space to "know"
 that it has to turn on a regulator and toggle a gpio line...

 So I'm still hoping for something more abstract.

Thanks,
NeilBrown

--Sig_/rSH_kM2jiGHyad894vRlAGW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT58h3znsnt1WYoG5AQKdAg/+Mscg7Q/N/P7TadHWa+zcGUAkWelQ1xZG
PPMNxgW8PPw8kPwmB/uzpC6dG3sL0zoRZEEULdi8U8ItIJCl3y9P3B0cFjpL0vgm
U87MVeCRyQIY5OGFe/FI7MZPGxBCCiKlvPutWVUIBHrDgNCz0F4ycLtV7yMZj/Fq
sRxa5TZJuACW8kBEj5892zW0ShXHe7ie0J2UIOpaW2UdtLPJImd1uAebhvxi05jD
2Om0yTl/qkBeevfTs2nHxNSOg4R4KhDLQqWbiuuZA+pDyPRiTN2x3y1lQYPKChR5
E9P342fse7w6R1X7StOyhx1XfqOvHy/iworv15mJHGvYaUZuIQyE1EM0f6HKHxpo
0/nRKHP//rvbyZ1Q6B66FYfJ3B/PjUcyDgyM2ORApNa8TndmUWP0AvPSQYkt99oW
35rW7bGoohZsptwFs1lMzdNoCuQx3MVvHzukQAkqaeDVJQP58v9/WEGWs1CGVYDk
MEo6lKwu8SCjMlgjHnzjMa3gedEemrFRUKUo/l8KsPjWZnQ6DpfJtEnRNmxbS5ar
gISMNJMjXPSBZuNNrLrz4vHniYFOr2Va2alD204QabdcQoEMuzD2acwe1frUbtRd
ptbPdjej7buP3ApSwIZGabYj2OU5B/kzHBLz0MV6AiDxDAvtOUhlfUtU5UlyonkE
ntoUxhChEw0=
=P9jY
-----END PGP SIGNATURE-----

--Sig_/rSH_kM2jiGHyad894vRlAGW--
