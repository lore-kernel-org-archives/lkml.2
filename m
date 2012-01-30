Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2A3QZc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 11:25:32 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:41672 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184Ab2A3QZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 11:25:31 -0500
Date: Mon, 30 Jan 2012 16:25:29 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Wolfram Sang <w.sang@pengutronix.de>
Cc: linux-kernel@vger.kernel.org, Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [RFC 1/2] regmap: if format_write is used, declare all registers
 as "unreadable"
Message-ID: <20120130162529.GL4882@opensource.wolfsonmicro.com>
References: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="m0XfRaZG5aslkcJX"
Content-Disposition: inline
In-Reply-To: <1327932497-28319-1-git-send-email-w.sang@pengutronix.de>
X-Cookie: Condense soup, not books!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--m0XfRaZG5aslkcJX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jan 30, 2012 at 03:08:16PM +0100, Wolfram Sang wrote:
> Using .format_write means, we have a custom function to write to the
> chip, but not to read back. Also, mark registers as "not precious" and
> "not volatile" which is implicit because we cannot read them. Make those
> functions use 'regmap_readable' to reuse the checks done there.

Applied, thanks.

There are actually some chips that manage to implement read support in
conjunction with odd register formats but none of these are using regmap
right now and it's not altogether clear to me that it's a good idea for
them to do so as they tend to be doing entertaining things that would at
least need some framework additions.  Anyone doing that work can worry
about it then.

--m0XfRaZG5aslkcJX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPJsRyAAoJEBus8iNuMP3dxKAP/2ehwuEeQnS/UCNPgjDjtWUt
QQThyNMo1nO/oVl+iN66uAflsVuJ++F5JbG38nxe6X5IdSM18qsNeyjYCLvR1s5q
paAeVN22+1bgvqVot4QIojAVHTjkLT5WdMyo+goFvaP25zdY+rduBVv1LhpoXnaP
MclRdvZh+dZFHYHDPu0CysmYZfTuIkIugEZUd8yvOQDoxSh2k+SO6vRV4ZdYI3/g
q+Jyu3HFnNwutf0Dk39OdgBkzpg62w0y+3A0iJTlRxuzw7yGaDlCBvBe/0hKihyN
0ESZfYFvFECOQzxmzAlveADB7jNy58+YHD5cuHGDBPgsWRt+90ytTkAP9Q+TthoY
iyopYASVVcwVis/Bb1l7cZs0GWYnNwSC9VjF9bMRRNN4eYuxQxxctcOL7kFCQIWN
XqzauGpvEBc+hBzQAJ2f3re0txfSK+LnFSkl4IBfUOahVZoZucwhxVHs6EPTKTZS
fcwZBp4mBM8hd4H0wpHVla4gH7LUMjdAuHhfvWG5I1GppEwWYneNrJ2vwCkCtwVG
jRGZleftUia0nz+Q2MIElCQYKbiKhSP+atYIRY+KAzXafPz8Dj6+iQu5LEtZblpJ
YE507bLjKmOQ3t87pTJGR8c971JskYHPiPtwFFwmPYHBnmXrrLJTnfpX3dKIDBtb
zPh+Z4WNIsR9z6O9luCg
=2E+w
-----END PGP SIGNATURE-----

--m0XfRaZG5aslkcJX--
