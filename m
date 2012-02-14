Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758563Ab2BNBJy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Feb 2012 20:09:54 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57395 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757611Ab2BNBJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Feb 2012 20:09:52 -0500
Date: Mon, 13 Feb 2012 17:09:47 -0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Regulator enable/disable delay based on board design: How to
 handle?
Message-ID: <20120214010946.GE11931@opensource.wolfsonmicro.com>
References: <4F38D55A.5020208@nvidia.com>
 <20120213163711.GD3494@opensource.wolfsonmicro.com>
 <4F394F28.70709@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="C94crkcyjafcjHxo"
Content-Disposition: inline
In-Reply-To: <4F394F28.70709@nvidia.com>
X-Cookie: Your present plans will be successful.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--C94crkcyjafcjHxo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Feb 13, 2012 at 11:28:00PM +0530, Laxman Dewangan wrote:

> Interesting, Many regulator driver is written like it just take the
> regulator_init_data as the platform data and does not leave any
> option to add any new platform parameters.
> Not sure how can we add platform data without too much tempering on
> the existing user, but if we can add parameter of delay(settling
> time) in struct regulator_init_data then almost all driver can
> support such platform specific delay.

This is part of the reason why the driver_data field is present in the
constraints - the driver can take that and use it as a pdata within
pdata structure.  It's not terribly nice to do that but it's possible.
A standard parameter might cause too much complexity as drivers try to
implement it even if they don't really need to (for example, due to
having soft control of this stuff already).

--C94crkcyjafcjHxo
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPObRUAAoJEBus8iNuMP3dK8wQAI8xnI0usIyEhgli8drPwusw
1rSYZClk1DCs5Y8sAsb9fZCxwxK+J5Z484/3cVwiH7IV9+2Jh/pVaWzMOeVc0AqH
cbeIrfqqiXbM/YfR1yE1+W5yYTHB0VzYwISwigAlIHFzNwwncnpCNATqZ/2gclAF
DaUQASFNWFoebbDChk+3PtqSg0iqeWDbQ84eoNz1QeE37xMgIay0MdN8xhBsuYAY
8mjyeeNDa6pvtlFQxRsV97vy5YiY/OcvgT2HVhExGjjpEAnN00bWPNWMBJATLYZv
S9w4f45Ol3zyA4iYCsGZgGwj+92+9AzFWZWBY1jTA7t9uF4I0UocPvNeQ1xYUlOC
xfGvtgsallinf/RHEvZM9QJDcdWNBKS5cPPvgR3U2EdktTxADCcnYZNJJhb9yd5y
+z7gNIXNUJBBJIReJVyQdWBDCrUIalULXrWqgzAjeQi5+0/FCWuJHuVtS1+OI41s
R/CrYC9PFZdTqiDTCCdTQDwesrExYkBTfyi4cQ6ZxphKya1PT05KgP2t6Wbrwa91
mJZlUmSrpeEiLk23tn2TDXQmFWlsUxSQJ2+Y9AJ6+msNgHRo7wkluNtUdpmLbM89
3uF3HX9gXdnMXQhhyIzwM6Rl1KwLy5l3MvHCQ/ZOzwn6T0pXNipRzZq2SNaSEYTy
IJ8e832ml+j4ShFsA4PM
=hl9e
-----END PGP SIGNATURE-----

--C94crkcyjafcjHxo--
