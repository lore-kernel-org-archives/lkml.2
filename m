Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756623Ab2CUIy0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 04:54:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36600 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab2CUIyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 04:54:25 -0400
Date: Wed, 21 Mar 2012 08:54:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Margarita Olaya Cabrera <magi@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: Implement tps65912_list_voltage to be
 shared by both DCDCs and LDOs
Message-ID: <20120321085422.GC10935@opensource.wolfsonmicro.com>
References: <1331803056.13750.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="8X7/QrJGcKSMr1RN"
Content-Disposition: inline
In-Reply-To: <1331803056.13750.0.camel@phoenix>
X-Cookie: You dialed 5483.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--8X7/QrJGcKSMr1RN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 15, 2012 at 05:17:36PM +0800, Axel Lin wrote:
> Merge tps65912_list_voltage_dcdc and tps65912_list_voltage_ldo to
> tps65912_list_voltage.  This change does not add too much complexity in
> tps65912_list_voltage function.

Applied both, thanks.

--8X7/QrJGcKSMr1RN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPaZc4AAoJEBus8iNuMP3dxesP/28RpxXEw3EheyowWO9PlM/B
ME5kB6/3dNyBewx1qPDMkZdW0rCdmXm6AiJOgcw/RhLfrWuTNU7k26x/0t8aGRe+
8YyrHIScUd8uPZW7QYXbgAjrH5q38IeNAg36XoRTzHQLt/Nr8RGapBvyIs+RaMvu
LDPQ3BWQ+NNr9ZeAWqX4PeufidV7PrdA7MHhbbjk62uoOVNwOhHseawZBZeRV4OY
MU8H3kbwGRlSOz1fBM+0MujuId9jAxpx3ZY/ivneGkI+JiZXkxtgyBVVr9e2M7/J
Jmr0s2fiqk+AXjGw5y38j+OyZq2VCS1R7Tsd9iNwAt8npWRESo7+vjuL9gCAwm/j
IMl2lNLf37KcTGm65l/M0sr5ygFVIXFqIyeMUXBV4MGgvds4dRYi6Z0ASjub+lS1
rtWAuFKEvVepUorGcC7qYZbVrwltdpCBb9gAjEPkJRA7xHDw3Zt1lhKHEHyoPcHA
HSgy7GZfWvLbd+IgrS8/W/0fmO4X4ObasQ/LfdfVsQ/AI9LW8IDF1Fas8C//ynQj
ODLOFfYFCx1fycBbEPOUdQ5PkqRW79ibBj/2SFHyLNFUXG625K+q+GkoqlgSAk8K
dSqPXPOG5GMl47aDFqI15WJUnctwdK/+rs5sEU1CsCwpSyZJQU8bc/+CJdE+eEPt
+fjGt/DmyfAYdH/goe/B
=+Dwy
-----END PGP SIGNATURE-----

--8X7/QrJGcKSMr1RN--
