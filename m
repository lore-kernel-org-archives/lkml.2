Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932740Ab2DMI4K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:56:10 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:43116 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753327Ab2DMI4G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:56:06 -0400
Date: Fri, 13 Apr 2012 09:56:04 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Rajendra Nayak <rnayak@ti.com>, Tero Kristo <t-kristo@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: twl-regulator: Implement enable_time
 callback
Message-ID: <20120413085603.GD3168@opensource.wolfsonmicro.com>
References: <1334113557.7919.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ieNMXl1Fr3cevapt"
Content-Disposition: inline
In-Reply-To: <1334113557.7919.2.camel@phoenix>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ieNMXl1Fr3cevapt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 11, 2012 at 11:05:57AM +0800, Axel Lin wrote:
> Let regulator core do the necessary delay for us.

Applied both, thanks.

--ieNMXl1Fr3cevapt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPh+oRAAoJEBus8iNuMP3d0w0P+wdVwPZcuyB+kgl9fEHuw6lj
t6jJZuBt8zuVhHQrnB5c1HYchbHN6eAMTOzzpgqamSQKmTkp+dabf7cc4uJ2n1vE
6pEDcNZdC7CPVBjOi9puuRCzwGd9DdPl1dXxkvuktN8c0EZq+H5FM3pzP1QgJvl+
WYgSt6QjPbZf7FxiwUp8x2ACrH/d5fru/b0F/Vu30KRiIL1q8JI3hkmafcCefZXY
IxwQUBGBoKhh2Uon+mRy4tr74WC44XWWHm/do9K9yBykDJFz0domcx5xajP0Oqhc
w9bm/S4heSJeKAaIA+14PqtrhqW72wt8XF8O0xDOoFk9eGahCu8qszCiMCRH74OQ
z9nE8hr+nX0ctIGsB3NRoXrKn0o9vBb2lt1qcO35jxZv56fBBhkXgOr1EBdtqtnD
tZKF5UQj0hsYfb/I18KWLDAgRxhHrnCIXCo6tCyNi3sV6gLLnEnInr9pWaCL2p1g
1bnTjaiNMgJDIf2iFCSuDcITzg/SmxJxoVmulCwvxWd2ANrVsjgOxXBXK/IY5M6q
wa0IwBN3f7/08tXYIsnocWmIuQvETy/FtB44kNoxn+Vm2G1ITmJvCzfwCAN3FvBf
C5MwMJWQ6yFFjvO91p7B4c4V+xstna7yx9kWlCDt1+8hORN/5wYd0GmBerMKQpno
bLkRWVu3sVm8YtQHxt46
=XWKe
-----END PGP SIGNATURE-----

--ieNMXl1Fr3cevapt--
