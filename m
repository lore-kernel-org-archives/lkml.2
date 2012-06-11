Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752396Ab2FKKgi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:36:38 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:52864 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751330Ab2FKKgh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:36:37 -0400
Date: Mon, 11 Jun 2012 18:36:07 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lee Jones <lee.jones@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, Linus Walleij <linus.walleij@stericsson.com>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>,
        Mattias WALLIN <mattias.wallin@stericsson.com>,
        linux-arm-kernel@lists.infradead.org, sameo@linux.intel.com,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org, arnd@arndb.de,
        Linus Walleij <linus.walleij@linaro.org>
Message-ID: <20120611103606.GG11439@opensource.wolfsonmicro.com>
References: <20120530121547.GJ9947@opensource.wolfsonmicro.com>
 <4FC63632.4030504@linaro.org>
 <20120530151119.GN9947@opensource.wolfsonmicro.com>
 <4FC63B39.6040905@linaro.org>
 <20120530164152.GP9947@opensource.wolfsonmicro.com>
 <4FC846CC.20801@linaro.org>
 <20120601084850.GJ24139@opensource.wolfsonmicro.com>
 <4FCDDFFC.3000902@linaro.org>
 <20120605103846.GQ23408@opensource.wolfsonmicro.com>
 <4FD5C829.2090408@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="RDS4xtyBfx+7DiaI"
Content-Disposition: inline
In-Reply-To: <4FD5C829.2090408@linaro.org>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH 08/22] regulator: Change ab8500 match names to reflect
 Device Tree
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--RDS4xtyBfx+7DiaI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 11, 2012 at 11:27:53AM +0100, Lee Jones wrote:
> On 05/06/12 11:38, Mark Brown wrote:

> >You're missing something - note what I say above about the direction the
> >mapping is done in, and consider what happens if we've got two of the
> >same PMIC down in a system.

> I'm still not seeing how this would cause an issue. The only Device
> Tree nodes which will be parsed are the ones which are specified by
> a particular driver's compatible string, meaning that any other
> nodes referencing similar regulator/supply names would be ignored.

Suppose you have two devices of the same type with an array of name
based regulators, meaning the nodes with constraints have to have a
particular name in order to be matched to the regulator.  How would a
consumer reference a node to specify a supply?

--RDS4xtyBfx+7DiaI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP1cmdAAoJEBus8iNuMP3diygP/371nBNscN/jdV+lha0w82Ag
2Ci/Ml9saNp3WpNeGq22lXLWI2IDN8xmfHsbEP01561d2a5SDIeANiLlZ8T4S84c
6DlZwkGAGJYWmJJDS3qZkOT14+C3NBUY6mUW2e44NWst4HqyqSkUPRl9aikRTwa9
Qy+4cCjhuAJHwna+BOkdI6GVYY/JhLCbhuv6A+04cpEVgzrfbrQutb011EpJHOZI
GlYun/fZrtrgwEatiezAYChlb09anprNjFhCLABRTS05hpukLUf1Ch5+h+qrfAzJ
zVCyUbIoEYurcypmvg1/cIZeCL3SB0N8BF0tl3zTGd/eZGXQobsufOTikuTemAR1
Q47A6TfC3tFmGOi0dtRT4jM0vW14IcSdEEy87geA9ox5W5S91X08N3D5/XfmAeiM
0qx10Y1ZA7Vc4j0/mYJPi6AgNz1eQTpUIBZMqOytle9NLnlJ2aNCqjpCsXVK25W8
2USaETEIMKQZek4CTMtC4Ll+xIVUarJUFti1WG+FY5tOdCht4C5ZCltLb5XbsXOP
Os7O3I6k91RRB3ITasu2GsQ/TgVtNp0WNAog3ocLj4Xi+A50kB1pW2X7DBR2LEc8
rYQxTsZhBt8Zjq2Hjj/JCPjWB57NxupK+C6lrWlc1U+xaCaCDxD5WxtAOr4GNmZ/
5NMy0IlT51Y4Bo99UMcL
=p2Fz
-----END PGP SIGNATURE-----

--RDS4xtyBfx+7DiaI--
