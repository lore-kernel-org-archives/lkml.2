Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282Ab1BHNiN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Feb 2011 08:38:13 -0500
Received: from swan.madduck.net ([80.68.90.58]:48192 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753987Ab1BHNiM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Feb 2011 08:38:12 -0500
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Tue, 08 Feb 2011 08:38:11 EST
Date: Tue, 8 Feb 2011 14:30:11 +0100
From: martin f krafft <madduck@madduck.net>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Opteron ECC/ChipKill error
Message-ID: <20110208133010.GA26487@albatross.oerlikon.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="vkogqOf2sHV7VnPd"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux 6.0 kernel 2.6.36-trunk-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vkogqOf2sHV7VnPd
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear list,

I just got to see the following message on my Opteron server:

  kernel: [810137.744689]  Northbridge Error, node 1
  kernel: [810137.756250] ECC/ChipKill ECC error.
  kernel: [810137.766975] EDAC amd64 MC1: CE ERROR_ADDRESS=3D 0x26bdd40f0
  kernel: [810137.766982] EDAC MC1: CE page 0x26bdd4, offset 0xf0, grain 0,=
 syndrome 0xe1e2, row 6, channel 1, label "": amd64_edac

Is there any way to deduce from these data the actual
culprit/component to replace?

Thanks,

--=20
martin | http://madduck.net/ | http://two.sentenc.es/
=20
"a cigarette is the perfect type of pleasure.
 it is exquisite, and it leaves one unsatisfied."
                                                        -- oscar wilde
=20
spamtraps: madduck.bogus@madduck.net

--vkogqOf2sHV7VnPd
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQLvBAEBCgDZBQJNUUViwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xNo3
D/9PHKWUkBVlsKuOYMCSXcOw53Vtx6VnsZqSzORgYuUjGe6qMG2jnEyMexrkBAL+
D8rOeobQ40LNWIZMQuIs5F++JfaOsTHzJpLvIyKaM605Osf7MarMQo4jG8BnwWfV
1ejUbP/eU/3gDp9u9vX22mCNVpR3a9tlnbKU+3h8XTmODJKLqmUjelaP0yV21NB5
d2IuPvcnvGWrZjNnRQM+0tQJ3MTmfsPDQVMibY1qFAtsqKlcLPURCoSouZAMFLxT
yzu/TnEADZSuLXyhcnYj8XccjQjtPOfL4xFH1qBZJDKYt9KInqtpc3A2lTXz2VBG
gR3aN24LTI0FCqrQCiHjHq7riWg25pWZWZleFuZVDkUXgyt7i2EzIAzu/3nPTxaq
q9JkfSoZTMAuhphBE6ktEqN9xINXxEGWosKk9VqURp/d/izGVHaHGXp1caTxKkII
4h8CadrZtNNe/Hig8miod8GuVdG6+PDG9iLPLuZiRPYuQilW3Q6FhBGYrtZCxgZn
ja9g6hRs7V32T6iL45l8Pmsv5dUqm5/pYDkCvN0eEM3z6Ku84A8wrMzUDgnQ1K7w
aVywj/yldbo+RQudBGbdFQnvH9mOhiD9hx606O7MaLM/wiRDw3qATK7LGNKiC5LZ
w/JhKDiPXLuh3FHqY77qzUHm31UBX7MTOaqfT9J82sqpcg==
=ILzk
-----END PGP SIGNATURE-----

--vkogqOf2sHV7VnPd--

