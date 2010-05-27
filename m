Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758572Ab0E0K3r (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 May 2010 06:29:47 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:44714 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757821Ab0E0K3p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 May 2010 06:29:45 -0400
Date: Thu, 27 May 2010 12:29:17 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Claudio Scordino <claudio@evidence.eu.com>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>, hskinnemoen@atmel.com,
       linux@maxim.org.za,
       linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
       Rick Bronson <rick@efn.org>, John Nicholls <john@thinlinx.com>,
       Linux Kernel <linux-kernel@vger.kernel.org>,
       Sebastian Heutling <Sebastian.Heutling@who-ing.de>,
       Ryan Mallon <ryan@bluewatersys.com>,
       michael trimarchi <michael@evidence.eu.com>, rmk@arm.linux.org.uk
Subject: Re: [PATCH] atmel_serial: Atmel RS485 support v2
Message-ID: <20100527102917.GB31253@pengutronix.de>
References: <4BB053C4.7050700@evidence.eu.com> <4BB10304.6090006@bluewatersys.com> <4BB1BF49.2000609@evidence.eu.com> <4BB252E3.3030703@bluewatersys.com> <4BBD8C9D.3070401@evidence.eu.com> <20100408111310.524f7354@lxorguk.ukuu.org.uk> <4BBDD71D.1010700@evidence.eu.com> <4BFD1FB6.8050405@atmel.com> <4BFE2F38.8050200@evidence.eu.com> <4BFE41FD.2080804@atmel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GID0FwUMdk1T2AWN"
Content-Disposition: inline
In-Reply-To: <4BFE41FD.2080804@atmel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--GID0FwUMdk1T2AWN
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Claudio,

kudos for getting a RS485-implementation into the kernel! Very useful.

> >     the latest version of the patch has been already merged in the
> > latest Linus' git tree through Russell King's patchsystem=20

Nitpick: Wasn't there some documentation promised after the final patch ;)

Regards,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--GID0FwUMdk1T2AWN
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkv+SX0ACgkQD27XaX1/VRs8owCguPFi6XCJfTM/Z64EgRs/usEr
K5gAn15nWTBz1sMc9HulHKHfswKIPTfG
=SavM
-----END PGP SIGNATURE-----

--GID0FwUMdk1T2AWN--
