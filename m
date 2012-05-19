Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757788Ab2ESSsW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 14:48:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38929 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757268Ab2ESSsV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 14:48:21 -0400
Date: Sat, 19 May 2012 19:48:18 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/5] regulator: tps65910: add error message in case of
 failure
Message-ID: <20120519184818.GG4039@opensource.wolfsonmicro.com>
References: <1337438050-3707-1-git-send-email-ldewangan@nvidia.com>
 <1337438050-3707-6-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ht9V8wKec6a3w1Ef"
Content-Disposition: inline
In-Reply-To: <1337438050-3707-6-git-send-email-ldewangan@nvidia.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ht9V8wKec6a3w1Ef
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, May 19, 2012 at 08:04:10PM +0530, Laxman Dewangan wrote:
> Prints error message whenever there is failure on allocating
> resource. Also used the dev_* to print messages instead of pr_*

This is fine but it depends on patch 2 so wouldn't apply.  I generally
recommend putting this sort of cleanup earlier on in the series so that
it can be applied even if there's some problem with the more substantial
changes later on.

--ht9V8wKec6a3w1Ef
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPt+pUAAoJEBus8iNuMP3ddccP/2Winn/+zVa4DBeRz4OQG67/
CnCBa8JwWyIJh2t+cPb/GLR9cEw5rc+dQvvYFSnNIFw9y1GrxosRHc0/IXkuadpf
KOI7tbip1QWd5bJ9/3UQQCLM/bI10OlC8ShriqWim4ynF980oJjwoLSLRG4SZAPF
H2wfw1OpUY9Xt+BQgxuKAdl31UnB15X5oTPZmfYl9q1bmENyMdKKIbjqFVDvoel8
3EkV+l+ElilAEJS21vVLBMtMmKskU9laWEu6T9Z8RMnVYoI4kfEjfN19LPNGsUZ5
EE23QMfVfnvLyHa4c0EmeF9kHGMb2p1Z29FU0HI2HZbt4awtao1P//GTMDFrRnuY
O3F4cNGoagkEV5D0yrpE+VD88z7yrQl264us6/vRTakFsgrYEbYR91mdeva1BdTV
x+YlYxQxZtAX0oEZXREugENLYrRpXJdL8/q1o43wdyK6vgygEZZi5EmYxTb6ChkS
JXpxDacZmtg240gFfpvewanTY7BALQ/ZCW9Wz4c56afzGAwQ9/UTV89QmlmkFp+z
s9berQHTRdvC0rEhYK94Nr4qyzTtTOFeP35+7zEi7zLz6nyFGVC5xmW1NOR8/Rv2
BCPoWkGsoMc+GWVJwWijGT220MO8d/ceja07+EJ25imak2aKafQgCkFh8o4wgNc7
w9UD1bFXw3Tz1lkBif5H
=hnUI
-----END PGP SIGNATURE-----

--ht9V8wKec6a3w1Ef--
