Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab1LFWGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 17:06:24 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:36918 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754136Ab1LFWGX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 17:06:23 -0500
Date: Tue, 6 Dec 2011 23:06:20 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: Wolfgang Denk <wd@denx.de>
Cc: Heiko Schocher <hs@denx.de>, Vitaly Bordug <vbordug@ru.mvista.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org
Subject: Re: [PATCH] drivers, char: add U-Boot bootcount driver
Message-ID: <20111206220620.GF14154@pengutronix.de>
References: <1322991921-21096-1-git-send-email-hs@denx.de>
 <20111204114741.GA5788@pengutronix.de>
 <4EDCD7B2.5030409@denx.de>
 <20111206215056.GD14154@pengutronix.de>
 <20111206215609.5D1FF1A32820@gemini.denx.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <20111206215609.5D1FF1A32820@gemini.denx.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


> > bootcount itself is not a device. It is a feature of certain devices. A=
nd that
> > needs to be implemented; possibly generic enough that it can work for r=
egister
> > based, i2c based, and so forth, accesses.
>=20
> If "boot counter" is not a good name for such a device, then what name
> would you suggest?

None.

> Or do you think a counter (which can be implemented in a number of
> different ways, depending on hardware specifics) is not a device?

Yes.

> What would be such a device, then?

"maxim,ds1338"

Please have a look at the devicetree.org-wiki-page I just mentioned:

http://devicetree.org/Device_Tree_Usage

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEARECAAYFAk7ekdwACgkQD27XaX1/VRujTwCfeaBd9rE2zzPpVHRf2DNqUWFp
zUkAoIJVoLSMaVWyJzbOrxrkC5/H8g43
=9fDN
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
