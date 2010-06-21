Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753704Ab0FUWUM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 18:20:12 -0400
Received: from mail.gmx.net ([213.165.64.20]:52671 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752504Ab0FUWUK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 18:20:10 -0400
X-Authenticated: #1587495
X-Provags-ID: V01U2FsdGVkX19l+ZxRVxxlAVp/WJNh5y3upxjzO+3cWwginJ6P/8
	OjGaB9Hsu7VcWU
From: "Stefan Lippers-Hollmann" <s.L-H@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #15589] 2.6.34-rc1: Badness at fs/proc/generic.c:316
Date: Tue, 22 Jun 2010 00:19:34 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-0.slh.7-sidux-686; KDE/4.4.4; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>
References: <g77CuMUl7QI.A.qMH.4ZpHMB@chimera> <rHrHQMIU4rI.A.5FD.vepHMB@chimera>
In-Reply-To: <rHrHQMIU4rI.A.5FD.vepHMB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1370548.zVSHKF1gOA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201006220019.34874.s.L-H@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1370548.zVSHKF1gOA
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Hi

On Tuesday 22 June 2010, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.33 and 2.6.34.
>=20
> The following bug entry is on the current list of known regressions
> introduced between 2.6.33 and 2.6.34.  Please verify if it still should
> be listed and let the tracking team know (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D15589
> Subject		: 2.6.34-rc1: Badness at fs/proc/generic.c:316
> Submitter	: Christian Kujau <lists@nerdbynature.de>
> Date		: 2010-03-13 23:53 (100 days old)
> Message-ID	: < <AANLkTikNcCtUn9SQwKu2b3IE6NiAwAhciHsm1HVH4EJh@mail.gmail.=
com>>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D126852442903680&w=3D2
> Handled-By	: Michael Ellerman <michael@ellerman.id.au>
> 		  Jind=C5=99ich Makovi=C4=8Dka <makovick@gmail.com>
> Patch		: http://patchwork.ozlabs.org/patch/52978/
> 		  http://lkml.indiana.edu/hypermail/linux/kernel/1006.0/00137.html

At least the effects on b2c2-flexcop-pci are still valid, in linux-2.6
HEAD and linux-next (next-20100621).

Regards
	Stefan Lippers-Hollmann

--nextPart1370548.zVSHKF1gOA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwf5XYACgkQORbEMfgJlPZVlACdE1/k3U7a8zNYIj6J9x9CKrmW
wS8Ani/xU9WEn/M/7e76/GpRQKVcUIk6
=fnak
-----END PGP SIGNATURE-----

--nextPart1370548.zVSHKF1gOA--
