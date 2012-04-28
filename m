Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab2D1GDi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 02:03:38 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50251 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750895Ab2D1GDd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 02:03:33 -0400
Date: Sat, 28 Apr 2012 08:03:22 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Jonathan Nieder <jrnieder@gmail.com>
Cc: Eric =?iso-8859-15?Q?B=E9nard?= <eric@eukrea.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Greg KH <gregkh@linuxfoundation.org>,
        Chris Ball <cjb@laptop.org>
Subject: Re: [ 14/62] mmc: unbreak sdhci-esdhc-imx on i.MX25
Message-ID: <20120428060322.GA1474@pengutronix.de>
References: <20120424223305.GA7748@kroah.com>
 <20120424223243.200037983@linuxfoundation.org>
 <20120427223118.GE2821@burratino>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qxx1br4bt0+wmkIi"
Content-Disposition: inline
In-Reply-To: <20120427223118.GE2821@burratino>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qxx1br4bt0+wmkIi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 27, 2012 at 05:31:18PM -0500, Jonathan Nieder wrote:
> Hi,
>=20
> Greg KH wrote:
>=20
> > 3.3-stable review patch.
> [...]
> > commit b89152824f993a9572b47eb31f4579feadeac34c upstream.
> >
> > This was broken by me in 37865fe91582582a6f6c00652f6a2b1ff71f8a78
> > ("mmc: sdhci-esdhc-imx: fix timeout on i.MX's sdhci") where more
> > extensive tests would have shown that read or write of data to the
> > card were failing (even if the partition table was correctly read).
>=20
> 37865fe91582 is v2.6.37-rc4~24^2~7 so it sounds like this patch
> should also be applied to 3.0.y.
>=20
> Here's a straightforward backport to account for the lack of
> v3.1-rc1~321^2~77 ("mmc: sdhci: make sdhci-pltfm device drivers self
> registered") and v3.1-rc1~125^2^2~5 ("mmc: sdhci-esdhc-imx: get rid of
> the uses of cpu_is_mx").  Sensible?

Yes, thanks.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Qxx1br4bt0+wmkIi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+biCoACgkQD27XaX1/VRsb5QCeMHqELCp2magy0xm5cIAGWq3Z
t1kAn0f2MCFQNIFCm1tpv1bUBRRBC58o
=SIRP
-----END PGP SIGNATURE-----

--Qxx1br4bt0+wmkIi--
