Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754824Ab3AJMwF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:52:05 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40475 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753765Ab3AJMwB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:52:01 -0500
Date: Thu, 10 Jan 2013 12:51:59 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, eric.y.miao@gmail.com,
        linux@arm.linux.org.uk, haojian.zhuang@gmail.com, chao.bi@intel.com,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: Re: [PATCH 05/11] spi/pxa2xx: make clock rate configurable from
 platform data
Message-ID: <20130110125159.GQ20956@opensource.wolfsonmicro.com>
References: <1357555480-24022-1-git-send-email-mika.westerberg@linux.intel.com>
 <20130110095803.GJ13897@intel.com>
 <20130110123837.GO13897@intel.com>
 <2921304.SsX3sQo2BU@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="63aIh6YiuHX+oBFP"
Content-Disposition: inline
In-Reply-To: <2921304.SsX3sQo2BU@vostro.rjw.lan>
X-Cookie: You will be awarded some great honor.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--63aIh6YiuHX+oBFP
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jan 10, 2013 at 01:54:41PM +0100, Rafael J. Wysocki wrote:
> On Thursday, January 10, 2013 02:38:37 PM Mika Westerberg wrote:

> > 	3. We make the acpi_create_platform_device() match on, lets say
> > 	   "INT33C" (a partial match), and in such case it assumes that we are
> >            running on Lynxpoint. It will then create platform device for 'clk-lpt'.

> > 	4. Now the clk-lpt driver creates the clocks.

> > 	5. The SPI driver gets the clock it wants.

> That sounds reasonable to me.  Mark, what do you think?

Sounds sensible, yes - about what I'd expect.  Is it possible to match
on CPUID or similar information (given that this is all in the SoC)
instead of ACPI, that might be more robust I guess?

--63aIh6YiuHX+oBFP
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ7rlnAAoJELSic+t+oim9iLsP/iLfIm5S6kuvG67Ft/xztPcG
HQXc6bMNqMejQ1kmHCJ9FFl/5VRl3qV7UMOV0SZYAmTerleChrF01otaULbFUfx0
QKq23lZpp74BPGBgeEejEvftQ/rGz0JE4uGtFomFsy1GiXuqcpqmqQU7ANH/O07b
n+6+N02TsxeyBMj/fY+7aAIlaAn2f+XtqlWWl5V3HcrSPpcmIMgH6KMOmv75Lo2m
cGrkzDnhKpjMhZ++JN1Ax+qVl3Vmum9BZGZ5mHDgr8GxqDhuLFzbg502GMR1OwPB
IXHwg85P9/394QFNgdeFThdSIWRw44LcmcP4kay1ALLqGoifx4D+Lq5lPYuVFSR5
0ZXaw8AE4OugtL6Xw6EGFRtlYDXbABrYNxQg5qKjB4L0RpR/gyDHd+uS1HRQ+sBe
1P7BJUGATy4fO4Kin4tH45KKTgxWG2P+AXgU0GDQW/v9U6E64AhsU6XGqEFJv9AR
eUD3gzl3hG1IxgZZk5jrP04dnbzgynMF7x8uib+38HpUSiOe/oIHr8DcrqIwc1p4
2reAov5jFgA1T/J8HzL6KCSrOdGSrzkiUmYojkM25oFkvmuwbu8oLuhaRkZgfGBX
6cVQBjc301PPg+R/ujw8ngsFenBiTNYxjprKrHk0w466bGZyBy+O1Taa6T5KC4aq
eoWt3cZChgafxPqdIcE+
=Sed1
-----END PGP SIGNATURE-----

--63aIh6YiuHX+oBFP--
