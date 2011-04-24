Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757428Ab1DXLsP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 07:48:15 -0400
Received: from mail.klingt.org ([86.59.21.178]:43416 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756598Ab1DXLsK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 07:48:10 -0400
From: Tim Blechmann <tim@klingt.org>
To: Lin Ming <ming.m.lin@intel.com>
Subject: Re: [2.6.39-rc2] perf top fails to mmap - bisected to 70db7533
Date: Sun, 24 Apr 2011 13:47:52 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc4+; KDE/4.6.2; x86_64; ; )
Cc: David Ahern <dsahern@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <inhgjs$54a$1@dough.gmane.org> <BANLkTikWpnnHAfO2n2rN6ExtQyrsVaiqEQ@mail.gmail.com> <1303570271.3363.4.camel@localhost>
In-Reply-To: <1303570271.3363.4.camel@localhost>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart6037847.iQ4GQFuWLV";
  protocol="application/pgp-signature";
  micalg=pgp-sha256
Content-Transfer-Encoding: 7bit
Message-Id: <201104241347.52486.tim@klingt.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.8 (klingt.org [86.59.21.178]); Sun, 24 Apr 2011 13:47:54 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart6037847.iQ4GQFuWLV
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> > > I know you've been busy with other stuff the past few weeks, but have
> > > you had a chance to look into this? Basically, perf in 2.6.39 is brok=
en
> > > when trying to profile a process (-p argument to record or top).
> >=20
> > Let me take a look at this.
>=20
> Below patch fixes the same problem on my box.
> Could you have a try it?

i have done some quick tests with this patch applied on linus/master ... wo=
rks=20
fine for me, thanks a lot!

> >From 89f1ab02cd8da55f8829b2f2d7e700fdae77b3af Mon Sep 17 00:00:00 2001
>=20
> From: Lin Ming <ming.m.lin@intel.com>
> Date: Sat, 23 Apr 2011 14:54:33 +0000
> Subject: [PATCH] perf: Allow set output event for task in the same thread
> group
>=20
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

Tested-by: Tim Blechmann <tim@klingt.org>

cheers, tim

=2D-=20
tim@klingt.org
http://tim.klingt.org

When you open windows, bugs get in.

--nextPart6037847.iQ4GQFuWLV
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iF4EABEIAAYFAk20DegACgkQMLNj2qIwZ4WQogEAlt+stEA/rdtpcQV097iZVujs
ZPeUK1m1P/6lSFM4zWcA/RXiGverrigq9jyX6ae/UmF8a5DKdrjcSCq0KmD4poNs
=jn34
-----END PGP SIGNATURE-----

--nextPart6037847.iQ4GQFuWLV--
