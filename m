Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752605Ab1CEOKo (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 09:10:44 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46791 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750853Ab1CEOKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 09:10:43 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: LKML <linux-kernel@vger.kernel.org>
Subject: [regression] 2.6.37-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Date: Sat, 5 Mar 2011 15:10:24 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7-tp42-00142-g212e349; KDE/4.5.3; i686; ; )
Cc: DRI <dri-devel@lists.freedesktop.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4188849.Ju5I9lK7Lo";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103051510.35057.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4188849.Ju5I9lK7Lo
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

I will add a regression entry in bugzilla after I got the URL of that=20
mail.


Hi!

No, I do not actively search for lockup bugs, but they seem to search me=20
;).


martin@shambhala:~> cat /proc/version
Linux version 2.6.38-rc7-tp42-00142-g212e349 (martin@shambhala) (gcc=20
version 4.4.5 (Debian 4.4.5-11) ) #4 PREEMPT Sat Mar 5 12:03:41 CET 2011

locks up hard when using desktop cube of kwin from KDE 4.5.1.

It happens within a few seconds to about 30 seconds after activating the=20
effect with Ctrl-F11. Otherwise the machine seems to work fine so far - if=
=20
that continues I do not have much of a problem with the bug since I do not=
=20
use desktop cube other than for getting a feel of compositing performance.=
=20
Effects seem to be more fluent, more smooth anyway, I guess due to Radeon=20
KMS page flipping.

I am using X.org 1.9.4 with Radeon driver 1:6.14.0-1 on Debian=20
Wheezy/Sid/Experimental on a ThinkPad T42 with:

martin@shambhala:~> lspci -nn | grep VGA
01:00.0 VGA compatible controller [0300]: ATI Technologies Inc RV350=20
[Mobility Radeon 9600 M10] [1002:4e50]

This didn't happen with 2.6.37-tp42-rtime-00004-g9eb63ce, same gcc.

Possibly related to bug #28622 "radeon video lookup".


As I am in my holidays in Sevilla I will only care about bisecting when it=
=20
rains three days in a row ;) - cause I insist on my holidays being=20
holidays and so will only do light kernel testing ;). I wanted to report=20
this nonetheless since at least on my machine this is really easy to=20
reproduce.=20

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart4188849.Ju5I9lK7Lo
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk1yRFEACgkQmRvqrKWZhMfx4gCgnh28dsa98TtRIhD+BpudTBJi
uaIAn0/7wv35NLavahybbEjskM2CfFRz
=cspj
-----END PGP SIGNATURE-----

--nextPart4188849.Ju5I9lK7Lo--
