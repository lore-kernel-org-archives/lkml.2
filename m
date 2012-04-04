Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752046Ab2DDUL3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 16:11:29 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:32929 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751686Ab2DDUL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 16:11:28 -0400
Date: Wed, 4 Apr 2012 21:11:17 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Eric Andersson <eric.andersson@unixphere.com>,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        alan@lxorguk.ukuu.org.uk, zhengguang.guo@bosch-sensortec.com,
        peter.moeller@cn.bosch.com, stefan.nilsson@unixphere.com,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCHv3 3/3] misc: add support for bmp18x chips to the bmp085
 driver
Message-ID: <20120404201116.GC10787@opensource.wolfsonmicro.com>
References: <1333568759-13536-1-git-send-email-eric.andersson@unixphere.com>
 <1333568759-13536-4-git-send-email-eric.andersson@unixphere.com>
 <20120404195532.GB10787@opensource.wolfsonmicro.com>
 <201204042000.34160.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="jy6Sn24JjFx/iggw"
Content-Disposition: inline
In-Reply-To: <201204042000.34160.arnd@arndb.de>
X-Cookie: You love peace.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--jy6Sn24JjFx/iggw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 04, 2012 at 08:00:33PM +0000, Arnd Bergmann wrote:
> On Wednesday 04 April 2012, Mark Brown wrote:
> > > +static const struct of_device_id bmp085_of_match[] = {
> > > +     { .compatible = "bosch-sensortec,bmp085", },

> > Traditionally the stock ticker symbol would be used.

> I though about commenting on that as well, but since Bosch is a foundation
> and not publically traded, that would be hard to accomplish. Is there
> an official fallback for companies that don't have a stock ticker symbol?

Guess we should ask the DT people...  I mostly just noticed that the
name appeared somewhat verbose - perhaps just plain "bosch" if there's
not a better abbrevation?

--jy6Sn24JjFx/iggw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPfKrKAAoJEBus8iNuMP3dfh8P/352KRCCD06PLoDQlYPchRvP
shR2rtgPVaC93pW1lHqcT6iX0QJxQRVDXkxBJcruNfMr+G25vpBb4DZpO4dljryd
U0/SSJOHY9YaHAQFfsA4IhqYY99vKY1ZL43eRSESh4VSeVT4MJe5zEd3NpJB9iYx
mPz6uFXwJ18Clsir10yTMi/wIYxjtPlsfeMmwzqJpG5TriLHb+m5dDZwtwO1hcyv
/CUJNt74gGsAQopr2+m+5/xB1pNYwRZoFE5UlJtw6jvJAeqdOrMGUDCHMJ3yvp7H
NEEXL6bpsE7RtUUh2F4ILIz8QtX76wcee++VIepxUDkes9mwwj9Zs3FTUUmjoE09
NiJwk6xM5tSg8/T78hkYt2ajNnulRAR3JtElHQxANl2pNE2voKY/EnxgNtkXlhfy
cnMjiEATe0b7zxHNA7bBAlM+vcUpjSo2J+3CoLPEcNdF6qxm/GbS2v7NakYXNIu9
UXpFkqLxjmyZEjjXEOeEhnAwO5ES0+ILHTwANGItkEVgAYFoi67qapbHowpWe98S
j81W++OLjcm1F9qEaROOEYBxuYTHIN8wIS6gDXkFyoKC78xhwPzAGhdSLoNDKE2L
2R/y5gVveoNxoFys3FWeMiHQJw93b8ECcaYHqDGl7S0ZbD85mTbmAaeuleTVC4Xd
tHvdYkPG6QQt0sTvI5dm
=nhVB
-----END PGP SIGNATURE-----

--jy6Sn24JjFx/iggw--
