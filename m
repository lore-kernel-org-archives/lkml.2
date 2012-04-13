Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757600Ab2DMIQW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:16:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45598 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757414Ab2DMIQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:16:11 -0400
Date: Fri, 13 Apr 2012 09:16:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/3] regulator: ab3100: Add dummy
 set_suspend_[enable|disable] callbacks implementation
Message-ID: <20120413081607.GA3168@opensource.wolfsonmicro.com>
References: <1334292098.6122.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="17pEHd4RhPHOinZp"
Content-Disposition: inline
In-Reply-To: <1334292098.6122.1.camel@phoenix>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--17pEHd4RhPHOinZp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 13, 2012 at 12:41:38PM +0800, Axel Lin wrote:
> Without the implementation of set_suspend_enable and set_suspend_disable =
callbacks,
> the regulator core won't call set_suspend_voltage.
>=20
> Thus add dummy implementation for set_suspend_[enable|disable] callbacks.

No, if we need to go adding dummy functions to a bunch of drivers we're
clearly going about things the wrong way and should be avoiding the need
to have those functions in the first place.

--17pEHd4RhPHOinZp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPh+BuAAoJEBus8iNuMP3du2IP/2j9QbYOiuxgu7id3YafrTGS
TVMrd0I2AXT/4wz0r9qfRzs7Vgqa2uWwTczbdsJaOgc8kmyuzJaUiApSR+Jsn4zS
CbcCkelRzF7yYN1MLvagLj9GOGK97xxg4xdxTXizSEhk+riOuRf/RuHglv89p7HU
UiLzxb3RJjLlTwJZvqyH4wvQhc9x3rEMnszax99Pi4maPUcOE9ywPqloyEeErk9s
OexQk5l7+vmLbP2CtaXDk5kCFk1A16i0Y1tlg2+9C4YRf1uQWW48UfQ9NT8/zjBm
4L9gremER9qdpUTVw0huyNLwBjhQYFXd9p6ZTRvK0hrhXVWJrKog1rQ+kHlWDhVY
l26FIFIwjxYQp5mzM53WFsCyJTzrpUDJgDc0CfaWUXUfsKVPuoUk062ExbU3u+Le
Pb9ZwPxq5fzhNRUTjCfSsdTebgtnOrOVqZrWDyxn+BIc0v00CbxkicRMXdsgxLDN
+idwt/WD0iV3gOqlVdTsyeij3AnCtdxhKpKKdxSINQfRFIA7ci9hyLEmA1OXKEIN
bVSSsCtrDJIUJs8/hm+Vn9LIdXjZ5oL37cTb9RDXIhQwhCbK05FvG+tzMCl9GbDt
WdGz5yKKUWpyBi+V2seSCWy3VFpOu0e5+PlKjpFnGeB0y1LjlO62d969D9Z7kff8
iVceFriSgSE9kHBOuTBS
=hLPa
-----END PGP SIGNATURE-----

--17pEHd4RhPHOinZp--
