Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755020Ab2DWMXj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:23:39 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50318 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754172Ab2DWMXh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:23:37 -0400
Date: Mon, 23 Apr 2012 13:23:35 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: max8997: Remove is_enabled callback
 implementation for max8997_charger_fixedstate_ops
Message-ID: <20120423122335.GJ8318@opensource.wolfsonmicro.com>
References: <1334677707.14393.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZG+WKzXzVby2T9Ro"
Content-Disposition: inline
In-Reply-To: <1334677707.14393.2.camel@phoenix>
X-Cookie: You have no real enemies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZG+WKzXzVby2T9Ro
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Apr 17, 2012 at 11:48:27PM +0800, Axel Lin wrote:
> If is_enabled callback is not implemented, the core assumes that the regulator
> is on.

Applied, thanks.

--ZG+WKzXzVby2T9Ro
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlUm1AAoJEBus8iNuMP3dGS0P/R1Qp3bB+57FHkCSOjtVb0uk
xtL0C4ROzt5FhhdEmfg0hz67119iOSDoXB8kFmDsGiOmy2i+kWutVSiN49Iw01sj
Riu31qD2Gh5bL6Skr7Y4sNlqhjsOiSJbe/+/u8gOOnKSG9id8FKjlYIFySNiG+Kk
tMmkFwpyI8/70htBAWwaJpOKwaDKU+uVkANSt7yjNKHlsckw1O4VtnxwdqyfZMfe
dp3eHZ/AExhVT3cv2qQJGok+jd5u7azaDYU3v1+SjQ5g9DUVtXTrd9OC9m8YBCLD
X8XJMSQmGDK9SlaCYuxlbhBPSkWBzN96HGQGNaQ0e1xPoN2OwD01PgbCKDsBioVX
HlOn51El/EIT+O52ov+rEhmobHW+jisqz9oXjlvt/BvFX+yB/hoXyQyd2ejTz2I6
ZzUkkx1drLLNnK3aPpfNhkugkdjNIrPZWTKnJLCfPJEVUZGIm3JyyAB1MpWM/sTz
ot94y/Yuv0mcrvIo/31nV1tjaH3+9lt+8B/n2vZpyhDhaL26EHeKtWmXClgTGcR+
TbHjPh1nUkImybvEEIL4NahXaO5bYF6UIgclaYLZ6Vo6frX2W9wqI7nYRsdOfY34
fda5dFLRcJksq6OeMI9+FUpBQ8DmjDgi9zFHyjdMuQw71twRzh9XKxxUAE4ikUsw
kFRkIyNa2rOXD7d0piLj
=yMOr
-----END PGP SIGNATURE-----

--ZG+WKzXzVby2T9Ro--
