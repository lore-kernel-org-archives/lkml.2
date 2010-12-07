Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754715Ab0LGPkF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 10:40:05 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34282 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754058Ab0LGPkE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 10:40:04 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: bugs/regressions: report in LKML or in bugzilla?
Date: Tue, 7 Dec 2010 16:39:46 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-rc5-tp42; KDE/4.5.3; i686; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2192436.gHIMNDF4B7";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201012071639.58884.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2192436.gHIMNDF4B7
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi!

I reported some regressions to bugzilla that did not receive any=20
attentation so far:

[Bug 23792] New: openvpn: failure to unregister tap1 device, possibly=20
related to some netconsole issue
https://bugzilla.kernel.org/show_bug.cgi?id=3D23792

[Bug 23642] New: easycap driver fails to compile in 2.6.37-rc3
https://bugzilla.kernel.org/show_bug.cgi?id=3D23642


A participant of a linux performance training I hold found a bug with=20
window scaling which did not receive any reply as well:

Bug 20312 -  System freeze with multiples of 32 in=20
/proc/sys/net/ipv4/tcp_adv_win_scale
https://bugzilla.kernel.org/show_bug.cgi?id=3D20312


Is it better to report on LKML? I have the impression that bug reports=20
onto the mailinglist are more easily recognized.

I also find it difficult to find the right component when reporting a probl=
em=20
in bugzilla. Thus reports might not go to the right persons.

Please advice.

Ciao,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart2192436.gHIMNDF4B7
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkz+VUMACgkQmRvqrKWZhMeooQCeOfMOU4HlGWBlUXIdp8sutXnY
JYEAoLyV89/p4CHHD5Uis7iqwPeh/Ka8
=zE1d
-----END PGP SIGNATURE-----

--nextPart2192436.gHIMNDF4B7--
