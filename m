Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755883Ab1GFTau (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 15:30:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:34556 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751996Ab1GFTat (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 15:30:49 -0400
Date: Wed, 6 Jul 2011 21:30:48 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: Arnd Bergmann <arnd@arndb.de>, LKML <linux-kernel@vger.kernel.org>,
        Linux Watchdog Mailing List <linux-watchdog@vger.kernel.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH 1/10 v2] Generic Watchdog Timer Driver
Message-ID: <20110706193048.GB24576@pengutronix.de>
References: <20110618171946.GB3441@infomag.iguana.be>
 <201106182058.14702.arnd@arndb.de>
 <20110706191710.GO29245@infomag.iguana.be>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="cmJC7u66zC7hs+87"
Content-Disposition: inline
In-Reply-To: <20110706191710.GO29245@infomag.iguana.be>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--cmJC7u66zC7hs+87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 06, 2011 at 09:17:10PM +0200, Wim Van Sebroeck wrote:
> Hi Arnd,
>=20
> > > +EXPORT_SYMBOL(watchdog_register_device);
> >=20
> > How about making this EXPORT_SYMBOL_GPL?
>=20
> My opinion: the new framework has been created for 2 reasons:
> 1) consolidation of the code that is being repeated in each driver
> 2) to make it possible to support more then one driver.
> If we want to support more then one driver, then the out-of-tree drivers
> would benefit from using the API. Even the non-GPL ones.

I strongly support Arnd. And if it helps getting out-of-tree drivers into t=
he
tree, great! I'd think most watchdog-drivers are out-of-tree because of
laziness, not because of IP?

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--cmJC7u66zC7hs+87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk4Ut+cACgkQD27XaX1/VRvXMQCeIkjbQebLmLfATvToYIo6gyjp
0lkAoISlARPYwPSEzrT++lnUDiEowI6Z
=k96S
-----END PGP SIGNATURE-----

--cmJC7u66zC7hs+87--
