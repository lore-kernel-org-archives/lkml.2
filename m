Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755767Ab2BGN33 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 08:29:29 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38528 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754724Ab2BGN32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 08:29:28 -0500
Date: Tue, 7 Feb 2012 13:29:25 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Tony Lindgren <tony@atomide.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Liam Girdwood <lrg@ti.com>, Dmitry Torokhov <dtor@mail.ru>,
        Misael Lopez Cruz <misael.lopez@ti.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, alsa-devel@alsa-project.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 2/7] MFD: twl6040: Convert to i2c driver, and separate
 it from twl core
Message-ID: <20120207132925.GN3332@opensource.wolfsonmicro.com>
References: <1328619678-26080-1-git-send-email-peter.ujfalusi@ti.com>
 <1328619678-26080-3-git-send-email-peter.ujfalusi@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="c2gYorpyS4gG0T74"
Content-Disposition: inline
In-Reply-To: <1328619678-26080-3-git-send-email-peter.ujfalusi@ti.com>
X-Cookie: You will forget that you ever knew me.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--c2gYorpyS4gG0T74
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Feb 07, 2012 at 03:01:13PM +0200, Peter Ujfalusi wrote:
> Complete the separation of the twl6040 from the twl core since
> it is a separate chip, not part of the twl6030 PMIC.

Looking good

Reviewed-by: Mark Brown <broonie@opensource.wolfsonicro.com>

and it looks like you'll save a bunch more code if you're able to
convert over to using a regmap cache.  Note that as a first pass you
just need to define which registers are volatile and enable a cache type
- if defaults are omitted then the values will be read back from the
device to start off with.

--c2gYorpyS4gG0T74
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPMSZ+AAoJEBus8iNuMP3df30QAIN5S2+p8EyQfwYgHzuz4N/x
q0c3AOU/aUpOheyLjEUkVOjzJjNiQHY0GXvmHrXnn/whULW16+n5BFq9/DlHPcff
rlWE7K1jrl93Lv/dM5IZS4jsDx0iCKN88tw9PN0one/klDUWJPzB7CBEioQQlEq7
UHKwZtzPk2oHNTAknnsUPMK1hkl9J2fBHDrC+meC1gXyjgdxJy1i03OVbkOntz3P
eBku+7Hf7Wl3r+txV9aRKLIvx891GB+AtVeZboPtjLgQZ9o9FeSEuQSmImGOgLBG
3mvgOa14rRVV6wRf2j+H604r2tTNZ2FZZ7OZOK4esOnU8O1bBsirT9Sz3JpY8t99
gT3BCyzvsrH8IehF5tCA5cWAMT1uLymWN5kMPiBwh4MN+R5MU6DlNbT69KmawM+D
//gYlHal1sYzyINYTmeoSwlZRCGqNizyO4fL1mxMP0aPpKpIorDvnKFaX8A2cNHT
4HkkZV/Qt0Uy78+c+OOAlJ+MsIh+mQ7PfzAnVuJlG2wehecJ0D3OysbCVBd+d2Gt
pu6pzljwKzi+M00BcZPGC5ulrhs0boXczd+av2AOcSQU//rQ/3qSHc8d5LddAMNe
hP1PMe5GHmnD+qhnbFMWlLAX5jQzmHGw0ITsUKPowQ9FNj4aRH/Tw4OStWDg6eiH
fc2xy34kKKS0j3yL9W5z
=1teB
-----END PGP SIGNATURE-----

--c2gYorpyS4gG0T74--
