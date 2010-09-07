Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756030Ab0IGFm3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 01:42:29 -0400
Received: from mailsrv1.zmi.at ([212.69.164.54]:48664 "EHLO mailsrv14.zmi.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751083Ab0IGFmY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 01:42:24 -0400
From: Michael Monnerie <michael.monnerie@is.it-management.at>
Organization: it-management http://it-management.at
To: linux-kernel@vger.kernel.org
Subject: kernel crash 2.6.35.4 as XEN client on a XenServer 5.6
Date: Tue, 7 Sep 2010 07:42:13 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.35.4-zmi; KDE/4.3.5; x86_64; ; )
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart7134026.fN8FR11l1l";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009070742.19319@zmi.at>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart7134026.fN8FR11l1l
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

I just tried to run a self compiled kernel as XEN guest on a XenServer=20
5.6, but get these crashes during boot. I had to take screenshots, and=20
they are overlapping, but at least no line is missing:

http://zmi.at/x/crash1.jpg
http://zmi.at/x/crash2.jpg
http://zmi.at/x/crash3.jpg
http://zmi.at/x/crash4.jpg
http://zmi.at/x/crash5.jpg
http://zmi.at/x/crash6.jpg
http://zmi.at/x/crash7.jpg
http://zmi.at/x/crash8.jpg
http://zmi.at/x/crash9.jpg
http://zmi.at/x/crashA.jpg
http://zmi.at/x/crashB.jpg

Did I miss some options during kernel compile?

=2D-=20
mit freundlichen Gr=C3=BCssen,
Michael Monnerie, Ing. BSc

it-management Internet Services
http://proteger.at [gesprochen: Prot-e-schee]
Tel: 0660 / 415 65 31

****** Aktuelles Radiointerview! ******
http://www.it-podcast.at/aktuelle-sendung.html

// Wir haben im Moment zwei H=C3=A4user zu verkaufen:
// http://zmi.at/langegg/
// http://zmi.at/haus2009/

--nextPart7134026.fN8FR11l1l
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.12 (GNU/Linux)

iEYEABECAAYFAkyF0LsACgkQzhSR9xwSCbT/MQCgm1u4WcsEPuKEvmH7OJmCqN/X
6TkAn3NE2cLDPHu950VxrrtJ6ZNr9oSI
=aHZ+
-----END PGP SIGNATURE-----

--nextPart7134026.fN8FR11l1l--
