Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751707Ab1BNWow (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Feb 2011 17:44:52 -0500
Received: from narfation.org ([79.140.41.39]:42842 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751047Ab1BNWos (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Feb 2011 17:44:48 -0500
From: Sven Eckelmann <sven@narfation.org>
To: Jesper Juhl <jj@chaosbits.net>
Subject: Re: [PATCH][trivial] Batman: Remove two duplicate includes.
Date: Mon, 14 Feb 2011 23:44:41 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-trunk-686; KDE/4.4.5; i686; ; )
Cc: b.a.t.m.a.n@lists.open-mesh.org, trivial@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Marek Lindner <lindner_marek@yahoo.de>,
        Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
References: <alpine.LNX.2.00.1102142335331.4530@swampdragon.chaosbits.net>
In-Reply-To: <alpine.LNX.2.00.1102142335331.4530@swampdragon.chaosbits.net>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart5347088.GlsFtsWs27";
  protocol="application/pgp-signature";
  micalg=pgp-sha512
Content-Transfer-Encoding: 7bit
Message-Id: <201102142344.44819.sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart5347088.GlsFtsWs27
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit

On Monday 14 February 2011 23:38:18 Jesper Juhl wrote:
> Remove duplicate inclusion of "send.h" and "routing.h" from
> net/batman-adv/soft-interface.c

Applied, thanks

Best regards,
	Sven

--nextPart5347088.GlsFtsWs27
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAABCgAGBQJNWbBaAAoJEF2HCgfBJntGX6UP/0823WP6xtS7XXMxLyPfR595
eRicoE7cqzjRFLvsA8kEjHM3iepdCL7ZQzPqM+t1wnQP/VjYbJn5iGnxh4aMf2N/
2R9KI/NknJJ9akwsYyPngHzGHPN3kPD2adEsBAMwoedrnUWQdi24RcIgRi8QhWpa
kpWBwPywOdPs5XQjnL3nLiHoaxudgRj9wlUJVQcPEoggj9f1t5JEeR5uELZqnehz
SYccN4ZsT762kqvuT0mwtzjeTvAfXcJvU3512T1s4JhDcG+AcwzFBh3O6qLULFoo
C5TEZyJzKcrYP0itLe05SGefKStyzwAy1GwcWUh0hydD8rRjF9jdZ9MeQb/fiZi8
c8vtU2sIJDcAyhRhx9mysXqeRWbiDjjxVwOECdXhWxjqxIhGTU7sId8wlqqX+JHr
Hbyz3K53DeZBtavEj7gGpmbOag1/3AcRTNY58lb0rj/pxNqBbIcFS40Ii9vmi0dD
oCvCQrCjfSsCaf1TC9uhoL6bebyKYV1lpNVcOBSxJmgp60kIBdVx/Z4mKM8qW8ie
Y+sSG8o3bkohmRRTadcv73VMRt0xrWoaweJkJB+n5KF7IkYSLhWRsc7DABo0Uwkf
McsS3hkABIISusiZNPX90wAJdRe/Gg+UZ5Im8clm/IPKDFddrSYl8aUaOqYBVSrU
ck84ROYp0ThzfQyxQtNn
=cPbo
-----END PGP SIGNATURE-----

--nextPart5347088.GlsFtsWs27--
