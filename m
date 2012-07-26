Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752777Ab2GZVK6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 17:10:58 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42410 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752616Ab2GZVKz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 17:10:55 -0400
Date: Thu, 26 Jul 2012 22:09:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Kevin Hilman <khilman@ti.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Arnd Bergmann <arnd@arndb.de>,
        devicetree-discuss@lists.ozlabs.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Magnus Damm <magnus.damm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Benoit Cousson <b-cousson@ti.com>
Subject: Re: [RFC][PATCH 0/14] PM / shmobile: Pass power domain information
 via DT (was: Re: [RFD] PM: Device tree representation of power domains)
Message-ID: <20120726210952.GG4560@opensource.wolfsonmicro.com>
References: <201207032302.17805.rjw@sisk.pl>
 <201207242237.28051.rjw@sisk.pl>
 <201207251300.34892.arnd@arndb.de>
 <201207260032.40159.rjw@sisk.pl>
 <87vchb4ar8.fsf@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="reI/iBAAp9kzkmX4"
Content-Disposition: inline
In-Reply-To: <87vchb4ar8.fsf@ti.com>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--reI/iBAAp9kzkmX4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jul 25, 2012 at 05:38:35PM -0700, Kevin Hilman wrote:

> That being said, I'm not sure why ti,hwmods is being used as an example
> for powerdomains.  hwmods describe the integration of SoC IP blocks
> (base addr, IRQ, DMA channel etc., which are being moved to DT) as well
> as a bunch of SoC specific PM register descriptions.  This stuff is
> SoC-specific PM register layout, so being very SoC specific, it has the
> 'ti' prefix in the DT binding.

I think the thing here is that one aspect of that SoC integration is
which power domain the blocks are in.  Describing which power domain an
IP is in isn't a million miles away from describing which hwmod applies
to an IP.

--reI/iBAAp9kzkmX4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQEbIaAAoJEBus8iNuMP3dEkkP/RHzlxy/+eWV5QgqreBy6Go+
FTqy5La0rCLvrQ7Sy61TyTNRshmtulViQtkxEpDseshdkzT7OgK91rzjs6nxzYAQ
UndvBuJ8Y5xJZJcB8WCS+E6Hya49TYIT4n1tsQ+M++yOwi0M9CpxNiDhMDaU5LdB
puUrP+G18jqtxrwkWQip0LWd5c854tmmb+4j7olkXT3RgjGi37P78LlNFVyB2gOF
4byJ3wlEb1Ky063UpEkIi96zc/D8Y60XIvqAKAlTtbcux0FrhQjJhZX+E7qejteP
YTjD13wfV8z8xarWxpY9MuE0RWddSx/k+wRA1EJ7oKXYFwtv/VI4Hj+bJGwQ/YMg
IqvJQuC/Xs4w+owt1NKrB8ypTPlr1HxhE5VWKX8nP0tjc0ImrP3ymKtdSA5PziHA
+cli0gH371FcodduXWUyK+U3sFdJM7iMCD1ZDseF7AeHyNjh6oWRSKMAkjWZERwF
/cngOqOoFDODFbI5FYIQ6ZjI1YQ+Qq0jkNGMMUt5IB2KQISvvvrWZ25h7EUv1Hbg
YIEfurcRkDxKg763GrR8vPws/m+em7U899vIj5UCBk5MYW5jI2mq7LYcU6hrpSjJ
vd5I8bs1nmBcJzuUbAayFOkFHA196MkVbNg1w88pm8tTDlrwta0iVB22PizUinBw
RAubLO44+NrrSd1W3lAH
=5xSf
-----END PGP SIGNATURE-----

--reI/iBAAp9kzkmX4--
