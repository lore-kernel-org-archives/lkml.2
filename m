Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab1KZQfz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Nov 2011 11:35:55 -0500
Received: from home.keithp.com ([63.227.221.253]:53458 "EHLO keithp.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753006Ab1KZQfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Nov 2011 11:35:54 -0500
From: Keith Packard <keithp@keithp.com>
To: Patrik Kullman <patrik.kullman@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: i915: 3.2 rc1/2 KMS regression
In-Reply-To: <CAGPN=9SLsESVPdwhBwJN9G+nkENcFDqhrcva8GC-VTnx_E=apg@mail.gmail.com>
References: <CAGPN=9THOv-M4Td4haE94uDcsAjW3eGMG7ioLeu+p8xUOBPd7w@mail.gmail.com> <861usye0og.fsf@sumi.keithp.com> <CAGPN=9ROa_Pf242jxPy-6XfmFNW3+sCMj6M+pFbw+wgCX3tu1Q@mail.gmail.com> <86sjlccchg.fsf@sumi.keithp.com> <CAGPN=9SLsESVPdwhBwJN9G+nkENcFDqhrcva8GC-VTnx_E=apg@mail.gmail.com>
User-Agent: Notmuch/0.9 (http://notmuchmail.org) Emacs/23.3.1 (i486-pc-linux-gnu)
Date: Sat, 26 Nov 2011 08:36:02 -0800
Message-ID: <86pqge96z1.fsf@sumi.keithp.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--=-=-=
Content-Transfer-Encoding: quoted-printable

On Sat, 26 Nov 2011 10:55:31 +0100, Patrik Kullman <patrik.kullman@gmail.co=
m> wrote:
> Well, booting the broken kernel freezes the machine unless I specify
> i915.modeset=3D0.

Freezes it so you can't even access it over the network? That would be
quite surprising.

> Do you want a log in that configuration?

No, those wouldn't be useful (modeset=3D0 doesn't do a lot of
modesetting :-)

> I will provide the logs next week when I have my charger back...

Thanks.

=2D-=20
keith.packard@intel.com

--=-=-=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUBTtEVcjYtFsjWk68qAQhKchAAvYELOiLeipZowGHRlYqhFgI8+6UM8WM7
U6s6zYHX0ksiCs7TlCqvByqCxsBPBLjBpSPQoIplk8CWjKWxXG8D6LqHr5ioiLCT
0YoTbosXUYd2KKg0oP70ttHVv9Cqy+XYhvdN/T9+8N1aI7JgAHLrqW+TBF03r8Kf
wU09k2NvWdKrQSxM3HTvksPnA386iTVvUKbfIVTTfRUiNVkdpy9e2IJPSgiH7Pcr
omkDOjWo91dRkyUhSY7jBM/vCbROQ+tjEhgN8PJ0lSB3TDG4dDZji1p+Ran9Agj0
xYDHexZR8q3lEy2zgny1XS8SgdI9sKBdbX9+E0SEwKS5l8Y0iiZXEPzMe3cfyM7q
8ZiM1Za6H1WQVexDzy9iT2+CzbYif8A4lr3WaARtM9cpL5226mN6mEqYr4HyN7fJ
1beNX5tNz0UqRPfawzeqyZIhg435MmGVQxQ+hYuyQzLNNaJwrDhLoqRbV1SBwJZc
V1NPTR3PCzrmSdE70kQixslfMb4lZOWY7ANjj8YSwXFZdaiuGkfD/ZsrNbNc6PG+
kj8JdukZtKac7KT609WVxz3VSFHBsmIkRxX0C+9xfHeWEJNjwL364QjqxydPXWuP
Umjg9+CHERqt+V0oxHUppYMACt7vzjg6hPJ91b1mAd2xpJNJAYj/XZpk+LxdfvwJ
cZSG3WP+PYg=
=ZpPR
-----END PGP SIGNATURE-----
--=-=-=--
