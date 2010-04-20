Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752902Ab0DTXRJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Apr 2010 19:17:09 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:50627 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752280Ab0DTXRH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Apr 2010 19:17:07 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: libc-help@sourceware.org
Subject: Re: mprotect() failed: Cannot allocate memory
Date: Tue, 20 Apr 2010 19:17:22 -0400
User-Agent: KMail/1.13.1 (Linux/2.6.33.2; KDE/4.4.1; x86_64; ; )
Cc: =?utf-8?q?Pawe=C5=82_Sikora?= <pluto@agmk.net>,
       linux-kernel@vger.kernel.org
References: <201004210105.20942.pluto@agmk.net>
In-Reply-To: <201004210105.20942.pluto@agmk.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3325750.kmnpztpH7r";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201004201917.23286.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3325750.kmnpztpH7r
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Tuesday 20 April 2010 19:05:20 Pawe=C5=82 Sikora wrote:
> i'm trying to debug an ugly application with ElectricFence.

electricfence does a lot of ugly memory tricks to do its thing, including, =
but=20
not limited to, overriding memory related symbols.  best to seek help from =
the=20
electricfence authors.

unless of course, things still fail when you dont use electricfence.
=2Dmike

--nextPart3325750.kmnpztpH7r
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iQIcBAABAgAGBQJLzjYDAAoJEEFjO5/oN/WBfikQALGaLWFraVf9BScQbjja5pPV
l0D/Cl1AUz/ZEQ3QlIXNT/IBe5zvKATt7kUSy5mO1V019NViRtboHsiUOK9C//k7
eFOGEqA0A193TuE+2CGbLCcG3KKaGNaqIBOXlxEPD4NlBPv8N8GlizaiWq6NXYrQ
XgkRptn9Kl7uOAMI/J/DGi8vOVgqRZ7ZeOyU2c2aw/U+Uik1kkwTubjc00IrDFGs
tn//kg2QYnQP8sf3PQ4PDIK7CVTN5ui00lqG/MWcu+CcYQsyg6VdH7JorJ5WCTIA
zuvqD40qo600a8qoJ18Xc7cmYH9repyBu//EuAqIejLRYYM71i7VobgvT6aJcDQh
fYGpub+nRSjPitYyWO6rOzLb/UjdPxccse1NwLsaw1y7BiSLSDQ9Kl+gQIgwjCvC
I6roWUcIqptVoFae1bhTSUoUBCrmeQyNw5+Rip/711k2nNH5WKRC/RCypg6ahRYw
VBnbxnH3KTEjQMQWzFgMsvx633sjYlfQoF07oarCY3ZE3nencmxyMLRVq44fBQSC
AUVXnn3Q+NQaK8dykW3Dzh+AkM9z/O8cPBCpYAMRsAP4wKVubVj6HH35SrEEpkSw
adq8+2Jagsk/Stlzfur0WeFGR5KHHlitF/dVTIYkjqWFbxwZJsSHwqmgmWxjzGDh
JS3MvlYPemz5nZz2uQFf
=jmsR
-----END PGP SIGNATURE-----

--nextPart3325750.kmnpztpH7r--
