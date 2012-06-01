Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933355Ab2FAOcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 10:32:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38992 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758182Ab2FAOci (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 10:32:38 -0400
Date: Fri, 1 Jun 2012 15:32:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, sameo@linux.intel.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
Message-ID: <20120601143235.GT24139@opensource.wolfsonmicro.com>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
 <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="mvzZjokS1nTZS3h1"
Content-Disposition: inline
In-Reply-To: <1338353260-10097-9-git-send-email-lee.jones@linaro.org>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--mvzZjokS1nTZS3h1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, May 30, 2012 at 12:47:26PM +0800, Lee Jones wrote:
> The 'name' field in 'struct of_regulator_match' expects to match with
> its corresponding regulator device node in the Device Tree. This patch
> renames each of the regulators in the ab8500 regulator driver so this
> is true.

Applied both, thanks.

> Cc: linux-kernel@vger.kernel.org

It's helpful to avoid inclding things like this (I mostly point this out
as you've got a much wider CC list so you clearly have some other system
that you're using to track where to send things).

--mvzZjokS1nTZS3h1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPyNJ6AAoJEBus8iNuMP3dnbAP/3kmfnL4JEyok2mQd3yIdAqT
lubVFMktrwLLrjdZmDxBeZeUp6/OkpgFZCmTV3+YRAb41jdIYJJFKVUsgrt6hKZV
UtRMq6iAwMY0OUsHlCcndUF6bBLdTN+u/lPxokLt5w4k84CGba0V2XQgz3+bWklD
L6r0zHAtRWCYdwl/ehj3uI3KSgIx9TNuP6q7ybCuZAQ9KuEv3TKd+iPYyHeHS7xh
EbT7vz7hAdQRfH1phoXNJpRZ/RZV/QpSaRLm6xKU7hLjnRn6EJdjq+ILsHGzSmsG
ouhaxVZFyWbvwNMN4BHjB4oOfdpwR1jzN7g4k6YaBCh2V70gCQUsXjABqJUTDb3q
5F4nACmoAJe+8D8w7ERZhLxPGcswF2tgiWSIpLhrKzA5sXEfBG19vN3PGt+Xi81O
996v3vWbHs0TILkyhdIbB9sdeWAuHEe7rrsQ0xaopELm7G7ndwhsiUSwdA7uzfbw
vM6+ZzsSv+GZziQU5CJ/c5nQwFpR833V2onNLwWXvTTsN2Pg/DIPcOwp3doJJNiU
WAKM1NsGbqy1wjoCv0e31o2MBis+cxPSjjIbd4X6kEBgMpe3uxAaISE3hu8J3CiA
jtFQV7QOs4B86FMNYFDKzYxZ6nWuxYlb4Tgsz5BCGJ8xllOI4lM+rYbPUHH9T/fg
QwFjaB80A3NXs6QrClqS
=muh/
-----END PGP SIGNATURE-----

--mvzZjokS1nTZS3h1--
