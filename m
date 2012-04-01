Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752481Ab2DAO30 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 10:29:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50240 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752151Ab2DAO3X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 10:29:23 -0400
Date: Sun, 1 Apr 2012 15:29:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Mike Turquette <mturquette@ti.com>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] clk: Fix comment for end of CONFIG_COMMON_CLK section
Message-ID: <20120401142918.GA8971@opensource.wolfsonmicro.com>
References: <1333279960-8497-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20120401130216.GA24211@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="dDRMvlgZJXvWKvBx"
Content-Disposition: inline
In-Reply-To: <20120401130216.GA24211@n2100.arm.linux.org.uk>
X-Cookie: You will have a long and boring life.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--dDRMvlgZJXvWKvBx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Apr 01, 2012 at 02:02:16PM +0100, Russell King - ARM Linux wrote:
> On Sun, Apr 01, 2012 at 12:32:39PM +0100, Mark Brown wrote:
> > There is no else block so the #endif is for the end of the section for
> > CONFIG_COMMON_CLK.

> Get rid of the comment entirely.  For just a single level of ifdef it
> makes no sense.

That's actually my preference too, I was mostly just sticking with the
existing style.  I'll send out a version doing that shortly.

--dDRMvlgZJXvWKvBx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeGYWAAoJEBus8iNuMP3db+oP/3/gkx+4Utg5TQYVPMxq5hcI
wbAvxlyHEjUGD6Bujgp3f4D8iaBE7QgOjtWXbBURet3mgLNjiPeUtcw+Cxs6XYGt
aJAZQHne/roE2ccc3L7DxbGV8t2f11zO+4ShL6sIvoR1kXo1Upay63mmDz3syI1X
Xp0LAY7xPKeQu7K6qHOKVyRGYodi4kw9T7l10Z8TKwkrtAdohyiDi7SVMBGhGZd4
F7V+9Ls5pZ3CbuKo5xRdFq09h1fN/iXykcK6ZWFADRPXmAb/koFOpnZBoLntJqZj
9IV8ieCnxg1FU8iNhkp37l+cDO9x05WuCBKkVh7WS+KKyZjh/Z/HvB+8XtOREL+A
ujGPPn+c38mgnkDn/NH3Tty1IZ3sFiATHuT/EYRJNfhxsnBes18Xa9TIFp/F8/4V
94Ej9DHxo8fs/u4BzU2Hl1lasGBnWezXiIL0rT3zNarN9+xfemP1sPF3WuD04Flt
kAPWAhWmWwLPJrg59VO30XFew+4/e1jYaIhhGyqxYzHIItwZWOCxCb3lQByjEPZw
eDbQvMe40FhIxwUXGkYZrRqLQC/5ar82UYXEPINo1+7Ixgz7fdwd8Sc6Bg2uXzJG
hyp42R34ojOLKG4ht+xBuHqdHlYcYbgj7hqKLa7Y2MbrtWaE1jhKJJ7sBYmX0+Mz
qP0uOVPLV2EylFwbync2
=UPst
-----END PGP SIGNATURE-----

--dDRMvlgZJXvWKvBx--
