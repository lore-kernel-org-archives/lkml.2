Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751229Ab1LKIO4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Dec 2011 03:14:56 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:42324 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1LKIOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Dec 2011 03:14:52 -0500
Date: Sun, 11 Dec 2011 11:17:57 +0300
From: Sergei Trofimovich <slyich@gmail.com>
To: Rob Landley <rob@landley.net>
Cc: Aboriginal Linux <aboriginal@lists.landley.net>,
        linux-kernel@vger.kernel.org, davem@davemloft.net, tytso@mit.edu,
        sparclinux@vger.kernel.org
Subject: Re: Sparc-32 doesn't work in 3.1.
Message-ID: <20111211111801.5942ab39@sf.home>
In-Reply-To: <4EBF0A25.20604@landley.net>
References: <4EBEAB5A.5020809@landley.net>
	<4EBF0A25.20604@landley.net>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/pZck.4vr/YOQgm3vTbQyA5A"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/pZck.4vr/YOQgm3vTbQyA5A
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

> >   Boot time fixup v1.6. 4/Mar/98 Jakub Jelinek (jj@ultra.linux.cz).
> >   Patching kernel for srmmu[Fujitsu TurboSparc]/iommu
> >   Fixup i f029ddfc doesn't refer to a valid instruction at
> >   f00de648[95eea000]
> >   halt, power off
>=20
> If anyone would like a reproduction sequence for this, the toolchain I use
> (which compiles commit 9933fc0ac1ac14b^1 just fine) is at:
>=20
>   http://landley.net/aboriginal/downloads/binaries/cross-compiler-sparc.t=
ar.bz2

Tried to build both with your crosscompiler and with gcc-4.5.3/binutils-2.2=
1.1
Both boot but don't get to prompt (minimal config I guess).
(v3.1 works the same as 3.2.0-rc5)

Linux version 3.2.0-rc5 (slyfox@sf) (gcc version 4.2.1) #1 Sun Dec 11 11:08=
:25 FET 2011
bootconsole [earlyprom0] enabled
ARCH: SUN4M
TYPE: SPARCstation 5
Ethernet address: 52:54:00:12:34:56
Boot time fixup v1.6. 4/Mar/98 Jakub Jelinek (jj@ultra.linux.cz). Patching =
kernel for srmmu[Fujitsu TurboSparc]/iommu
OF stdout device is: /obio/zs@0,100000:a
PROM: Built device tree with 23073 bytes of memory.
Booting Linux...
Power off control detected.
Built 1 zonelists in Zone order, mobility grouping on.  Total pages: 28018
...
mousedev: PS/2 mouse device common for all mice
rtc-m48t59 rtc-m48t59.0: rtc core: registered m48t08 as rtc0
turn off boot console earlyprom0

Can you share broken image to drive out qemu bug? (0.14.0 is here)

--=20

  Sergei

--Sig_/pZck.4vr/YOQgm3vTbQyA5A
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEYEARECAAYFAk7kZ0EACgkQcaHudmEf86q1mgCfZkl4j/qAzeMMnF9VFDKmrW7H
028An35PKVamIIN047imIv4RXGJV4Ml9
=vKyz
-----END PGP SIGNATURE-----

--Sig_/pZck.4vr/YOQgm3vTbQyA5A--
