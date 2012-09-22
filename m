Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216Ab2IVSIU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 14:08:20 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:46593 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753131Ab2IVSIT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 14:08:19 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Lucas De Marchi <lucas.demarchi@profusion.mobi>
Subject: Re: Drop support to compressed modules?
Date: Sat, 22 Sep 2012 14:08:21 -0400
User-Agent: KMail/1.13.7 (Linux/3.5.0; KDE/4.6.5; x86_64; ; )
Cc: LKML <linux-kernel@vger.kernel.org>,
        "linux-modules" <linux-modules@vger.kernel.org>,
        Lucas De Marchi <lucas.de.marchi@gmail.com>,
        Kay Sievers <kay.sievers@vrfy.org>, Dave Reisner <d@falconindy.com>
References: <CAMOw1v7ihLgrrtgak2s9hDDsUrSnD7wO8FJTrZvsrJzarH6ZRg@mail.gmail.com>
In-Reply-To: <CAMOw1v7ihLgrrtgak2s9hDDsUrSnD7wO8FJTrZvsrJzarH6ZRg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart49942458.lN5JY5jTRy";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201209221408.23355.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart49942458.lN5JY5jTRy
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Friday 21 September 2012 17:41:44 Lucas De Marchi wrote:
> I'd like to ask people the following question: why are you using
> compressed modules? Is it only for the disk space or is there any
> performance related reason?

i've only seen it to save on disk space
-mike

--nextPart49942458.lN5JY5jTRy
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQXf6XAAoJEEFjO5/oN/WBOCEP/0qNKJIRqJrNVqgscGO9IAjW
geNdIkiH8/DEXsi3S+0CJiSl6O+TqQo/S4pjIXXQnQ9cFXFNVxuDx+fl7QEQMrdB
DwZ4BWK08TAvNUQnHUxRoazS+7eKEc6MKeiTbOKvoMnAR+E8Z4+i//k61yvHT0rI
9pgtkIQJCXTaWmFMtYJ3Lq+eFtN8b7zSqLYvfGGRD4VXfmQHAaJoQrze2FdtHADp
bkFsDJ92n9Vwiv5Avg8AMW4kbuW3MCi8lEjSqZOG0+2Q/9TK/48vWNjjeUQDvj20
wA+FP4XMp4O5rjQ1fvLJ1Do6eQU4D9p2CI/m80wZJu9KrkZFddnEkgu1EywiO5Kt
17HCJHTbcOuTfeB8UnIWllVGcUVZKvXvp+zqGG3yQ4NsSfx1gbuc03d2vij6kIAG
FffRDG+6OgcCFRcLQ+ibmkYCKw3OTbyWQbUNAaagjwMvLBJdetWWVkb01hSbDH2+
r3SRSOXiNIRVuNBiJtv7eMWLsLsoZo/3kPGXh0vlZT+nEIS8wXj3iJgBjF+ZgIpt
kCsjNOmoZ8BAUsJvRzkEBOcsAoAg9X6qLgbqoTghdl5lNmiDgd2IQe0x8t6jCA2J
ijGHiAV5frkKTtx8kflhvr+xhpiURWo6mpKgMLHoikdDxzZZkEayGsrPxSEX2ul8
EX5UAJnZfWmzfoo6XrD1
=7Rv/
-----END PGP SIGNATURE-----

--nextPart49942458.lN5JY5jTRy--
