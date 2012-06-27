Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756529Ab2F0OE0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jun 2012 10:04:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57055 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752852Ab2F0OEZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jun 2012 10:04:25 -0400
Date: Wed, 27 Jun 2012 15:04:22 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Fabio Estevam <festevam@gmail.com>
Cc: linux-kernel@vger.kernel.org, Fabio Estevam <fabio.estevam@freescale.com>
Subject: Re: [PATCH] regulator: core: Remove unused get_device_regulator
Message-ID: <20120627140421.GA28922@opensource.wolfsonmicro.com>
References: <1340804428-17547-1-git-send-email-festevam@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LZvS9be/3tNcYl/X"
Content-Disposition: inline
In-Reply-To: <1340804428-17547-1-git-send-email-festevam@gmail.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LZvS9be/3tNcYl/X
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jun 27, 2012 at 10:40:28AM -0300, Fabio Estevam wrote:
> From: Fabio Estevam <fabio.estevam@freescale.com>
>=20
> commit 222cc7b1 (regulator: core: Allow multiple requests of a single sup=
ply mapping)
> removed the usage of get_device_regulator().

Applied, thanks.

--LZvS9be/3tNcYl/X
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP6xLVAAoJEBus8iNuMP3duGMP/3Svgc5kz34lqJSV+U6s3HH9
RleEbN/06A81JPZ7pKhF1ABlfSDwKMsUiOnzCQGMPcmTqXqzKcn+vHclw42NiOFa
vPzwQ1KkzZZZMDWFWXkv3/I0YiqsKKplFgvrZtJkyrtshru50f1bRxCiunTnP5pQ
UcKX2c9eJryyU8Cwhw8YVhkFhlNaY77dmm1pH88cBEEFG8AF775mONN/hqAZSEVn
zfVERjGGnPxbS/l9KMswKU8rgwpP/KcgocsRzrMVKVWnyJWPAu0QoMtd5oNzyPfg
xK58XWatqIQwhLOcoywCtxx1vjYwtarxGEWW74eoxI6g2BJbFgcowibryaE7h/GZ
rQP1nmjIOgBpEihnqgUnj0muIdXQaEKH9tKhPp1bQ0L235XrONp4DFbiPaqUUXTX
FFCGR1G7npLo5dq0nnfj+vSb5+vKb+91vsEJyGH5AmlMbJw/ZfRx2g6GxbcNEpvR
YPIvzVR3WISmsa8fx8m574mnK29uq0tDobUMn6AFIA5j3p2JD4DvjWoCLuPB5qIb
t9svk/mSChTiKoTxDDHLtHNKFoIpWxSAuyM/A0e6V7NLdk6cBQB9jAFfvB1qvMc/
XdDf8I1DMdaJ10SUdshjDRBVK6Ng+/dFKs3wWSBV5dbirHkR40nabKPFphNM7rr1
ECpAp4XgNIMcs+1Jju3s
=omQl
-----END PGP SIGNATURE-----

--LZvS9be/3tNcYl/X--
