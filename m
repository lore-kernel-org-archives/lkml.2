Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab2KUCLS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 21:11:18 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41303 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753243Ab2KUCLR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 21:11:17 -0500
Date: Wed, 21 Nov 2012 11:11:10 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Davide Ciminaghi <ciminaghi@gnudd.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: introduce tables for
 readable/writeable/volatile/precious checks
Message-ID: <20121121021109.GI4673@opensource.wolfsonmicro.com>
References: <1353421230-16070-1-git-send-email-ciminaghi@gnudd.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KrHCbChajFcK0yQE"
Content-Disposition: inline
In-Reply-To: <1353421230-16070-1-git-send-email-ciminaghi@gnudd.com>
X-Cookie: You will have long and healthy life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KrHCbChajFcK0yQE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Nov 20, 2012 at 03:20:30PM +0100, Davide Ciminaghi wrote:
> Many of the regmap enabled drivers implementing one or more of the
> readable, writeable, volatile and precious methods use the same code
> pattern:

Applied, thanks.

--KrHCbChajFcK0yQE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQrDggAAoJELSic+t+oim92mcQAIvJPamI6r9j4n3iNrHNikn2
IPI7lc9R/nHUxPXGXWwCo9BrwSNrHN6JrEU712iglxy49GDk9g8u+ro74IbbgIAZ
+6LPZndKcOL+zOSRWRL4pzGA1qR7UAwlkhUFZR4rDBShjO8CWpim1RKMtHz+C26Q
Zbek9bupCn7qC7roxWqCWrjLxVgwp5RdGcEo28Q3eByT09GHYDrgRI7VqxaLC+lT
8kRkMZ68nwyBbil0kXzT4B6sj1a5iSAkxeuI16kgBredzqpKLXXrHyQPo+PY9CUu
Ze6fa2Qd3Kd2DzphjlBTsp3pO1MG6LLEP8YX4ha3hLgEypP23pZd61+9voTOEzTP
aZcDI7CjRgln9iO3YJ1lDTvL0OWU0aKwmMsJnWCHtsc+jYeTj4laYS6sN2c5bBfF
BEtUK3G4G40+68qHeMFTgAzLljQs9ZulwnzAgztmpLuj/FUv6w1eIr2mRb96qaHm
TD4tPLt48OyzQf4vUnQAY3BaE/GNvWcna3J+bK67mbXIqrWIwC4eF3bGqdtKLQ+n
QwifccpznEomhMskSyk6g/xM4JQTSBnaqncJGmGK1mI1jidZJtkEvNygBPwUFX8R
JYanfCsQauZYnr+SRdpUnp2sfEKEnNpM6KZoBGK03Q4ZFLL/v4qm3Uj+OtnMdDYE
2a+InP5IT2Fvm4tA5t2L
=tB0r
-----END PGP SIGNATURE-----

--KrHCbChajFcK0yQE--
