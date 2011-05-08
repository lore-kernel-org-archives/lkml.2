Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752871Ab1EHJd5 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 May 2011 05:33:57 -0400
Received: from narfation.org ([79.140.41.39]:52253 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752123Ab1EHJdx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 May 2011 05:33:53 -0400
From: Sven Eckelmann <sven@narfation.org>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH] atomic: add *_dec_not_zero
Date: Sun, 8 May 2011 11:33:48 +0200
User-Agent: KMail/1.13.7 (Linux/2.6.38-2-amd64; KDE/4.6.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-mips@linux-mips.org, linux-m32r@ml.linux-m32r.org,
        linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org,
        linux-cris-kernel@axis.com, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, x86@kernel.org,
        Chris Metcalf <cmetcalf@tilera.com>,
        David Howells <dhowells@redhat.com>, linux-m68k@vger.kernel.org,
        linux-am33-list@redhat.com, linux-alpha@vger.kernel.org,
        sparclinux@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        linuxppc-dev@lists.ozlabs.org, linux-arm-kernel@lists.infradead.org
References: <1304458235-28473-1-git-send-email-sven@narfation.org> <20110508092403.GB27807@n2100.arm.linux.org.uk>
In-Reply-To: <20110508092403.GB27807@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1677856.Ey88dTAy4V";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201105081133.50824.sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1677856.Ey88dTAy4V
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Russell King - ARM Linux wrote:
[...]
> Do we need atomic_dec_not_zero() et.al. in every arch header - is there no
> generic header which it could be added to?

Mike Frysinger already tried to answer it in=20
<BANLkTimctgbto3dsnJ3d3r7NggS0KF9_Sw@mail.gmail.com>:
> that's what asm-generic is for.  if the arch isnt using it, it's
> either because the arch needs to convert to it, or they're using SMP
> and asm-generic doesnt yet support that for atomic.h.
>
> for example, the Blackfin port only needed updating for the SMP case.
> in the non-SMP case, we're getting the def from asm-generic/atomic.h.
> -mike

=46eel free to change that but I just followed the style used by all other=
=20
macros and will not redesign the complete atomic*.h idea.

thanks,
	Sven

--nextPart1677856.Ey88dTAy4V
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCgAGBQJNxmN9AAoJEF2HCgfBJntGmosP/0BjDtvk4ZKsL9hhonb8gZ4t
/2/hY6jeQ3Mg30Z1v6+PIZDun17qML5ODBcTB72oJs1LujHyEgNKKtfQ9stYgAm3
79B2UAH5LYVzZzd2j5nMWemGYChUXl5v5N/hOFOp04ImC7DU27fwadcuO+q47vnS
kKvrnccIFc0qUpnGwZ+1rqHIp9Rs3AQHjvyxaUDIuMs8ZWurYkS+e5SMini7qUpe
QvsTQVZhyuNtemvZUzrWUcftMVPNXxTHwwV5aALBswX4SPreBJWX33b8j+NIHeFU
hmwZ7/RzuDCyIzUFmeeXj/f0RCbWv5XkhQmNaCGFBdatgLRd2fnDOXzkuOeUPtBi
SX2jkxoXSMGwEtl2mzOW8JhvcGrG1+oMw9j/BqdQyaQe0rRnuFg962eRUs1RvibI
bej/DRfMexoXhlw7EIN9JGoniuMAW88Ws4RB79HuPURy6Ax1cr87ELH/Oj5ZvlOc
+whWNM9JuDFamC9E4zaenxqf0jd3mlvCAMaljh66J7qECJF9xWd5eJyet7CE7/hp
kE6iUT6Zf93Na9NImeTTeGK16LW1KqLkP8QyI+HUGO7A5wj/QvubGPBO0deHsp8G
YkQBcQwZMSft69hsW2Ke1btpJv/ScGxeVuplmMNrlDa1hAqjm+aHo6+xxTS5Mp72
p5S21fQTeEf4fOJsQubR
=ICmm
-----END PGP SIGNATURE-----

--nextPart1677856.Ey88dTAy4V--
