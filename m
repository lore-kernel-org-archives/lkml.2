Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753848Ab2DYIGq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 04:06:46 -0400
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:44639 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751805Ab2DYIGn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 04:06:43 -0400
Date: Wed, 25 Apr 2012 11:05:27 +0300
From: Felipe Balbi <balbi@ti.com>
To: NeilBrown <neilb@suse.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH 6/6] twl4030-usb: Don't report EVENT_ID when there is
 VBUS.
Message-ID: <20120425080526.GA3777@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <20120425072931.20124.56635.stgit@notabene.brown>
 <20120425073311.20124.58619.stgit@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IS0zKkzwUGydFO0o"
Content-Disposition: inline
In-Reply-To: <20120425073311.20124.58619.stgit@notabene.brown>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IS0zKkzwUGydFO0o
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Wed, Apr 25, 2012 at 05:33:11PM +1000, NeilBrown wrote:
> Some USB chargers tie the ID pin low via various resistors.
> So they can cause VBUS to be high and ID to be low.
>=20
> The 'A' end of an OTG cable never receives VBUS, it only ever generates i=
t.

this isn't entirely true. Have you considered Accessory Charger
Adapters ?

> So if we see VBUS and are not generating it, this must be a charger,
> not the A end of an OTG cable, so in that case, ignore the fact that
> ID is low.

wrong.

--=20
balbi

--IS0zKkzwUGydFO0o
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPl7BGAAoJEIaOsuA1yqREJ+8P/RoFYs7SyVGi6Ha03PnzpO/N
rkRpOGl8puCfcMznBYH2ELRF6V51yCUN8wXruY3tR0uJi7ObYAVu45pUhHJ0kJuV
SZygjsEjFAJHu+ZPLSX9sZgBEQYdQgHCaVXg+8RpPpZ32bYu2UC82DJ4vDm1VdXq
hs2nCwaYb7YsxDzqe+5TM7bvWen7gmvrgR/ljgol0qI+GJsB53w4tySZydithbj/
5hBsZ0ru/nXPhQDxYOKXrT6FwNdajyB29b2vL7Ywk+m4dho+lnigAwBcoEgQL/Eo
JaXRZHzctNBznZ/y0Jlm/fL6LV+vOBcg2zOKLg6a25R4bwhH3XCb5fMwBwto8R5+
ZN/UVvWaTWAlVAhtv8dSd3Kjchx6wlwpBBQQfsCXtJPF53RKossFb/zpg56ZR63Z
vRF8vEM6Zo7j1U4gWE3KjDClJY8tkN4C48w+rhMiT/TQLoutV17P/tjMzIBjcouH
kIYGsGgdlQZVId5fIh3CqAzP2R82ZAWYwwIsnEkEpU64g4g93knYvV1gj4E4U3dj
BxnwUtCCz2ifkkNDmi+4SMh1WkbIxLRo/bgvYQWxnMM/GY+b8GvApME8qP9BVGNe
MOdwrzYQxfABRjhR4BbszNJX57SHCOLmAYEVJMCxkmgHfd6tAx0aS21ot02mWPbR
mL+lnQGWCI2Yzp+ow1eT
=/Eaz
-----END PGP SIGNATURE-----

--IS0zKkzwUGydFO0o--
