Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751094Ab2JMEMk (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Oct 2012 00:12:40 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:43545 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750774Ab2JMEMi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Oct 2012 00:12:38 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 04/25] blackfin: Use Kbuild infrastructure for kvm_para.h
Date: Sat, 13 Oct 2012 00:12:39 -0400
User-Agent: KMail/1.13.7 (Linux/3.5.2; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
References: <20121013022632.024527228@goodmis.org> <20121013022953.015897288@goodmis.org>
In-Reply-To: <20121013022953.015897288@goodmis.org>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1968702.mvuZ5XXEI6";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201210130012.40451.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1968702.mvuZ5XXEI6
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 12 October 2012 22:26:36 Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
>=20
> All the headers but kvm_para.h use the Kbuild infrastructure to
> get to the asm-generic headers.

Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike

--nextPart1968702.mvuZ5XXEI6
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQeOo4AAoJEEFjO5/oN/WBkSEP/RZMqmLQDeQ6fjRNp/9l+fae
D3ebc81heRBucvFJhAR0EH/mucFmqJP5ezou86Xm69Qfli9ZE0CW0lryMHaIKHhy
N1ea+1qw2pfT81N2RmmNNuE2/Pb9uaUE+Kk7PxUWtPfq5jKc7wuzQM+hFuHmVG2Y
kHzSSunEjlWmkZ3sB0sahoyCbNO1K+icOKsJr8leufKipwE8T1/avcNRyWmqRYT4
u3AEW75AsJBuVPhPXAzFF7iVNgk4PayNVl5tFyye9TqhM5+4cgpf4R5ntZh18XhS
hbiFOmiOmd+ag88OPAsUNusSZbMD2ZrKK6tIlgEjyP09rB1wfKi2l1aoJ6zOyu+N
Srlh0mYB6OfvdZQvyUdgX8CeW+xYuwNdSs+3AVcbipWFCew1mCd2uYZlqaxD+3wW
oMf/TNBjmv1bbHks1lke8KGCT/UMyHIwtQVOeAt+yLC1UvWUF1StAw0PrW4sB0RO
bw0gTDImLj5enFdBhf/x1jm4h6LuSMnSnz/3CRE8vrfT9U8PfjrQDNjCLsFHTXYC
Ni909eIJ19+y72nxxfbHEBw9rJiyIhId1x5Qp2L8FAkXTVhSuLaijMfkzyQLglp8
uZS0P427DXfcgrGce3LvX3Tdy6uXafa+fC129BbNt+V98ZJ6zCH/5i5Q6tqWwMlE
WnDQTz9Kuu06mVjLo9Ey
=EVh+
-----END PGP SIGNATURE-----

--nextPart1968702.mvuZ5XXEI6--
