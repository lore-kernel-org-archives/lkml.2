Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751402Ab0GKHSq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 03:18:46 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:43456 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751059Ab0GKHSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 03:18:44 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: stable? quality assurance?
Date: Sun, 11 Jul 2010 09:18:41 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34.1-tp42-toi-3.1.1.1-04990-g3a7d1f4; KDE/4.4.4; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart17054977.hqOqUHc71d";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201007110918.42120.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart17054977.hqOqUHc71d
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


Hi!

2.6.34 was a desaster for me: bug #15969 - patch was availble before=20
2.6.34 already, bug #15788, also reported with 2.6.34-rc2 already, as well=
=20
as most important two complete lockups - well maybe just X.org and radeon=20
KMS, I didn't start my second laptop to SSH into the locked up one - on my=
=20
ThinkPad T42. I fixed the first one with the patch, but after the lockups I=
=20
just downgraded to 2.6.33 again.

I still actually *use* my machines for something else than hunting patches=
=20
for kernel bugs and on kernel.org it is written "Latest *Stable* Kernel"=20
(accentuation from me). I know of the argument that one should use a=20
distro kernel for machines that are for production use. But frankly, does=20
that justify to deliver in advance known crap to the distributors? What=20
impact do partly grave bugs reported on bugzilla have on the release=20
decision?

And how about people who have their reasons - mine is TuxOnIce - to=20
compile their own kernels?

Well 2.6.34.1 fixed the two reported bugs and it seemed to have fixed the=20
freezes as well. So far so good.

Maybe it should read "prerelease of stable" for at least 2.6.34.0 on the=20
website. And I just again always wait for .2 or .3, as with 2.6.34.1 I=20
still have some problems like the hang on hibernation reported in

hang on hibernation with kernel 2.6.34.1 and TuxOnIce 3.1.1.1

on this mailing list just a moment ago. But then 2.6.33 did hang with=20
TuxOnIce which apparently (!) wasn't a TuxOnIce problem either, since=20
2.6.34 did not hang with it anymore which was a reason for me to try=20
2.6.34 earlier.

I am quite a bit worried about the quality of the recent kernels. Some=20
iterations earlier I just compiled them, partly even rc-ones which I do=20
not expact to be table, and they just worked. But in the recent times .0,=20
partly even .1 or .2 versions haven't been stable for me quite some times=20
already and thus they better not be advertised as such on kernel.org I=20
think. I am willing to risk some testing and do bug reports, but these are=
=20
still production machines, I do not have any spare test machines, and=20
there needs to be some balance, i.e. the kernels should basically work.=20
Thus I for sure will be more reluctant to upgrade in the future.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart17054977.hqOqUHc71d
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkw5cFIACgkQmRvqrKWZhMexfgCguC64G4FTWO2pc2C+AXEakA0N
dyMAoLJOpRGiXI3oGytkjJ9nJrxEitgI
=t+jQ
-----END PGP SIGNATURE-----

--nextPart17054977.hqOqUHc71d--
