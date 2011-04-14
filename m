Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932819Ab1DNKeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 06:34:06 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:56852 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758701Ab1DNKeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 06:34:05 -0400
Message-ID: <4DA6CD8F.6080206@ece.ntua.gr>
Date: Thu, 14 Apr 2011 13:33:51 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110407 Lightning/1.0b3pre Lanikai/3.1.9
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: rusty@rustcorp.com.au
Subject: Two questions about paravirt boot sequence(head_32.S)
X-Enigmail-Version: 1.1.2
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigDB0083DE84E44C565A4D97E1"
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.6 (ulysses.noc.ntua.gr [147.102.222.230]); Thu, 14 Apr 2011 13:33:57 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigDB0083DE84E44C565A4D97E1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

1)I cannot understand why the WEAK entries are required after the
bad_subarch label :/ Any hints?
2)I think that xen doesn't use any more the hardware subarch boot
parameter, and uses a 'different' path/boot sequence, hence the
xen_entry in head_32.S is not needed any more. Am I missing something?

Thanks! :)

--=20
Stratos Psomadakis
<psomas@ece.ntua.gr>



--------------enigDB0083DE84E44C565A4D97E1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAk2mzZIACgkQid1lVeNDMmB21wCcCHuGkCGJGP2gcXx1D9Z0PQSh
SykAoI1Oswhzf0IHxYdPOyJ92NoEOgNE
=x6zS
-----END PGP SIGNATURE-----

--------------enigDB0083DE84E44C565A4D97E1--
