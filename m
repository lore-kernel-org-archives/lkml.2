Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756259Ab1CGVdf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Mar 2011 16:33:35 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:58454 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754696Ab1CGVde (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Mar 2011 16:33:34 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: libc-alpha@sourceware.org
Subject: Re: X32 psABI status update
Date: Mon, 7 Mar 2011 16:33:06 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.37; KDE/4.6.0; x86_64; ; )
Cc: "H.J. Lu" <hjl.tools@gmail.com>, GCC Development <gcc@gcc.gnu.org>,
        LKML <linux-kernel@vger.kernel.org>, x32-abi@googlegroups.com
References: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
In-Reply-To: <AANLkTik53Ss4hk3_nproctYLX0=imnt4HOt=pGV5idcU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2832693.oG9cLejGR2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103071633.08197.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2832693.oG9cLejGR2
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Saturday, March 05, 2011 14:08:04 H.J. Lu wrote:
> Many x32 bugs are fixed in kernel, glibc, binutils and GCC:
>=20
> https://sites.google.com/site/x32abi/
>=20
> The major remaining issues are glibc/gcc testsuite failures,
> kernel core dump and signal handler unwind.

are you getting a unique host tuple for this ?  or are you extending x86_64-
linux-gnu ?  so the only way of knowing which ABI is to check for the outpu=
t=20
of the compiler+compiler flags ?
=2Dmike

--nextPart2832693.oG9cLejGR2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJNdU8UAAoJEEFjO5/oN/WBv4wP/jAoOa9Wk6IuPWRP973njvss
jM3ECHPilAPzpBnO+p/0Y4+wq8ekpjdrHRHmZOgtsV/e/I4tJqS3SSh3wMTq4CsZ
XquVLsS5DyC7+SG0/kQXIJWZBf4jTtAdDPQxIVRuHlX6ywZjdE5iCjhtBSSAACm1
XrSOjQfbdD2edKT49qYVtHK0U8tL4DKisVB8LlQ/HZEmLDVua0Kx2nWhCz8HVo27
Bjjb0babS1uTnpJPpborAxFdqJaW+M0RVpZS+4lHH+9VKilpHqfm8Tg2dLR9qqOU
ygmMyJglXEa0oYVAgGONLruiAvzgV1KZCV/TPPAQFQxWGGumXZb2W2LIL6rEBW7/
1K4ocnpMh1rHzUeXaAQK3QAMYwD7eS8tI0ASOvCy9omkrMElhIMp80kTgh+rO9Km
Y2vgq4ZhcQwW3KqnMM9h30VU1cmFJMh5NT6hcM2LFnrrRDW0oHazVFhYZBehRuwI
JAN5uHYoBsc+Aem2JLUskiiNIQhYCq83lEgwZF8uCNGbYW7OOOBULdXqlsSMsMlB
rkD22DmYYfso39+EEdjapgrxzk3ABhPixRrfgtapEPSVidTOPkXtr1Wc1EX1eDFD
zWHO/0i6FUovWA4Q0Xc+Yr0Svg8bK4UUQpYdikzXzeJaqYxOkxCVp/gTvz7ve20T
9mxiGnd0qulIFd6T4o4c
=wHgO
-----END PGP SIGNATURE-----

--nextPart2832693.oG9cLejGR2--
