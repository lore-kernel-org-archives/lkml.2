Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753399Ab2KMGzE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:55:04 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:53717 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752666Ab2KMGzB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:55:01 -0500
Date: Tue, 13 Nov 2012 15:54:54 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: sameo@linux.intel.com, lrg@ti.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3 2/2] regulator: tps80031: add regulator driver for
 tps80031
Message-ID: <20121113065451.GI18224@opensource.wolfsonmicro.com>
References: <1352646721-8350-1-git-send-email-ldewangan@nvidia.com>
 <1352646721-8350-3-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="82evfD9Ogz2JrdWZ"
Content-Disposition: inline
In-Reply-To: <1352646721-8350-3-git-send-email-ldewangan@nvidia.com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--82evfD9Ogz2JrdWZ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Nov 11, 2012 at 08:42:01PM +0530, Laxman Dewangan wrote:
> Add regulator driver for Texas Instrument TPS80031/TPS80032 device.
> TPS80031/ TPS80032 Fully Integrated Power Management with Power
> Path and Battery Charger. It has 5 configurable step-down
> converters, 11 general purpose LDOs, VBUS generator and digital
> output to control regulators.

Applied, thanks.

--82evfD9Ogz2JrdWZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQoe6xAAoJELSic+t+oim9BMIP/2uhr3uFfSBgXs1fmdiFXC55
oeqM471bJfjLw47VNixzw39YG5+Z2t4Z//OcSg0djhvxjV/iBp5Bzo2HnWKeRL/P
L8GUDM1esEdnH+noB8stNEIGZcyNPy+Hc5rvI0Hb8NtdmNQt21cQMbaYFZD4AmFP
H+Fgg1smgLiSbReVo0Ja1KcjwM6ynptO9LdAjZIAmASAeqRMyDeDMOmNKkr2Kyv7
nMNNNEKOJqauL1k1GLeAu+6bwE0jtrdrhr6fg8hSOQ8mjQqZnvND6ihSDdJeWYFc
815xwzkOB8s8eXqEN4oWbqmjQ/rn4bb+Zmu1HEFCUh4SXVde29OnAahhAn/KHGkU
ok/MpnHgRrvgBrHh9f9cBimq+Rg2Jga0TZHzB8+eYs71GDcznPRqaIYhpMyEo7Dv
gns5lFgIWaio9DbUHpT+TghJjT4cEXVbYA2oKkhwF44Alh/VFVnSIB91lulnxit5
PFccQfJ7EVqaAl33ez8eEPqYc4Rg/sh4WN+AByNb0Vi2H2L5DHj8JXTcyTcCOm9F
6vRQ7lbkbqLMf1RoNO1+olLjbdwd++sBTBy8JUESX2UkFSroiAoGyovCxbbcc2Y/
3/T7EQ1Mi7XNJXKAucPvvGGsNeDc7K2g5QLKlwMHy4GzroUGchQxqotD/kq+hk6s
cy1j3VZ/gZOKbeaLMQe9
=Fsf5
-----END PGP SIGNATURE-----

--82evfD9Ogz2JrdWZ--
