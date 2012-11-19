Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753112Ab2KSIDz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 03:03:55 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:51209 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752323Ab2KSIDz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 03:03:55 -0500
Date: Mon, 19 Nov 2012 17:03:41 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de
Subject: Re: [PATCH] regulator: max8973: add regulator driver support
Message-ID: <20121119080338.GC4406@opensource.wolfsonmicro.com>
References: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PuGuTyElPB9bOcsM"
Content-Disposition: inline
In-Reply-To: <1353288509-26703-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PuGuTyElPB9bOcsM
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 19, 2012 at 06:58:29AM +0530, Laxman Dewangan wrote:
> The MAXIM MAX8973 high-efficiency, three phase, DC-DC step-down
> switching regulator delievers up to 9A of output current. Each
> phase operates at a 2MHz fixed frequency with a 120 deg shift
> from the adjacent phase, allowing the use of small magnetic
> component.

Applied, thanks.

--PuGuTyElPB9bOcsM
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQqefHAAoJELSic+t+oim9vDcP/0FBtVjTtrE2/fDtJR1eLiHp
isH5sDK1iHl/f8ls1fXV+HiJWQ4nJK24E6yn8PgPww3PddG9V3ACixOMf+LO6KOI
Cn/CUMBXpBcR9iDqChCNp3HAIXzHp7CNO+D4IDcEe+bQ6I7vYS1HcKt8oAkXaI7d
K6EVPXYoFH86kKcJx/6rsP6Huj7Dqnkf4lClq3LDD9rW/jjsO5m4fHXf2lk9LWrH
vumFhOEkJiqsYZG/T690f7Rl0Ws59lv7NQheB7wwasUv1qUU17qqD98Ed2n1jfZW
dYNFzdHnMMY8lxZbROkM9/bTRmdTKkcOltyRgkHqx9Ndzy8duDPvEK0hxwW0ur1G
nojVSQ58Q+hzglGw4tCbT9Xhpy2po9bcNZcP6hHt1cnMAp98DscaNYdgtASjvvOT
eMFOMgIZhzIbql8YWrMYqm1VdHcwlnbs4TQu4L2EKNpW9i0VyNcd9GPWNNM3VVK/
EgtfAlrsyXOqAyszFGFdobiEXULJRJNjr/TomTNDpQn+2n8tfxsBirj30kmUTWSk
6YII+GSfSqc0hCiF9VYO+5og7Td+7IbxMdcTnQRtXD8gkGfbFTDIsiptmFvTbp82
LKYMpvvusHNsW2J+5S8FqYz2WSwnFAR5wYV0kkwcAjfRrEhveob/NkgcdiszVi+a
za3IvMEFbkWZq7HO6Jh/
=reRo
-----END PGP SIGNATURE-----

--PuGuTyElPB9bOcsM--
