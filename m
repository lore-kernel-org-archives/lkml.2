Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030850Ab2CGWuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:50:11 -0500
Received: from nn7.de ([85.214.94.156]:57172 "EHLO nn7.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab2CGWuI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:50:08 -0500
Message-ID: <1331160605.32484.24.camel@no>
Subject: gs_change ... kswapd0 exited with preempt_count 1
From: Soeren Sonnenburg <sonne@debian.org>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Date: Wed, 07 Mar 2012 23:50:05 +0100
Organization: 
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-YDY2sHxdGwYn5LIA+nXT"
X-Mailer: Evolution 3.2.2-1 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YDY2sHxdGwYn5LIA+nXT
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: quoted-printable

Hi,

I am chasing a bug I cannot make any sense of: I have a i7 based server
on an intel board that runs just fine for days but then suddenly dies
with the backtraces below on git master but also any older kernel
version I tried. The system is running this config
http://7nn.de/debugging/config.gz

And no matter what I do I keep getting kernel panics after a couple of
days (or weeks) that all involve kswapd0 / gs_change:

http://7nn.de/debugging/panic-3.2.0.jpg
http://7nn.de/debugging/panic-3.3.0-rc5.jpg

Any ideas,
Soeren
--=20
For the one fact about the future of which we can be certain is that it
will be utterly fantastic. -- Arthur C. Clarke, 1962

--=-YDY2sHxdGwYn5LIA+nXT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCAAGBQJPV+YdAAoJEH82z1Wqh6p3jEIP/0SzzoW87gwOlBgUFtBmU33s
6BoQbTsZvBkvivEwaHvzgPThesEf2swhMAtkdMHcowEoN1qwp7HIPFrzOpXr9g7x
CiuA4EEaoiSKTT8Sv1GHZUDRGiM1ms3TZQrnzHqKKHXLNTn3xrO2gRr7/TFK6jF+
JPfb7c8UlEVN/jXcPLD8azeNrY/L0zRwTAxt/AcM56BlDnn4nrTZGT2/hjUgpseU
2fOUPUgO8ncXo8bt4EtiaZx6mYs9j3OMPDyWhmNL4CqL3D+aPlx1rkt5S2wm4tSu
wdEDP1ZSGvaSrj1ptiDGrUZWx62kGVoUVl/v+/egjV1b3cQlDCF64yzLgG3gzjCe
f/9T4wpTP9MOZ9LL12nQG1K1NMoHpMP1EDE2ypYVNY0j8tvqhG/ELoWYAtuF5vMn
pRT1Uqgle2rokV8szTE7nOSA3i+J/kBDid5sb0g5FX/l5MXgXzQQt3CcihGdSWeY
FuStIL7n0GdfrMxyNpm1d2HwHYcPrCTwgNYnjvPVVBT0dQCQ4pOIEnIAlyJbntae
4US2otYA91pRjPvsbAUpiyCQToELD3JhdA51H8taFPDt98N5gFDFu/1BIIzWzcKB
5CaANrJ1aPOjax5eg7ftla+JvU3yD02Oixw9uDiRRKEzWtK33Vs15uaFU+lDBL6q
HXkg8CleuuUhnqneG+h/
=3Fju
-----END PGP SIGNATURE-----

--=-YDY2sHxdGwYn5LIA+nXT--
