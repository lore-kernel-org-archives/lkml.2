Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756194Ab2GJQRf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:17:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33369 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756161Ab2GJQRe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:17:34 -0400
Date: Tue, 10 Jul 2012 17:17:28 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, axel.lin@gmail.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps65910: correct init value of n_voltages
Message-ID: <20120710161727.GH10022@opensource.wolfsonmicro.com>
References: <1341845833-7023-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="YH9Qf6Fh2G5kB/85"
Content-Disposition: inline
In-Reply-To: <1341845833-7023-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You look tired.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--YH9Qf6Fh2G5kB/85
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 09, 2012 at 08:27:13PM +0530, Laxman Dewangan wrote:
> Recent change in the core driver to get the maximum voltage
> is based on the (n_voltages -1) steps of voltage.

Applied, thanks.

--YH9Qf6Fh2G5kB/85
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP/FVTAAoJEBus8iNuMP3dQTgQAInN4W4ormYtOr5/o1Sa89aC
tTZV8eBQDSaNuMFDoBDoZYYmsFXGk/S4YmKNS/T8DiMEs/MgXrlXppXdXiUB/fjm
Wt/ew4yP7vLFnqUIzpsueijyoJoXARsmfj3gMI90PDMmYWiFz9rhNuekgB3CEoWO
6pRuvFYfzDqOgPGMpsR0AADH+fCOjrAmYPUAHx5jWwQyUzDjhZttk1DwEfSd7C8J
ucl6VbAae9IWhRqtudU4pa/E9WGXXBnlFJpxRdCEiKEmXNLNTcRm3H+sOVRPD1lU
WKLVZKnZ3q/RgzBkSbY8ijW/+y9EVlabYEPlFOWBGTQ8bfN6G9YEyHtbR+BYyCqm
BqsGr1pawA1/a9/mBPeR96OANiHyVUIgnehTXuza71og0VXoZ2FRKECBQM+N4QGt
6vZ87E5Mho4TbFCy9coHO41HEArEZr+8hSj/hh6ZVjJMFoce49HVvRvxovpb3Kl3
n3XcXHSTuoC6E/9U+ZjT0PBAg/VmvqD/rIKIvNzsJvxRwrQmiCZYG5ocBSkQLTLa
J0m3TzYk0qUQqLns9QkKsLUEZVxx7vVmHOufrcY0X/lS2Jqek9P6bPazRUhunsgy
+hmuGZ/Wntp5pDAyU9P9sMeT0Nh5Zh/CoBd0z95/TPCERPD7Pkxgtu5aid6gKzGI
cgc3D0DhRFA3oYSop42a
=VEtt
-----END PGP SIGNATURE-----

--YH9Qf6Fh2G5kB/85--
