Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760860Ab2D0RYf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 13:24:35 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:54853 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760380Ab2D0RYe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 13:24:34 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/2] asm-generic: io: don't perform swab during {in,out} string functions
Date: Fri, 27 Apr 2012 13:26:26 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.6.5; x86_64; ; )
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>,
        Arnd Bergmann <arnd@arndb.de>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <201204271219.00596.vapier@gentoo.org> <20120427165919.GD14743@mudshark.cambridge.arm.com>
In-Reply-To: <20120427165919.GD14743@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1922423.01IvZoazHz";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201204271326.29088.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1922423.01IvZoazHz
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Friday 27 April 2012 12:59:19 Will Deacon wrote:
> On Fri, Apr 27, 2012 at 05:18:58PM +0100, Mike Frysinger wrote:
> > On Friday 27 April 2012 06:42:56 Will Deacon wrote:
> > > The {in,out}s{b,w,l} functions are designed to operate on a stream of
> > > bytes and therefore should not perform any byte-swapping, regardless =
of
> > > the CPU byte order.
> >=20
> > says who ?  where's the agreed upon documentation for this ?
>=20
> This specific case is actually documented in Linux Device Drivers

if it isn't in the tree (either Documentation/ or in asm-generic/io.h itsel=
f),=20
i don't think it's acceptable to refer to it as guiding documentation

> appreciate that it's not especially clear. I had some offline discussion
> with Arnd where we agreed on this -- it also means that asm-generic/io.h
> matches what is done by bi-endian architectures providing their own
> accessors.

please add start adding comments above these functions that clearly spell o=
ut=20
the expectations and behavior
=2Dmike

--nextPart1922423.01IvZoazHz
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPmtbEAAoJEEFjO5/oN/WBxJQP/AiTVD+gAhxhRNnDlCuHodGx
7kByGnX4yOvsEGaN+qxo4adVvs2bvy/B+lpkGUVNeqXK/BN91VMFIjq3iA95r3nj
db1IaUUu/5+ctMUz6C8Xig5b8YYywUhRzhhq4Jlp3i6ILM91qfYeWS91TJ4AV6sD
nGY0hI1RsCQz3ej2V133tC/fyzlk69BbYwbbl51xdTy9feYmwzrbKarYtYMVPDTL
wO9dEvuwDVstJfrvClkE8mG9s60SEWjABI5+cgsB3nk6+G+UeyL5JPeXtv+hTN0B
L90g/0PGOCf2JIPMjQF9MC+UqJVEsQTZFHET6YfnEbGgYXIoK4jv7064uuNim6dP
WnkAC5LkaTJe8200Q+K8upiNO9LU+nhLbvd0rYP8QZM4Gm7X+X51LGMtvvrY/xz+
sE3FZtWv2WQdgU9oc8VrqxvTVd1AYOKhy+rNCzJUWddmpMbYBcMVlcnLwbm/LZ9k
+aKeVT/Kh7JHj+eYrjfrBf+o4Mw6+jfrGwQETVv89gqS+o+k6FyigKvsraSdRlHN
Rg1EegEKmyh8iQfSfac/oUx8iKJD2rSbrLmEyx8aS2rWeogbJxCrbfKq4XvRb1pb
QA5Gp1PxaG0eKen55ZorV1eM5RyPcNsgvUMS7ZMybWn+wAVSIr9i6Af+HjmD5TjR
I4cOO4+45y7/JIKKJGIf
=wCjg
-----END PGP SIGNATURE-----

--nextPart1922423.01IvZoazHz--
