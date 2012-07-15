Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752104Ab2GOUuT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jul 2012 16:50:19 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40531 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750978Ab2GOUuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jul 2012 16:50:15 -0400
Date: Sun, 15 Jul 2012 21:50:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps62360: use devm_* for gpio request
Message-ID: <20120715205010.GB4041@opensource.wolfsonmicro.com>
References: <1341223548-7782-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1341223548-7782-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You should go home.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jul 02, 2012 at 03:35:48PM +0530, Laxman Dewangan wrote:
> Use devm_ version of gpio APIs gpio_request_one() for
> requesting gpios.
> This avoid extra code for freeing gpios.

Applied, thanks.

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQAyz8AAoJEBus8iNuMP3dr6wP/0kaDEI5iglstA5RA+dHMZ3x
7SvQw7knbyQRbohI31+SBXzdgc/8yLB7esyXab9a8YmgdzrUdx6LdfBrRYE6QiUa
iBTiWuO/nV1+ZBMvxstaM7MyEQiKze2dmR4P+MpaN0kxCPnlDEjio8nskubFCP6T
Zb8HgGD1R8Jz46EzMvbO/m+cdYaKBajIw8K/AOCmbizlZgOxdDWzOSM03lx3fGR+
wDp0zIAYwDjskderIG7HYbHYtjfzZDQoYFH8gzK+pmQ09oEPwng1F5M8J7GUyP1X
Kky5D++VyphFcjW32KOqBAAEQNHzMsSllw5JWagaV94VKG1vkChEfaQS/wCh59eu
3u6LoLNf6OFjcvQO9x1zjurP7pfTp8jwrNFcV0QhhP53TE8Mxzd8PqSvYhqCb344
mpN2L/f4m+DKRrBPuF5MH5BGMzbZbAuu/2nzqoiN/xDR6nf4fN8XCYseYuw4kzt3
x/Zb3XjPg8z861BFjZQt79LUxvAcfi2s9y8zPgtAJcewwmbXegpSRCET00MgPCNB
qNyw4aq3/HwkXAoc+7dXNbKxIS2JQqjKTlU43SdiZv9x+27UMJMu5I3udCOQG+V/
ZRCeEcirt3au7R5qg5mMRATO4LcG3uUsyKWjSv9hpish5d4zFiR5vU7UzpjyN/y1
Xc5yocTsyGnap//2i0qh
=v52Z
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
