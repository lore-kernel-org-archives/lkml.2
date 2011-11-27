Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751698Ab1K0I6g (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Nov 2011 03:58:36 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:45129 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750743Ab1K0I6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Nov 2011 03:58:34 -0500
Date: Sun, 27 Nov 2011 09:58:13 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Anton Vorontsov <cbouatmailru@gmail.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Micha <mirq-linux@rere.qmqm.pl>, David Brown <davidb@codeaurora.org>,
        Ben Dooks <ben-linux@fluff.org>, Viresh Kumar <viresh.kumar@st.com>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Ian Molton <ian@mnementh.co.uk>, Sascha Hauer <s.hauer@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>, Chris Ball <cjb@laptop.org>,
        linux-mmc@vger.kernel.org
Subject: Re: [PATCH] mmc: convert drivers/mmc/host/* to use
 module_platform_driver()
Message-ID: <20111127085813.GC5263@pengutronix.de>
References: <1322283343.14278.2.camel@phoenix>
 <20111126121953.GA11865@oksana.dev.rtsoft.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Izn7cH1Com+I3R9J"
Content-Disposition: inline
In-Reply-To: <20111126121953.GA11865@oksana.dev.rtsoft.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Izn7cH1Com+I3R9J
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Nov 26, 2011 at 04:19:53PM +0400, Anton Vorontsov wrote:
> On Sat, Nov 26, 2011 at 12:55:43PM +0800, Axel Lin wrote:
> > This patch converts the drivers in drivers/mmc/host/* to use the
> > module_platform_driver() macro which makes the code smaller and a bit
> > simpler.

Lost the original mail, but checked the patch using an archive.

Acked-by: Wolfram Sang <w.sang@pengutronix.de>

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--Izn7cH1Com+I3R9J
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7R+6UACgkQD27XaX1/VRvv5QCgnAx2idQPQgU7MLIf+lQIvX1a
Y6oAoKyNMYfZIduxWkKAxZa5e7+IeipD
=LL3t
-----END PGP SIGNATURE-----

--Izn7cH1Com+I3R9J--
