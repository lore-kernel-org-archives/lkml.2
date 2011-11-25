Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1KYUCk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 15:02:40 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:56434 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752406Ab1KYUCi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 15:02:38 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: "Lars-Peter Clausen" <lars@metafoo.de>
Subject: Re: [PATCH 6/8] ASoC: SigmaDSP: Provide diagnostic error messages
Date: Fri, 25 Nov 2011 15:02:34 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.1; KDE/4.6.5; x86_64; ; )
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, alsa-devel@alsa-project.org,
        drivers@analog.com
References: <1322138908-32127-1-git-send-email-lars@metafoo.de> <201111241232.43809.vapier@gentoo.org> <4ECF58E9.9070903@metafoo.de>
In-Reply-To: <4ECF58E9.9070903@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart2561714.SWRGmkjUa5";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111251502.37100.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart2561714.SWRGmkjUa5
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 25 November 2011 03:59:21 Lars-Peter Clausen wrote:
> On 11/24/2011 06:32 PM, Mike Frysinger wrote:
> > On Thursday 24 November 2011 07:48:25 Lars-Peter Clausen wrote:
> >> +	if (crc !=3D le32_to_cpu(ssfw_head->crc)) {
> >> +		dev_err(&client->dev, "Failed to load firmware: Wrong crc=20
checksum:"
> >> \ +			" expected %x got %x.\n",
> >=20
> > it's my understanding that string constants should not be split
>=20
> I think it is fine here. You probably wouldn't grep for %x anyway.

no, but you would copy and paste a string like:
	"Failed to load firmware: Wrong crc checksum: expected"
and then not find a match

i think it's best to follow the style anyways ...

also, no need for the period at the end of the msg.  that's useless noise a=
nd=20
can be annoying to copying & pasting numbers.
=2Dmike

--nextPart2561714.SWRGmkjUa5
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOz/RcAAoJEEFjO5/oN/WByTQP/iQuTGa5CmmUi8+QU/ADBs8H
86quu8iiMZ1mI0Nnq+ZWzQXoMWDRXXBhU+sqbCTNeNFN61J3fA2cg0YQzsQ/Fvg3
9j5Nudk4w40gZVmZL+Xo9y0KQTkPYyNpLAdf1kK8gvNt81ZZQ2RVciAIxeujBLST
xnzov79g6C9MB3UPrmWY7a+gYxMWpBmTKFfIz9QTXkIoJ7S+GOJe46ozA5X33TN2
C3f4q4vRyqFy2IjhrGjN4hhHdxXPlbeEzm3j6Yyu/JAngQT/NR0yPP0qm51/E4nz
d5Q07u8Dm/InajsTz3j1LXxIXfm9VDrHuDcvTONU9xZXvr7E9fuvjTKl5DjnOo+J
eyGIbEkv37b7lV9vrUGyKaOnQpuJZDU3haX/8QbUW8lvmJR3pBHiLUHvogIImqSC
0q1d21oevgh9AbWA6gHt02co5wmUGIvaqsbm4lzJfqd/O3vwMBJL5FvNWsZUkLI8
6ZmcRvaHRukvbKXq0QGyjieqa1LGKV6VXqp1icU0Sk5zgMxAPh+WogrZocmVSedY
j4Y0/keY2fSbotR2vG2jVNrysl8BlrlVDeNw8zO87CUSWismWDhN83JtR9U8+FqY
5k2zjyzdKBqUu4Jwtd4qY3Ppj/KXPCQaDysv++aJ3aKqq6BEP3iZ6uCbmEbPe7yB
J7kwxQyZcALcD6pRhkX0
=FdFj
-----END PGP SIGNATURE-----

--nextPart2561714.SWRGmkjUa5--
