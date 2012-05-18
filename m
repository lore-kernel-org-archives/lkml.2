Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030198Ab2ERATA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 20:19:00 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:42124 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965781Ab2ERAS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 20:18:57 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "H.J. Lu" <hjl.tools@gmail.com>
Subject: Re: [RFC PATCH 00/10] Use __kernel_[u]long_t for x32 user space compatibility
Date: Thu, 17 May 2012 20:19:25 -0400
User-Agent: KMail/1.13.7 (Linux/3.4.0-rc6; KDE/4.6.5; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        torvalds@linux-foundation.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de
References: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
In-Reply-To: <1337292816-10839-1-git-send-email-hjl.tools@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2889693.7f6ImIrxb0";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201205172019.27462.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2889693.7f6ImIrxb0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 17 May 2012 18:13:26 H.J. Lu wrote:
> From: H.J. Lu <hjl.tools@gmail.com>
>=20
> This patch set changes a number of places where the kernel headers are
> exported to user space and currently use explicit "long" or "unsigned
> long" to use __kernel_[u]long_t in order to be compatible with the x32
> user space ABI.  These location are places where x32 uses the x86-64
> ABI.
>=20
> It is quite possible that some, or even all, of these locations should
> really use dedicated types, but in the meantime this gives the correct
> results which the current headers do not.

tangentially related, but what happened to the x86 asm/ptrace.h patch i sen=
t=20
that changed all the registers from unsigned long to u64 ?  e.g.
 struct pt_regs { =20
=2D	unsigned long r15;
+	__u64 r15;
=2Dmike

--nextPart2889693.7f6ImIrxb0
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPtZWPAAoJEEFjO5/oN/WBp8UQALXBLbD5MbPIUNJ45zXHvJhu
JfdPC52uwij1dU33+/Aoq6VuSVkTdOMlGy9QuzbeV2fr8CQZDIh7CtJGMtyJlp+G
u8Qs/QP83P5y/urrJvuEgQddonE/pZaVLWEQvk3RMcoObDbzIzYWzPb/z7JMSH2k
Gm8ZXsL4s3gHVmVHvK7lfvnNbfxA1SKbacGXfZUUKgicZpJiDd6L+OxNPjywWa1G
qThmyQrAzD+67BZGFS7Ir76wzjis30NvvOS4pm4jvnACX64lK7XvACZCN1DBeSZH
7Oasa25C0rfCWuuzGUl78/ex3k7Vdvo9kyZmJzqhHo8pILCsTvar6DKc0JylbV+t
BQiZw0WdzdVB1j3f2LACpn4FECq/VhM4lTXy5TfDbPeSq06bbcfkW9SEpZ2thbX4
WQcEIbe8wScqzhrHg7CBCDk+U9k8Z9JxEHaU5ZrEDqoG+t4aX+jV3rB8MviZwuRg
cWGkBMm2RBgm4wJc7x1UT8E8xorwTZvW9iAIcq1rI7muaQkvPMCdY965TJoUfwaV
thRoYfFxuwQK4gISY8ZMlB+nUTFu/6X8ak+iPM0y5mQNN210hZO2myah64kL0jjD
IdBOH0R+UBesTn1BErbhziFRoB9cKZWwRTUjTDi2Cb32f6jUzxbK3xobRHlSbCBQ
W6pU4F64kQ9fdZyOqWZh
=IhTu
-----END PGP SIGNATURE-----

--nextPart2889693.7f6ImIrxb0--
