Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755062Ab2CARTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 12:19:13 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:54515 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753359Ab2CARTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 12:19:11 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Anton Blanchard <anton@samba.org>
Subject: Re: [PATCH 1/2] atomic: Allow atomic_inc_not_zero to be overridden
Date: Thu, 1 Mar 2012 12:19:14 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: benh@kernel.crashing.org, paulus@samba.org, akpm@linux-foundation.org,
        asharma@fb.com, eric.dumazet@gmail.com, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
References: <20120301180953.0f61576f@kryten>
In-Reply-To: <20120301180953.0f61576f@kryten>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1733415.TSW5sbkbnq";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201203011219.18114.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1733415.TSW5sbkbnq
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Thursday 01 March 2012 02:09:53 Anton Blanchard wrote:
> We want to implement a ppc64 specific version of atomic_inc_not_zero
> so wrap it in an ifdef to allow it to be overridden.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart1733415.TSW5sbkbnq
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPT6+VAAoJEEFjO5/oN/WB0dIP/1rmcRlyH6LDxo4zPnYU5dWE
X4+tGDj2nD2rQ0KTQsbB+HIhNzXOKkx2RrqVf/y28XpWl+hR4HOFfeQp7N6TG1Y4
LX0n253SFaSq0/3LUZYpuRh0WvJlqCoT9mherOr6EKd9+W4TJpaScz45MoYikgb0
LrfOznpoPs8m+Hx1bM3Ret1L+glZZ6OQfamGd/63DDpfdPrYM0JzjcIvxsPvVMeT
+s/9+K7DuVsT1AdORcqF7RawsStx3NigA6HDoioF9pxakdyZmfSZvginJXRCr32r
TH7N8TEIRxbNeMk3KbYG5YzCEur/sl6p+5wN6TrPGlmseiV2YHDWZXzsSH2pPrKv
cuBMrEab7eILakLdA9B98vMV7yRnfoujM2chESaKuAULKKiYzTfacMJyjgxY/N2k
4QVOKwE7kUIgWTRD9VHaSP0/oVZQ0v50CI9V9YFv91+iFuAL31xHqOmRYuplu5uS
dKqHT9FW8a0C9hwzNWqccurrOGSk5kJw92ArLI9j7FgtUTQ/02QofHCuA5sHFbzw
w8tA9vZ4h6GO2j7yB4J3BLYgqz35j4/d6aib2CcMeQKpd08yQFd8CShsNIwA6uL7
zl2u/A7eTB0FNIYb6Jid/iIzJrRcm0LDbpSK1gEjcg8gfnEU6t6uGKpxmx+FRlp+
6dt4DQAZ2HdlqY7QToTU
=op66
-----END PGP SIGNATURE-----

--nextPart1733415.TSW5sbkbnq--
