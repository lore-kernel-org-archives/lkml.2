Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755936Ab2FTKGf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:06:35 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33320 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751930Ab2FTKGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:06:33 -0400
Date: Wed, 20 Jun 2012 11:06:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] ARM: dts: db8500: add node property
 "regulator-compatible" regulator node
Message-ID: <20120620100631.GE3978@opensource.wolfsonmicro.com>
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com>
 <1340116099-17629-4-git-send-email-ldewangan@nvidia.com>
 <4FE0A546.1010707@linaro.org>
 <4FE0B79D.4090201@wwwdotorg.org>
 <4FE1772A.2010806@linaro.org>
 <4FE17E24.8050702@nvidia.com>
 <4FE18371.2020602@linaro.org>
 <4FE1877C.4090103@nvidia.com>
 <4FE19036.1060008@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LSp5EJdfMPwZcMS1"
Content-Disposition: inline
In-Reply-To: <4FE19036.1060008@linaro.org>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LSp5EJdfMPwZcMS1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 09:56:22AM +0100, Lee Jones wrote:

> >Are you OK to have the first patch with adding property

...

> Yes I'm fine with it.

So is that an ack?

> It's only the unnecessary reg and *-size properties I'm opposed to.

My understanding is that they're required by DT policies in the same way
that some of the other verbiage is.

--LSp5EJdfMPwZcMS1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4aCTAAoJEBus8iNuMP3dFmkQAI2YR4TUUUyWjyQpYaRWFXUE
m8eTJtR0YWJQ/nrTHKgc4B29pukneWzn7XjONrKYkFV/eDKEuVrKFrObwblN0LVw
9y48vjJUGcvrdS9QBX0l8gKa8jVOYr7JTo6fKPOY1ahisEKTs/genJxGR3lV/jH0
SJtPR2Rs9EkkVO/JX6Nx3aYUNOkPnZOlTgy0Le+NIPpAqkRvoiuj3LgJ2YUgNYRQ
2GSp23auK/GGW2PsDtuU1cvR3IAkHPc4ukHBz0CSzzzZhNHf1AGBrVJbfc8vv02E
BP1nUqmxR5s7W350IB3MfYOJyVe0eXbVJrQgtoXg+vijs3tYDTuhHFa0g982Fn2q
c4ky/WG6y/9SvfjARj3DQDuptvZidq/dQRtS4DNUngTzmVCl/E3wAvmwYFSAVuXi
CpqbfdcJmRV+m76fiWuYlFfRi7DNnZgpjuVkEYkXVCM0no4ePqyI3h6+nq1EQhqE
KHPdLuEs6qih+fTwIkon35xeeHqdWhVC68C04088QjqoBkQIVGjy9QIhz3eWemA+
yot/LviFKULvHgTwyTkkznGu9JTKBB7r+g6G5W/gVB/TA3YPEByUE0zLHe281x7W
LlPWIeQZvLgO1FMAh0PYiJDNz/P10QGYI4iE5fXcIGXNqLohgxOOb1Hg0D+NqGHP
v5HCEJDyvEQXvik43mgo
=Qmyf
-----END PGP SIGNATURE-----

--LSp5EJdfMPwZcMS1--
