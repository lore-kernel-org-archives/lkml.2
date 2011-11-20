Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754381Ab1KTXWP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Nov 2011 18:22:15 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:46172 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754241Ab1KTXWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Nov 2011 18:22:13 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH RFC 1/5] scripts: Add sortextable to sort the kernel's exception table.
Date: Sun, 20 Nov 2011 18:22:11 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-embedded@vger.kernel.org, x86@kernel.org,
        David Daney <david.daney@cavium.com>
References: <1321645068-20475-1-git-send-email-ddaney.cavm@gmail.com> <1321645068-20475-2-git-send-email-ddaney.cavm@gmail.com>
In-Reply-To: <1321645068-20475-2-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2815097.bik46lS6gJ";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111201822.13614.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2815097.bik46lS6gJ
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 18 November 2011 14:37:44 David Daney wrote:
> --- /dev/null
> +++ b/scripts/sortextable.c
>
> +/*
> + * sortextable.c: Sort the kernel's exception table
> + *
> + * Copyright 2011 Cavium, Inc.
> + *
> + * Based on code taken from recortmcount.c which is:

seems like it'd be nice if the duplicate helper funcs were placed in a comm=
on=20
header file rather than copying & pasting between them.

> +	switch (w2(ehdr->e_machine)) {
> +	default:
> +		fprintf(stderr, "unrecognized e_machine %d %s\n",
> +			w2(ehdr->e_machine), fname);
> +		fail_file();
> +		break;
> +	case EM_386:
> +	case EM_MIPS:
> +	case EM_X86_64:
> +		break;
> +	}  /* end switch */

unlike recordmcount, this file doesn't do anything arch specific.  so let's=
 just=20
delete this and be done.
=2Dmike

--nextPart2815097.bik46lS6gJ
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOyYulAAoJEEFjO5/oN/WBe24QAL1WZzZr9y3mGK1q728FFE8z
+Pz81B7gu/G3TFCeSp1qBbCOAfUQviuTpQG4Y+unbt3U0LeWKYmBQo5VdUsYRaft
q9fua5PpIwfpaNKgvahhcFsR9KgAHlCGhiNOxdYLtHdlmG59ndRynhamlSIIo5rA
x5ZOmNqbZdZ4Xmi0/z3SEErSw6kbvDyNe+kCPZ6aez8QaehQm/NcVH58qHkGGAI0
RwPuW7iD6NM6oDAgUHLNFmZAEVs7yaTgPNKZyg0T8O1GqcC/gSnR+GRCltVU1prb
T3fIgxoQNRidS0+4Ock3FDy4cJe+EqhFZocvAhOTQkV1O46ZlZUcvhd00oYiR9P/
WEBlXM9Vcyp2VaAAuQIuP4cPWjOrJU2MPWDvPySiSgmCPc3EWLtADnYBHwb8B9KC
RCrZX4mdyuGOfdvwvV9J+USQi1+oJFIsLjAnuQ+dbokf3/UFZru4DIamGV2EBwwU
d3eXqDUVDEyogtOnLtyyBTA0r37gtjm6aOsGGqtkZKVUARJvYb9VTONBUX6PcPju
n1z1M4Wgw3AMF3Pghox7aksapqhuRcoVgee/HZDzC0KH34gB1sxJJKCIvrOKUkpI
cLNDoKE07kS5PS2myZic+lRGXSXoTYAUo/FbCqIg6U/ku0Hd4J974qvBHxQrUXWh
SD1cwB8SCixlup5hTB4y
=8wsY
-----END PGP SIGNATURE-----

--nextPart2815097.bik46lS6gJ--
