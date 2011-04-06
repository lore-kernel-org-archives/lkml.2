Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755596Ab1DFU5J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 16:57:09 -0400
Received: from mail.klingt.org ([86.59.21.178]:56534 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754523Ab1DFU5I (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 16:57:08 -0400
X-Greylist: delayed 515 seconds by postgrey-1.27 at vger.kernel.org; Wed, 06 Apr 2011 16:57:07 EDT
From: Tim Blechmann <tim@klingt.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Subject: Re: [2.6.39-rc2] perf top fails to mmap
Date: Wed, 6 Apr 2011 22:48:23 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.39-rc2; KDE/4.6.1; x86_64; ; )
Cc: David Ahern <dsahern@gmail.com>, linux-kernel@vger.kernel.org
References: <inhgjs$54a$1@dough.gmane.org> <4D9C84D5.6090303@gmail.com> <20110406175217.GC4987@ghostprotocols.net>
In-Reply-To: <20110406175217.GC4987@ghostprotocols.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1903665.V4RLcxk7Aq";
  protocol="application/pgp-signature";
  micalg=pgp-sha256
Content-Transfer-Encoding: 7bit
Message-Id: <201104062248.23853.tim@klingt.org>
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.8 (klingt.org [86.59.21.178]); Wed, 06 Apr 2011 22:48:26 +0200 (CEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1903665.V4RLcxk7Aq
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> > David
> >=20
> > > this happens when running perf as the same process as the process and
> > > when running perf as root.
>=20
> yep, works for me as well:
>=20
> [acme@emilia ~]$ cat vsyscall.c

after including unistd.h, this compiles and works fine. however i cannot pr=
ofile=20
any multithreaded program. does this work for you?

tim

=2D-=20
tim@klingt.org
http://tim.klingt.org

The most wonderful opportunity which life offers is to be human.
  Henry Miller

--nextPart1903665.V4RLcxk7Aq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iF4EABEIAAYFAk2c0ZcACgkQMLNj2qIwZ4V9swD/c7ulLfRk4N0m3U66ROuhWRYO
W/BR+NJrcCzZy315eN4BAKMg+sE2jQwa+week/MV7QEFIJZvO7Knp0xjQnOQaNGW
=fJzL
-----END PGP SIGNATURE-----

--nextPart1903665.V4RLcxk7Aq--
