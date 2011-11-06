Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab1KFWyh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 17:54:37 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:45543 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581Ab1KFWyg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 17:54:36 -0500
Date: Mon, 7 Nov 2011 09:54:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failing to fetch the acpi tree
Message-Id: <20111107095429.28cb33a8ec512a2bd7690dba@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_09_54_29_+1100_K3wVe8X26uMMqDmt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_09_54_29_+1100_K3wVe8X26uMMqDmt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

Fetching the acpi tree, produces this error:

fatal: Couldn't find remote ref refs/heads/acpi

I am still fetching from git://github.com/lenb/linux.git#acpi, is that
correct?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_09_54_29_+1100_K3wVe8X26uMMqDmt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOtxAlAAoJEECxmPOUX5FEQksP/ipOxQT+6e/6oKnLNfCxBDBQ
0Lnp66h4pt8dfQIOoNJ9TFa8EqMjoRLPPf6KY4kNKHopADLhgk2B8tX86n3pHUgq
fR865k9vvRRMFKltJMVGvg3W7+SQeZUDrjNGrJbMycmbGZq3Jqr0VdQTb/c5ZX+7
slIGJRJx9aFxRyBI+NEPJYV5g1MKUD3yzv0qNOtUWtaB58i1hebNN9crWixxiAfd
1ISFSmE6R4Cz7E+Raa46zFY+CDIV/69GuimTN01s4NU/oxhkiOQwUaP8flkLPUuM
e6k7G6ESudUpCvgTalqJ7zxJqnfGJxc8Br+5pXYI9kMkidgQjGydATsHm40QdiUi
m8svtgY4gjI91GJ6DRHHXWuwTdrjES7E8rg3avH/mHiXBnpeVh4vHCkZC5MjMkiy
O31oD50CuOYz36OiIgbiMh5hN2VQYSWnAZnGYlpmPMgzzIWn0M8tAFENqia+h5xG
E2jBGyUuvEyNyhkN73RIDTf6kGc4PjgUtxyYqlmnSwDkKlhaayINPXfqcGt3qBP0
6cSzegAFQlvy58WUVOrCQh/1++oMhVyF5aO43h/uukxcXZSs/uD4/JlElcIMLTHb
S3v8TYz/kBRuMAgtMvZ/XMEB65H1Sk6LEDfC+WAcWv02kRFTy/8xzG14I5+pQypg
HH8zCyOM61VTd/olUskM
=i/sQ
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_09_54_29_+1100_K3wVe8X26uMMqDmt--
