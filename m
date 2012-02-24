Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757767Ab2BXQl1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 11:41:27 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:36351 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751284Ab2BXQlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 11:41:25 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: James Hogan <james.hogan@imgtec.com>
Subject: Re: [RFC] [PATCH] asm-generic/unistd.h: handle symbol prefixes in cond_syscall
Date: Fri, 24 Feb 2012 11:41:23 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arch@vger.kernel.org,
        "linux-kernel" <linux-kernel@vger.kernel.org>
References: <4F47981F.4020305@imgtec.com>
In-Reply-To: <4F47981F.4020305@imgtec.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart4254397.hFfM5kXm2F";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202241141.25462.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart4254397.hFfM5kXm2F
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit

On Friday 24 February 2012 09:01:03 James Hogan wrote:
> Some architectures have symbol prefixes and set CONFIG_SYMBOL_PREFIX,
> but this wasn't taken into account by the generic cond_syscall. It's
> easy enough to fix in a generic fashion, so add the symbol prefix to
> symbol names in cond_syscall when CONFIG_SYMBOL_PREFIX is set.

Acked-by: Mike Frysinger <vapier@gentoo.org>
-mike

--nextPart4254397.hFfM5kXm2F
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPR720AAoJEEFjO5/oN/WB31cP/0wbj1gclKtz6t0tPSEajNTK
K+Yp2vsOWHqrd2kpW0e0mBGG+eI3hYbrkmyef2HNRrZ/EUrtPGW5KS5yGeqIESrr
JSjXXHm1wQMLgiKwv/v1nMLklAOe/8UEQkl9TmsXJ550wtbavBkABgB4mhtpdBw7
8GMcrVrlMe0kGijYMinE2tn5xyyYe/2fqw86fjdfDBopZkNQl0iTDa9g4ir3X1Yf
36RFADVK+0pJns2DhEYqY9O5SOvA+CguFaIKH3uWNvAxxNC1kvNqOW5MtIJ/F8ga
PggPW2+uxHOEsOZYaWKa7AawHO8QObsTHzfJxggyLArjwfdv0WmSgyuC5oTfx5aO
Ci3a0iFbVX34pltB9CSbDgzImeyp2r5dRz7chnx6QWz5qlZFr3Q94Gr6+wLz0S7s
nq1h9ELwO2PjJHhMZYNJplKrxqrcpKV/Mt7Rw7Us34K14kWNyyUZUeNi6WXro9CW
UImfD5eTtwSv5wJWjbagyuy18TgoBhjEAlQy4uo+11wZU3kuNhEFqAjY39TItCI7
+i8Uh+0H9fmkaoE0ktDTsaZMIbWdkq6jL3y7nebsjftxwvJn7nBi/LKQ+cEwLaqj
d2qmzyL59IgKaJWn3oYnlGWQw22iS2ogurjXn4Rbjd6ILmrHT+c2N+TZdudkK1wm
+xOpCRHps3O7+IWoU/59
=HBm9
-----END PGP SIGNATURE-----

--nextPart4254397.hFfM5kXm2F--
