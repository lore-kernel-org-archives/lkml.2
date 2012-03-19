Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031303Ab2CSOXP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 10:23:15 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57819 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S964819Ab2CSOXN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 10:23:13 -0400
Date: Mon, 19 Mar 2012 14:23:10 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH v3 1/2] regulator: pcf50633: Don't write to reserved bits
 of AUTO output voltage select register
Message-ID: <20120319142309.GE3130@opensource.wolfsonmicro.com>
References: <1332125724.17246.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="VdOwlNaOFKGAtAAV"
Content-Disposition: inline
In-Reply-To: <1332125724.17246.1.camel@phoenix>
X-Cookie: Big book, big bore.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--VdOwlNaOFKGAtAAV
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Mar 19, 2012 at 10:55:24AM +0800, Axel Lin wrote:
> The datasheet says 00000000 to 00101110 are reserved, and the min value of the
> voltage setting is 1.8 V.
> Thus don't write 0 to AUTO output voltage select register (address 1Ah).

Applied both, thanks.

--VdOwlNaOFKGAtAAV
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPZ0E+AAoJEBus8iNuMP3dK4cP/iKihrn7iBAQdewDJJxnazJf
LXiX7e7kpdApvO4MZPiwC2jLYUkzFjFNacOJlLgyTF0u+K2rllyCohUNkFeCzm9b
TNNfWTOt2OF7Us8VubU0CPSZpbQO3DzQZWr29rfLoJcNFmM7Zkpl5IyaSAHzqZgi
8stRUyuPgwvEEvUoW/iMVCJwUHmNItjJS/eELf9PVJEGIHrEiRTT7hUklQFSLmQj
kTwbw+4LnAPAg3E1KaKJKbkOdju4FnUJf6eAweya5sdXSYBnN8Cz9G82rKpRFMZw
jBwXvgiveDJKDbpkDx9XW5YavKt1OpbnKFeXQhOLVPPUvEUg1ZLL8EDIRWNDO/Dm
0VNZsA/VeTnlXhlj03Kno3274zdSVEWaE2dHvguvLxEi4L8fTktQfL1+zKq5jmuk
YdjXWBi1nLbV0cd051D0QVezpnxmPTVteZ+TbHsFAZXUcg83RnlB3U1s2dNr1Fch
SgFfJZkOZzSEzygvi6a2+g33MVoPCUEs7b7+oNhB3i6ki/rFAE9SdsdFRXSgQ2/a
hHHJS+7L+vnEejlvjJXBG5XKbmQgc/4M8EZDZIi5+XJTAjksM/GErcvSoZIVxB+a
PuQE/zpe35v0EOiBQnFb3hiWBrCuz5aenNk08hsYmelX+nQ8vrq8BG1shfOdT9xQ
zq20YqczQWPnB3teCyfH
=WbPI
-----END PGP SIGNATURE-----

--VdOwlNaOFKGAtAAV--
