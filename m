Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754097Ab0CVPeb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 11:34:31 -0400
Received: from gabe.freedesktop.org ([131.252.210.177]:59469 "EHLO
	gabe.freedesktop.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753378Ab0CVPea (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 11:34:30 -0400
From: Eric Anholt <eric@anholt.net>
To: Karl Vogel <karl.vogel@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915 lockup / extreme delay
In-Reply-To: <bad735c81003220111y44bfb828vfd4c9fbbcabf3419@mail.gmail.com>
References: <ho2jal$oqs$1@dough.gmane.org>
	<87wrx5m1h3.fsf@pollan.anholt.net>
	<bad735c81003220111y44bfb828vfd4c9fbbcabf3419@mail.gmail.com>
Date: Mon, 22 Mar 2010 08:34:21 -0700
Message-ID: <87634oid4y.fsf@pollan.anholt.net>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha1; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Mon, 22 Mar 2010 09:11:06 +0100, Karl Vogel <karl.vogel@gmail.com> wrote:
> On Mon, Mar 22, 2010 at 5:20 AM, Eric Anholt <eric@anholt.net> wrote:
> > On Sat, 20 Mar 2010 14:41:41 +0100, Karl Vogel <karl.vogel@gmail.com> w=
rote:
> >> The 'effect' is that only the mouse pointer works in the X server. The
> >> cpu usage on the laptop during the sluggishness is minimal. When I
> >> suspend the game with winedbg, the X server slowly becomes responsive =
again.
> >>
> >> The output from latencytop seems to point to i915 being the culprit:
> >
> > If there's some code doing glFlush()es, it's probably that code at
> > fault. =C2=A0You don't need to do that unless you're doing frontbuffer
> > rendering, and if you're doing frontbuffer rendering you should really
> > be doing backbuffer rendering. =C2=A0I don't see a kernel issue here.
>=20
> That doesnt explain why the box completely locks up on 2.6.34-rc2
> though, where only a cold reboot works.

Missed that part of the message.  If there's a regression, bisect
please.

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkunjf0ACgkQHUdvYGzw6vc9AQCgi6HbFzYmWTP51+M4kDFEjQN3
UkEAn0xiTdaYR6NN+Zlo3Ifz2p5KEPNY
=uK1v
-----END PGP SIGNATURE-----
--=-=-=--
