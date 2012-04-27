Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759126Ab2D0QP4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:15:56 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49036 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755535Ab2D0QPz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:15:55 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 1/2] asm-generic: io: remove {read,write} string functions
Date: Fri, 27 Apr 2012 12:17:47 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Arnd Bergmann <arnd@arndb.de>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
In-Reply-To: <1335523376-14695-1-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart43101981.vTPyFn72dx";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201204271217.50048.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart43101981.vTPyFn72dx
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 27 April 2012 06:42:55 Will Deacon wrote:
> The {read,write}s{b,w,l} functions are not defined across all
> architectures and therefore shouldn't be used by portable drivers. We
> should encourage driver writers to use the io{read,write}{8,16,32}_rep
> functions instead.

well, that isn't true today as a grep of the drivers/ tree shows.  perhaps =
we=20
should fix that first ?  quite a number of architectures do implement these.

> This patch removes the {read,write} string functions for the generic IO
> header as they have no place in a new architecture port.

i don't see any file anywhere that describes what the baseline API is suppo=
sed=20
to be, and what each set of funcs are for.  there is just the random ugline=
ss=20
in each arch's asm/io.h cobbled together until things work.  i think that a=
lso=20
needs to be addressed before we go extending/contracting the API provides b=
y=20
asm-generic/io.h.
=2Dmike

--nextPart43101981.vTPyFn72dx
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPmsatAAoJEEFjO5/oN/WBRPEP/ilUxgnBt/l8K8yaZWzj9EkO
hDAWMCZ6xHsKjUXWqXHafFpcWZZN4jRV+4sovpM3p/fto1b7zMpx8JeHYY0lCpjV
D/A6gKDTvexcRYbC0kM1d6uAlpbAFZd2R63/qtkgB2tEms631p/hc9zHqIcPd7qq
zSu7ppM+hece860o1rBuCAcnWf1GivxDEn1Wp6mHpUNSIw1ql5cYOTOomnmXOaIv
AFXWaFZXZAaqatj7bSp5eOjjOLwmaHIFl5+lvKkIaY+OhI6VFD/yziIi+7H0zkxo
02Uo/w8hgBYA3l3FqO6E/bOOj6Ta6uQEtAiDQ4xJ6wfOvUciexOcByz5zAAXfpGH
BRCM+Dcdd5TLCS3bi02/73UI6m5rGpYWztixQZXCSgas8wW/tfMz9vUaEhTTJYyT
oOV/DCJe8RZXt28RQyHr6tYx92d0BBVhEGV1YbTd4tpMMM/5UafMnrPRgaffMfZJ
NwwSIi18OZAFlRAFU4HtaZ40dVeRLmgUuTOGgSJA/JUYt8VkxmI7vktgniIrd8Ux
9iMvZGoV9cj9QdrnoKFh9CaMx2yTV05yuDNQ/MKMi8h0H6+9+HARRbfw26UKEjqr
BWXzf8z61oMMvWOow6t4l5prQP0S2lu0koMmoqVsYNtHU12Iz/hfW3nAN95i2BwR
7hV0dQMDNMIto3nkvpt1
=L65U
-----END PGP SIGNATURE-----

--nextPart43101981.vTPyFn72dx--
