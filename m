Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754827Ab2KMKoQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 05:44:16 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:37108 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754783Ab2KMKoO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 05:44:14 -0500
Date: Tue, 13 Nov 2012 12:37:57 +0200
From: Felipe Balbi <balbi@ti.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
CC: <balbi@ti.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, Kishon Vijay Abraham I <kishon@ti.com>
Subject: Re: [PATCH] usb: otg: twl4030: Change TWL4030_MODULE_* ids to
 TWL_MODULE_*
Message-ID: <20121113103757.GE10951@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1352799818-22363-1-git-send-email-peter.ujfalusi@ti.com>
 <20121113094722.GB10395@arwen.pp.htv.fi>
 <50A220BF.7020901@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="u5E4XgoOPWr4PD9E"
Content-Disposition: inline
In-Reply-To: <50A220BF.7020901@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--u5E4XgoOPWr4PD9E
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, Nov 13, 2012 at 11:28:15AM +0100, Peter Ujfalusi wrote:
> Hi Felipe,
>=20
> On 11/13/2012 10:47 AM, Felipe Balbi wrote:
> > On Tue, Nov 13, 2012 at 10:43:38AM +0100, Peter Ujfalusi wrote:
> >> To facilitate upcoming cleanup in twl stack.
> >> No functional changes.
> >>
> >> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
> >=20
> > I guess this one must go together with the rest of your series...
>=20
> I made the split between the patches and they are good to go in their sep=
arate
> ways to avoid cross tree hassle.
> All of the defines were in place originally but they were used in non
> consistent ways.
> All of these will help in the future to clean up the twl core without bre=
aking
> the child drivers.

ok good. Unfortunately I have already sent this merge window's pull
request to Greg so I'd have to delay this until v3.9. If that's ok with
you, I can take it through my tree.

--=20
balbi

--u5E4XgoOPWr4PD9E
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQoiMFAAoJEIaOsuA1yqREk24P/0i0bC0b8W15F3mglrzk0cVo
DOaqwUIc92jz6FtMfpPTO2H9NhOCnkdZylaMJNakP9ONKZ7T7eWZ+h+gXO2Iamj9
SX29uYgux3eTYSYsXLiLDxvAbzvHnEzSMA6r7ZMaiukMBeZR+cUiijsYSBXQhYvL
Mux9Cde5UZP0x3MJNMfEryFiOKbrtNw3MSnSR/vNHfURUACc2ZoxZF6RklR24B30
ZZbK1tf8Cxlk7SZ07tb5NLPBujDz4iI7hX789nWNLWsDDfbMrBi9UX2ghVfS38D4
AocEH8wTwgexkazLh6qMvWiDU+uWXRkegdv6f7hO2rc0UZxB4cO9RI1BZsr6UN5E
/YXIF/SaDrGHdUlVy2cTqcgCbgnfWMRLZJsBMbwbOqtaaIqIiwBwzMPrmIPTXgAW
KGExxBmB5JaqHwEnVw4i27mbdIeVNl/XjmhQyqeP1fzV78QnpVaSzlybyTCY0jf2
1TCvKDGIyAJF08Tenke8SjthvfUxIOJ2/4p90ch53COoE0Wx1cp6Y+kUExQTNntM
o+SB3Mg289V/70mLRckLtdj0FHdLBgq6xZk5mrdLYB8cY5CkmhLQTSGc35oAKZtD
YoZSMyX+bHvPPp5B00XfXlrLxNniHMzXG31h8RS5b35ytdOuveKNtyVNpb4uhoYn
g7/LOTKNoLCQA5KL2DhF
=OzIR
-----END PGP SIGNATURE-----

--u5E4XgoOPWr4PD9E--
