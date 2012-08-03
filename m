Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753979Ab2HCNiE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 09:38:04 -0400
Received: from na3sys009aog108.obsmtp.com ([74.125.149.199]:44501 "EHLO
	na3sys009aog108.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753767Ab2HCNiA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 09:38:00 -0400
Date: Fri, 3 Aug 2012 16:34:32 +0300
From: Felipe Balbi <balbi@ti.com>
To: Kishon Vijay Abraham I <kishon@ti.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com, rob@landley.net,
        linux@arm.linux.org.uk, gregkh@linuxfoundation.org, b-cousson@ti.com,
        rnayak@ti.com, tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, balbi@ti.com,
        linux-omap@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v6 09/11] drivers: usb: musb: Add device tree support for
 omap musb glue
Message-ID: <20120803133431.GK8269@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1343639400-28725-1-git-send-email-kishon@ti.com>
 <1343639400-28725-10-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bX/mw5riLlTkt+Gv"
Content-Disposition: inline
In-Reply-To: <1343639400-28725-10-git-send-email-kishon@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bX/mw5riLlTkt+Gv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jul 30, 2012 at 02:39:58PM +0530, Kishon Vijay Abraham I wrote:
> Added device tree support for omap musb driver and updated the
> Documentation with device tree binding information.
>=20
> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>

This looks good and I think I can take this without any dependencies
again. Correct ?

--=20
balbi

--bX/mw5riLlTkt+Gv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQG9NnAAoJEIaOsuA1yqREZBsP/js9p/cI/Hbjf+ikzVwMf4rJ
ZjXmUQxX+IxSZF3cT0z6Fl9CHXPvfDXoHYcuUq73DcUKAMxUrlpalMGGvbPwhmHb
7+46RqEfRFxD66pb20qEew+hV7cF+Q0j4kZPQs+jWwaGJojhWOAqAdkHGIcVIr6s
Vn9P3Rj92ItIUQW9xZcnoIsiGL+0SaoBhE/LFHujJM9TU4hFkWQAn+twAuJMTL8Q
GAEHeLXjEa5OIuHC8yuE8zDeP1ztBoo9UpLyczMdSiqc4HNmDkTHcaC+cePSR3nu
EkbeIsTzn2mQQwMeL0kj7RizHMlktoWKryGbrh3UeELi3mvJapPTCeQkvldnd54r
/JYiNx85p/QGGj9HOua2BQWdHxmbI2noGr4KhKWnwKwBt8ItYqHCOJqquvESvVgW
tax6OfsLTuKD/dnYM+vHe3Q3EUGFMFADZVGuXfPpQi7jUWCRNWkNBBWhhDpPNDQ9
W9HSmYhE72apEVwwLtYifVmL/RGUHHAzHHJRaX3R9MAH7qqmQdT3/WZz4UpMH1xU
oubMI18FhAMrEp6x/5X0iTXKfotLr08HPB1r0ahTDkLSoNNh1JLJQO2I7uzMNkYI
YHrQfIG0inHMX1pwD42ncz9XBEcyoj88SmYwCiBDsrKZV2S7cg6vhji7euJIHn/u
L8y6uN1wFnqLWom/Ynx2
=gadd
-----END PGP SIGNATURE-----

--bX/mw5riLlTkt+Gv--
