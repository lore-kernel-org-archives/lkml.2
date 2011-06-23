Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964921Ab1FWXPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 19:15:05 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46990 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964897Ab1FWXPB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 19:15:01 -0400
Subject: Re: [Stable-review] [34-longterm 224/247] fs/partitions/ldm.c: fix
 oops caused by corrupted partition table
From: Ben Hutchings <ben@decadent.org.uk>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        stable-review@kernel.org, Timo Warns <warns@pre-sense.de>
In-Reply-To: <1308850515-15242-165-git-send-email-paul.gortmaker@windriver.com>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com>
	 <1308850515-15242-1-git-send-email-paul.gortmaker@windriver.com>
	 <1308850515-15242-165-git-send-email-paul.gortmaker@windriver.com>
Content-Type: multipart/signed; micalg="pgp-sha512"; protocol="application/pgp-signature"; boundary="=-w3T5zxSG4BxLR8Um/3Jy"
Date: Fri, 24 Jun 2011 00:14:54 +0100
Message-ID: <1308870894.3093.1011.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-w3T5zxSG4BxLR8Um/3Jy
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2011-06-23 at 13:34 -0400, Paul Gortmaker wrote:
> From: Timo Warns <Warns@pre-sense.de>
>=20
>                    -------------------
>     This is a commit scheduled for the next v2.6.34 longterm release.
>     If you see a problem with using this for longterm, please comment.
>                    -------------------
>=20
> commit c340b1d640001c8c9ecff74f68fd90422ae2448a upstream.
>=20
> The kernel automatically evaluates partition tables of storage devices.
> The code for evaluating LDM partitions (in fs/partitions/ldm.c) contains
> a bug that causes a kernel oops on certain corrupted LDM partitions.
> A kernel subsystem seems to crash, because, after the oops, the kernel no
> longer recognizes newly connected storage devices.
>=20
> The patch validates the value of vblk_size.
[...]

This doesn't completely fix the possibility of a buffer overflow.  You
also need commit cae13fe4cc3f24820ffb990c09110626837e85d4.

Ben.

--=20
Ben Hutchings
The two most common things in the universe are hydrogen and stupidity.

--=-w3T5zxSG4BxLR8Um/3Jy
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIVAwUATgPI5+e/yOyVhhEJAQobPg/9Ev0O7bvDc79gmdeVeqPrzcj4Ts73aOJ9
Ghzp9PAVTtGZAcBt/EDVZVYwqlPrQzqelF4IZbiW+0aaHmCT8qmZvAoFYuFfHnLl
ptAawWv96rCgauuhjdzKn2zbvJR5Wg3rJbc26Ux8HuXDs7PN6RFfXNqoiQekZCVr
9D/R7y8jwZncW/gkHm2JpvSTO5r1pjPxvcMDn4MlkZvl8GsmZ1onH6LicV2h494Z
t+XTtmVyqtB1V18RgtFP+JvM15dmP5nYiw1awTYWC26+6UCMVxC/BoTSRxsrxCre
3CM/ZaQrTER7ctCH4MmiarRzVJAGD3ZkVT+wxQjb1oL5Xb9Rrk9bJpZOhoSb+xZi
E1Q+wvG3m2UGYIWq5yBxbyiVfTaV3c1DrmiUIlARca5HvQSRLBsr4+R5MVQnxIKP
X2unUB8OXrgt4bs5mGXlqZp2h1gu5s1+KUvuVH470gwGtp3lTLB26ghMfEByDywi
ECbGNH228P5g8RH/wScq+wiEx990LpTEahLJnRqUnBYtZPbp1oM/PMjnF9iOyRWv
Rdm//sgCsy1HTG3zPHI2x52bXHRyGePG2qyVyA+/X8FCJS3c1Urd5jwUaCcpMQkO
rsg5w1laf8RnJFggl01Lb417tkEMROIQseVAb+oyK56Z8dbHs22T8QIZD/Tuyau3
zq4+QuPIW3M=
=h7CK
-----END PGP SIGNATURE-----

--=-w3T5zxSG4BxLR8Um/3Jy--
