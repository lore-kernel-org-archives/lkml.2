Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755392Ab1I2K2i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 06:28:38 -0400
Received: from swan.madduck.net ([80.68.90.58]:41259 "EHLO swan.madduck.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752279Ab1I2K2h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 06:28:37 -0400
X-Greylist: delayed 315 seconds by postgrey-1.27 at vger.kernel.org; Thu, 29 Sep 2011 06:28:37 EDT
Date: Thu, 29 Sep 2011 12:23:18 +0200
From: martin f krafft <madduck@debian.org>
To: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Overriding reported sector size
Message-ID: <20110929102318.GA32535@albatross.gern.madduck.net>
Mail-Followup-To: linux kernel mailing list <linux-kernel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="T4sUOijqQbZv57TR"
Content-Disposition: inline
X-Motto: Keep the good times rollin'
X-OS: Debian GNU/Linux wheezy/sid kernel 3.1.0-rc4-amd64 x86_64
X-Spamtrap: madduck.bogus@madduck.net
X-Subliminal-Message: debian/rules!
Organization: The Debian project
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T4sUOijqQbZv57TR
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Dear list,

recent disks >2Tb come with 4k sectors, but they report 512b sectors
to the OS for "backwards-compatibility" =E2=80=94 presumably, other OSs
do not differentiate between physical and logical sector size, which
Linux can do and does.

All the block device layers nowadays can auto-align themselves, but
that obviously only works when they know the true sector size.

Rather than fixing each and every tool, and/or telling each and
every tool to ignore the reported sector size and to use 4k instead,
is there a way by which I can "fix" the sector size at the OS-level?

Thanks,

--=20
 .''`.   martin f. krafft <madduck@d.o>      Related projects:
: :'  :  proud Debian developer               http://debiansystem.info
`. `'`   http://people.debian.org/~madduck    http://vcs-pkg.org
  `-  Debian - when you have better things to do than fixing systems
=20
"never trust a woman who wears mauve, whatever her age may be, or a
 woman over thirty-five who is fond of pink ribbons. it always means
 they have a history."
                                                        -- oscar wilde

--T4sUOijqQbZv57TR
Content-Type: application/pgp-signature; name="digital_signature_gpg.asc"
Content-Description: Digital signature (see http://martin-krafft.net/gpg/sig-policy/999bbcc4/current)

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQLvBAEBCgDZBQJOhEcVwBEaaHR0cDovL21hcnRpbi1rcmFmZnQubmV0L2dwZy9z
aWctcG9saWN5LzU1Yzk4ODJkOTk5YmJjYzQvMjAxMTAxMjQxMTI1P3NoYTUxMnN1
bT0xY2FkOTZmZDI3ZDMyMzNmNTNlMjI4NDk1MzM2NDgxMDdlNWVlOGQ1YmU2NTUy
NTFkNzRjOGYxYzVjM2JjNDJmMjMwNGZhNTE1MTUwZjdiZDRkZDA1ZTk4MTk5MjRm
MDQ5NTEzZWU5OTYyY2E3MTcwOWY4MWQ5NDUxNTg1MmJkOAAKCRBVyYgtmZu8xNIH
D/0ZE45pwt6Foy/YDcL6Ca5nCrc1VBYphsMHtc2xZbj+2J+D5wkNCMW8LS/L91MU
nz1QaT6Z1kmUJ5GEXnZj7ElPMTpBWuGR81Sgc7/+kDet8w7nAzEnkrX8ZmKMcN1r
rsDXiuV7UlEzxHz6R8z7uyEZjW93r1NJYpBwyeiJNImulAocgquikRBo3NpzDZBC
KbbAR8RdNvaxvh9WJt9g1F/ukHjZQQDVTVE8MlC+y6wscGxv+8DmV7jkBLsZFs1u
X7Q+CUF6C8d/srhJgNaqgPsFaBYZiXA8kZXo7njz/AvI4yI6gucQLg+AJ/IJOqqj
Sp0d5KOXQO570sZmjfUCabYCFx5UDrIzU6ubwB6MPOWBhxXC/84iI8+7Qk0rRGkm
Adn399OaqknlTnISNJ2fUuykGZFcohGU8Xmq4cSp4/rT80Z+wW9AwdKSxicgogCE
bfY52XVMYuzJEbTBdlXD/6TNLGKaB1HmRnQuZo9/JYopsNmlt3UA7Yz62LQ8Xzgp
Y65UXcrOC3Fdp+xCkRviIx8B21DkX87DL7PWNZ6O3jxEe7RdMkK0432HjhyxxxJq
TUOd9EUVkM+DQp2tHmScW/dnjWM8NckGKT8Ci9g0xIf6bIPR+RF7ZVJGsB6pxMJ0
nT3riqS9D2ptyd583///eNS9s+KZdMJA2IEhIyy30/mXUA==
=HQ3l
-----END PGP SIGNATURE-----

--T4sUOijqQbZv57TR--

