Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031Ab2BBN2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:28:00 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40369 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753601Ab2BBN16 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:27:58 -0500
Date: Thu, 2 Feb 2012 13:27:50 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC 2/7] MFD: twl6040: Convert to i2c driver, and separate it
 from twl core
Message-ID: <20120202132750.GM7428@opensource.wolfsonmicro.com>
References: <1328185019-29575-1-git-send-email-peter.ujfalusi@ti.com>
 <1328185019-29575-3-git-send-email-peter.ujfalusi@ti.com>
 <20120202124828.GI7428@opensource.wolfsonmicro.com>
 <4F2A8912.4070701@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="LJm8egi4vkexsie5"
Content-Disposition: inline
In-Reply-To: <4F2A8912.4070701@ti.com>
X-Cookie: Never give an inch!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--LJm8egi4vkexsie5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 02, 2012 at 03:01:06PM +0200, Peter Ujfalusi wrote:
> On 02/02/2012 02:48 PM, Mark Brown wrote:

> > The calling convention here seems a bit weird too, you've got value then
> > register but normally we have register then value for I2C/SPI devices.

> I have based these part on the twl-core's implementation. I should not
> have done that, I know.. Let's see how it will look like with regmap.

Yeah, like I say...

> > Except when we don't :(

...it's not like we've been consistent so far.  I'm not that fussed
either way, I probably wouldn't have mentioned it if I hadn't otherwise
been commenting.

--LJm8egi4vkexsie5
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPKo9QAAoJEBus8iNuMP3d8C8P/2APfGHxR50k12kNTnlBiL8y
n+pO+dZXR1k06mxGl4VRK5LKvtx0CJQj1ZmyiXyjTgcQk8W+HIuVm3UMIN2/X4yO
mhunULuCrPxzfPyJIaFUejgS85xoQHhWylojfujdbCSlMzFaxBn2iVsu8J4R1t5m
n/vC/OI8RXB64Bys/XyCAPvJGrRAr5J+S4RuKqImYcbxHtT2NT81h2Y8DiowN0Op
VVKHOBc37QbHX6YUnDVPBwV4o35hTPh4jMBzGCbfj4Y0SDGfbM/8uIdmQ8IfD0ii
xPWMgCNZRnxBpFRPZD+r5O/IcwcbT4Dv49CyrDshEqNZLTX94AC+gj3xYn+2Ve7m
WC/AFT3qfDPGxiztAjjtb3qsnWAXyx3/l2yQrCaqL6b0SEmhJSSE4319kgSj2Ywm
7cgDWmuiqHJpNaDvOVEb6GoH4QiIdTGiRxAXxihaea4zB9AlDvF8bs5gI1f7z9Q7
2fl1k9e60J1/JAOiZiHyOzNqiNpBoYhS7MJXknvnzlDaKb2ooKRl8lF4pDH1apBm
LCvaXxNsx+1Iv4cwBHLD37wJp8AK4HFFEX3PSjaHyzpqThWY7/km1FRCKtuSKyK9
aNJW2treDVtRBTReVx7dSXeigULGSyX44OJ4Y2KOcm5g0Gyfwe7ThkldYdTfxfep
HcOl2tNLGICDuTVwQQ1P
=IGMO
-----END PGP SIGNATURE-----

--LJm8egi4vkexsie5--
