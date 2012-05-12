Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754038Ab2ELKON (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 06:14:13 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46704 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752480Ab2ELKOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 06:14:12 -0400
Date: Sat, 12 May 2012 11:14:07 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Mike Rapoport <mike@compulab.co.il>, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 1/2] regulator: da903x: Fix list voltage for da9030
 ldo14
Message-ID: <20120512101407.GC1781@opensource.wolfsonmicro.com>
References: <1336477570.13339.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Fig2xvG2VGoz8o/s"
Content-Disposition: inline
In-Reply-To: <1336477570.13339.4.camel@phoenix>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Fig2xvG2VGoz8o/s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 07:46:10PM +0800, Axel Lin wrote:
> da903x_list_voltage does not return correct voltage for da9030 ldo14.
> Implement da9030_list_ldo14_voltage to return correct voltage for da9030 ldo14.

Applied both, thanks.

--Fig2xvG2VGoz8o/s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPrjeoAAoJEBus8iNuMP3dEy4P/Am+jfwfIcKr64HJFFCMcrBQ
36rAfidaqUpfawkUgprzCribXGOor3zTR57IPR/LepVsP6tjgLqsObJWllxCtSiV
kwRBAvw5MLc9Lw/YszTOoxjo7xRqE6VI1OUo1Qjuj6DIKw2pDevuJg4bYsKS8+NZ
LHD3W44H/kJdJGqMIiCY/y7a1qzU/Qt9nPYmvOFSzsB7nxEsmHkqvo1ImnZXKDba
BsL3L8FuD6JFNyEDZyomlzHVw/ruvXm17x3yvDNGp0yjaBr0zvNda3T2hRSUHNJw
gbUSXviFo2JD7qcRGDIX5PP+4NpTsq5tMstQhX6kuVIZEZQSGmS5fVdANP+dXtxq
nrDAYMEo/jHkB42RKAoui1H8aN3Juy71Dz5qgdEzX/T9fQ/fuiqzZAT90r8vneGS
JzBENQrS97L4SV5Q7VlsLY2uuqJ7e4MNiamHDrwLU7S2rZDqfbsA8/LHK3ofZOg/
bnz8vXmHszFXgwej0ahQouGUf/+taoE+6/w2QmcoJ8ium6dBbKbaq9MEcSnlI/EY
MdMF/N7cLKRcMq4fAoMeyZgDaKLArO8gEfYiefmdB8mBixYpMro/Nu2j4N5txOVX
O+h2R3QcU4WjbZy4ad3PHRwKU6RtdgctWBRJlNN8TnP5L/5dBckdvw9P46kCsbws
8rPXXJHkEa3/Ko5upFIf
=bbj2
-----END PGP SIGNATURE-----

--Fig2xvG2VGoz8o/s--
