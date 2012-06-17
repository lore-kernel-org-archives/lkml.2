Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757816Ab2FQSxJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 14:53:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52222 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757586Ab2FQSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 14:53:08 -0400
Date: Sun, 17 Jun 2012 19:53:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, sbkim01@gmail.com
Subject: Re: [PATCH 5/5] regulator: Support AP watchdog reset operation for
 s5m8767a
Message-ID: <20120617185305.GD4267@opensource.wolfsonmicro.com>
References: <042301cd493e$8d95d7e0$a8c187a0$@com>
 <20120613174620.GD7804@opensource.wolfsonmicro.com>
 <04ad01cd49c0$df565d20$9e031760$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="9dgjiU4MmWPVapMU"
Content-Disposition: inline
In-Reply-To: <04ad01cd49c0$df565d20$9e031760$@com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--9dgjiU4MmWPVapMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 14, 2012 at 09:01:39AM +0900, Sangbeom Kim wrote:

> Solution
> - Basic concept: After ap watchdog reset, GPIO configuration is changed by default value
> - S5M8767A has function of voltage control with gpio (8 levels with 3 gpios)
> - Set bootable voltage on level 0 -> can work with default gpio configuration
> - In the probing, Change voltage control level from level 0 to level 1
> - Execute normal dvfs operation on level 1
> - After watchdog reset, ap gpio is set by default value
> - PMIC operation mode is changed by ap reset (level1 -> level0)
> - AP can execute normal boot

OK, so basically what you're doing is fixing one of the GPIO selected
voltage levels so that when the AP comes out of reset it'll drive the
PMIC into a suitable level for it to boot?  That makes sense - can you
please resend with this in the changelog.

--9dgjiU4MmWPVapMU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3ibTAAoJEBus8iNuMP3d99wP/022Yl0qRSdxouqj2LEBHOhC
4TzgVm6OPGQn3qW1r6GqPOZ4q6UTJeVgj6+PS6oMkyWvnrJFnk3Izqkfo+OVtNBm
OoTU16VBoieIj301Nvj3N68ILy7TX6L71j6kbumBJe3oXIZUsgdiNWpUXcQ2kWuy
hHiU+KA9lfkCNn7bGzNLtS+YXaNOP3ROWhTXOAb45L+SulO6lXn/V1U+qNbY00nJ
/Yl8DMLsZQQU1FwnvKDFXcSrBykheoF9qu2K/xuA5iems4UBaFrSvKBER/tXbI20
d5R9F9pY1vuEyfwSukjjeYm39zzeoubigBoNgwGLAAkF0U1mzXXxXKOjDgPIcDRx
1Z+2jhaV2lCQ7qB2J88xbUvXv4pabR3EPoHm9nj8sZXmYw16qCYc33vNj+NklOYe
iir2qbo3JNgr8TFGvPqQlF5v6W3o7xs0hch9NkMrGOd6t8GRnLGRvEpWRZI0Kn+q
i4m1009rrv0UtPAX1n2+kr2x/UYgRMVD6SKagas740A+uVoh3P9RbJDdmMFSvvPG
7o3KvtLsdn+SlnhAm+jHGGjyhh0QfF2/q01o9W2mTJe6q/tSTSclg/G8ghfpkQUf
fynzb1rUre7FcGs5ONoPkA/DGLveuoP/0Jk9HAE7GRjBIbYOxK5+eMsyxsNlWwET
O8g8eBkjG3oEmKrwzJoY
=YKFJ
-----END PGP SIGNATURE-----

--9dgjiU4MmWPVapMU--
