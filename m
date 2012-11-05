Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753189Ab2KEIEg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 03:04:36 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37735 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753067Ab2KEIEf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 03:04:35 -0500
Date: Mon, 5 Nov 2012 09:04:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alexey Khoroshilov <khoroshilov@ispras.ru>
Cc: MyungJoo Ham <myungjoo.ham@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>,
        patches@opensource.wolfsonmicro.com, linux-kernel@vger.kernel.org,
        ldv-project@linuxtesting.org
Subject: Re: [PATCH] extcon: arizona: unlock mutex on error path in
 arizona_micdet()
Message-ID: <20121105080432.GB28886@opensource.wolfsonmicro.com>
References: <1352060386-13610-1-git-send-email-khoroshilov@ispras.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="rJwd6BRFiFCcLxzm"
Content-Disposition: inline
In-Reply-To: <1352060386-13610-1-git-send-email-khoroshilov@ispras.ru>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--rJwd6BRFiFCcLxzm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 04, 2012 at 01:19:46PM -0700, Alexey Khoroshilov wrote:
> If regmap_read() failed, arizona_micdet() returns IRQ_NONE
> leaving &info->lock mutex locked as opposed to all other return paths.
>=20
> Found by Linux Driver Verification project (linuxtesting.org).

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

--rJwd6BRFiFCcLxzm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQl3LvAAoJELSic+t+oim9bmAP/igBqCspT6uW1ocfi/7S3sJe
VSf0Kkj9EfKRZK8T2AXZZuFwuuCuLFY/tdifTxVaDUI8Lwsp/ow398kibDxi8wW7
08DmsPo8StOqxgzsU/8U4guRLhp7umtZYQDIDsjGHtcoDtwm/9Lk4E89JDX+wHeK
KeBVcEFcR1/grGQC3gl32wyFJlVcJXuG8ik/2dlFGyUyGw54PoGNkmjggzcrBstc
bufE+mmbJrjWc58mM3372nyHfvMfMF9bDX75s3POmS42gNnbBolA26szt1l2BxIq
p0lVcCS36Z6fto/K702lNy79dmaOW73+hsw1TrsOPyhy0MmTLfHD8CfxmL9LikvB
EqT5PSa0tfWzR8WZBgXDNbMXPXY++sKkixJxmSFIvRvXirA7SkvLtZ6MTgrjSuLO
9gFdsQf1Gh9Je5ZIv/DTKVMgwzzNj1AtIr2A9/hT1b+g/2YQL9cNnZmWq63QOdNy
/IftO62kB5bMGkG2+pQm9CPXkR6Rakso6+MyR6e996Rt3u+f7v+nZAB5DxNS7w1n
KfbSkkmt6kPuXoUBWVp5Tt54tynNDyPaS1YG8H/NEBpb4Fv1MQgW5aousmHj4Ty9
vr+KczBis6F5KJx7Hyh0PSRXyXwsMG0bDXDQka4uXyqszqgBj9fr9/33cKxVmgUw
yR3/+pi4l2mhiVJ08gAs
=QTTY
-----END PGP SIGNATURE-----

--rJwd6BRFiFCcLxzm--
