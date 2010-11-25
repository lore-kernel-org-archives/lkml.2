Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752625Ab0KYWbS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Nov 2010 17:31:18 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45501 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752259Ab0KYWbR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Nov 2010 17:31:17 -0500
Date: Fri, 26 Nov 2010 09:31:07 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: linux-next: Tree for November 25
Message-Id: <20101126093107.e54847da.sfr@canb.auug.org.au>
In-Reply-To: <20101125132518.1c7ebed1@lxorguk.ukuu.org.uk>
References: <20101125164929.3a719716.sfr@canb.auug.org.au>
	<20101125132518.1c7ebed1@lxorguk.ukuu.org.uk>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__26_Nov_2010_09_31_07_+1100_6PxXM7gDnykB9.cD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Nov_2010_09_31_07_+1100_6PxXM7gDnykB9.cD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alan,

On Thu, 25 Nov 2010 13:25:18 +0000 Alan Cox <alan@lxorguk.ukuu.org.uk> wrot=
e:
>
> Umm where did all the x86 changes go ?
>=20
> I was going to look at SEP and fixing it but I can't even build a base
> test tree from -next because all the x86 work seems to be missing from
> the tree from 23rd onwards.

You need to ask the x86, staging and tip maintainers ...  There was a
build failure in tip tree on Nov 23 after which the tip tree was rebuilt
without some of its branches.  Also, there is a boot failure caused by
the sep driver (which I see one of your patches should fix).

I did not remove any of the code.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__26_Nov_2010_09_31_07_+1100_6PxXM7gDnykB9.cD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM7uOrAAoJEDMEi1NhKgbseuYIAIwQP9I5gHx03Jb4Qgu0AtKB
0GEc9C0ltibffVsa2TJUnGDeOHm061hJ8RGX/jvYcJJZJB3PpCvDorF9JOpgxbgc
OG0qN0Ydd5u2GfztoUQFZLtxU8ZZL6m4JFH0ROuEQbw+VwuekW3TMeq8Ke8Z3nH8
JPevZzE7liYiuvfg6ux2tB4J0gFXj3MtJYHMm4HSkz7qoUvfIWjIE2TjnitoUCDg
aCtIxL4Fofp9cw+GkxXa/mc1kyULIZRW0dLljX8vBYgqVo7zdeUgLSkXzGXX6I2y
Z1cLlk7L9kybynFyLyWrFTf3V7WGboewl7epwJfkCU488W+IwzuaVqoUi8uFx4U=
=nnIl
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Nov_2010_09_31_07_+1100_6PxXM7gDnykB9.cD--
