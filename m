Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757146Ab2ESScV (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:32:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:34370 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757066Ab2ESScT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:32:19 -0400
Date: Sat, 19 May 2012 19:32:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "lrg@ti.com" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5] regulator: tps65910: set of_node for regulator
 register config
Message-ID: <20120519183216.GC4039@opensource.wolfsonmicro.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
 <1337438050-3707-3-git-send-email-ldewangan@nvidia.com>
 <20120519174829.GZ4039@opensource.wolfsonmicro.com>
 <4FB7E449.1030801@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VmlJMtejgecKmNHY"
Content-Disposition: inline
In-Reply-To: <4FB7E449.1030801@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VmlJMtejgecKmNHY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 11:49:53PM +0530, Laxman Dewangan wrote:

> In this case it will not need to have #ifdef CONFIG_OF in the client code?

Right, we'll be able to skip it.

--VmlJMtejgecKmNHY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt+YHAAoJEBus8iNuMP3dq6wQAJbvIGAJshbAMpAENOMnDlUw
iRyNo3eRWgsVR2/N8TdNkqC0/W9kHQqwWoPcuqHZfECLBBWGSh8IAaPYKLoycLUc
pqYOuu7HW+E6tIJ8+J9PYTnWJnaK2pV/fOUzLkKg891jaZhwCzj8vDfi34VKxxLI
8Cj4ZAVUxrwXPNgxVuWTGUHoI3IoCKvb6KJKLrUR/Gn08et77aIYs5twQ4nknus+
CfGRtuQ/Uutr3+ZmTa5NkBYafjHoUGkRt1ox8ZVHBBbTwWS3SyDdp3+efos85EmB
NOA5CW6mlRdSO3HIx+Ave9C+iCyHpSRo5lihJxvDyBkpsdIBbAuVrwMR1wX9Yd/m
csW+KeeTpYIQNbk/wFLDlhCOpHnsOCeAy7TdDu874qvcuyvOeiY/FzICZL4oWpNr
q0OAcvC1jhecdmlG5c040UaI/ucbYP3Puz6unSBFXZ4/65mRVftwWEOdWxevHedp
LtndAlC/NZHuXNkjG8bpGOnJidCM98Rj4zFDOfCtipWCqWZaCb4nUpW80n0yg8TS
21wQhsuIVmF0Z6K7bhP0y5KX9RTXXW89U8CWmSKx89eY0GHGs2SmsBGpY909dBJy
6RfW5vE3ZBxY4EStYoG1qZH3AtnlZ2QeWu1W8i/9sv7iatPZQOKaxeS7V4j4/6BK
Br8gsh/s83s1KoVYKyGY
=S7kL
-----END PGP SIGNATURE-----

--VmlJMtejgecKmNHY--
