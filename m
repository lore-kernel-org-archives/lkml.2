Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754726Ab0CYORV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 10:17:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:51766 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753815Ab0CYORT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 10:17:19 -0400
Date: Thu, 25 Mar 2010 15:17:12 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Henrik Kretzschmar <henne@nachtwindheim.de>
Cc: isdn@linux-pingi.de, davem@davemloft.net, linux@dominikbrodowski.net,
       akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] isdn: Cleanup Sections in PCMCIA driver sedlbauer
Message-ID: <20100325141712.GF5069@pengutronix.de>
References: <1269518732-4515-1-git-send-email-henne@nachtwindheim.de> <20100325121610.GB5069@pengutronix.de> <4BAB6DC1.4020507@nachtwindheim.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yRA+Bmk8aPhU85Qt"
Content-Disposition: inline
In-Reply-To: <4BAB6DC1.4020507@nachtwindheim.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yRA+Bmk8aPhU85Qt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


>  Imho should these functions be reorderd, so that no prototypes are requi=
red
>  in a driver file. If somebody wishes, I would do that for those.

I stand corrected, missed that for prototypes. Sorry for the noise.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--yRA+Bmk8aPhU85Qt
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkurcGgACgkQD27XaX1/VRvLrgCfVj9nXpuqhz2BhDHuksrvHP2m
0rwAn0YXpJ+94RnmqgKfLr7rggZWaJsz
=oa2x
-----END PGP SIGNATURE-----

--yRA+Bmk8aPhU85Qt--
