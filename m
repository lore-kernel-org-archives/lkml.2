Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755537Ab2CHSJM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 13:09:12 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36774 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753662Ab2CHSJK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 13:09:10 -0500
Date: Thu, 8 Mar 2012 18:09:09 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, jedu@slimlogic.co.uk, sameo@linux.intel.com,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH V1] regulator: tps65910: Sleep off rails when ext sleep
 configured
Message-ID: <20120308180908.GW3638@opensource.wolfsonmicro.com>
References: <1331124709-30402-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Er97KPJOrxRt+yKZ"
Content-Disposition: inline
In-Reply-To: <1331124709-30402-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Don't Worry, Be Happy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Er97KPJOrxRt+yKZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 06:21:49PM +0530, Laxman Dewangan wrote:
> Keep the rails OFF in sleep mode only when the rails are
> controlled by external sleep control.

Applied, thanks.

--Er97KPJOrxRt+yKZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPWPW+AAoJEBus8iNuMP3dKQYP/1YRroaPPCmLz0lC45aOoAuW
/46J4yooll1ttFDWPFwpwjWg4GYmujPxPITk6OMIY6EdKcccLWM8lo3PvA9AV6rQ
zFyC1H0vwa95qXoeTpxZP6211RSywGQVHTo6ILGifLthKCIX505Y5/a70f+CIFQA
sWOk6wxMTb8R/TDLg4EfD323e35CSI5YPI09toslBV478q07X+B3QITPUBpEVUJq
zmngiWuST2olCLt6ogx3yzJXPq5K80NEq7bqgiPxXLOPnvZ323yeHjfzYvMQJw95
cCkiVcrxKoJnn5XKsYQ0VyB1ysSI9018IxPO+TallWhnpJH2eu4Q2LgyUW4ABJyX
Xbr+a7pyCcdT16eKAP1mF8SWShU3LEwxMJnZcBucWiiS/QYyE2YnNnhGTnxUSjm3
8GJQwUHuCm0hx25FdaWd6Yzd28++707Zw6wY8u1k4ozIi2k5HLclXPV6WoPuu+fz
t/lfyaPtHMUZ9O9J0x/KdN4ZKNUXhD5HF7GJSQH74AwwHXRzXWTY0zBoJS/daLMW
AlyuPu1QsYCprNsnwLqS0AVoWcOQFqrBHIXyzhOfskPt5axHTKNhrkRShUS+PJmq
7tsW6U9Hprl0MX+EK98JdMGMkZuhWjKwRW7gzZH0el75lBBIkoTXwmbJkQAqBfg5
EXgbkEtE3eoUplhrh4ry
=Hwdy
-----END PGP SIGNATURE-----

--Er97KPJOrxRt+yKZ--
