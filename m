Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759469Ab2D0QRI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 12:17:08 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:49115 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758889Ab2D0QRG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 12:17:06 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 2/2] asm-generic: io: don't perform swab during {in,out} string functions
Date: Fri, 27 Apr 2012 12:18:58 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc1; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, uclinux-dist-devel@blackfin.uclinux.org,
        Arnd Bergmann <arnd@arndb.de>
References: <1335523376-14695-1-git-send-email-will.deacon@arm.com> <1335523376-14695-2-git-send-email-will.deacon@arm.com>
In-Reply-To: <1335523376-14695-2-git-send-email-will.deacon@arm.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1479544.NqU8s0yJEH";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201204271219.00596.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1479544.NqU8s0yJEH
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 27 April 2012 06:42:56 Will Deacon wrote:
> The {in,out}s{b,w,l} functions are designed to operate on a stream of
> bytes and therefore should not perform any byte-swapping, regardless of
> the CPU byte order.

says who ?  where's the agreed upon documentation for this ?

(i'm not disagreeing with you, just that there lacks justification here, an=
d=20
someone can just as easily post another patch saying the opposite of what y=
ou=20
said and there's nothing stopping us from merging it)
=2Dmike

--nextPart1479544.NqU8s0yJEH
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPmsb0AAoJEEFjO5/oN/WBUl0QAIXqwWqaVDmwRwrTwmMNaByM
QfZUcDmxQoHtHAV0ReWOpsM5cow2TSrRZuYprpg6cml4Zd+up/7YJPXTv2cJf50l
CxiayvCcED6zcEs5XnS3CBL4b9566JMBkzUQPIzT3YGYhBR27XTEG2QsRjExK9tf
YB3caF8jCVKw6sjiSQZ4rWNOMFRU1us/2UO9GAYl+8U/VwBY77S0+fjiaUkrPzPJ
tG+owm8VyagyWlbNDhaqrpWEoJQpLEF6EZjeUBhjwcA8zNCqyijtfi9qdHMclW/n
vnHNU7uB6flPp/Qt2UFY3X/VwG1aAjM7m7weoZNSn8GoFDPQplDT3Pmpdq6ZZLMa
pY+O47G1VnABtYz3U1krZhVOnMOpObT7H1amLKLsXLzrM/58jOsUb5bdyZ+QcV66
dtdmla/Xx4Xtn0wZhatxHGz2t/YGDUMQakJN562ysXJT/BixSWEV1l9ulqXRy9sK
axhj+7JMU5afHXcKYnCrRSGD9qmvvxDWEG7H8+SDh7oTrTltBMFWRC9VxpIdYJUp
OQ1b3Eg8hzC1z4EG8LmWsDfzkaJGpFnpTDwg/LiVgHZbsy7NM3/ZhyWEGvRZGdud
gZDbvH1pvJDw1ZSYNdzfqQqiTDvjZpfZDHR8hBT/XoEz3JIL8mvUfoh12rOEabTR
AZBgEHrTZv65scTRZN5M
=PUqf
-----END PGP SIGNATURE-----

--nextPart1479544.NqU8s0yJEH--
