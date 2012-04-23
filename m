Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754024Ab2DWR6x (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:58:53 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:53904 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab2DWR6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:58:52 -0400
Date: Mon, 23 Apr 2012 19:58:29 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: David Daney <ddaney.cavm@gmail.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        "Jean Delvare (PC drivers core)" <khali@linux-fr.org>,
        "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
        Peter Korsgaard <peter.korsgaard@barco.com>,
        Guenter Roeck <guenter.roeck@ericsson.com>, linux-i2c@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH v3 0/2] i2c/of: Populate multiplexed i2c busses from the
 device tree.
Message-ID: <20120423175829.GA2767@pengutronix.de>
References: <1334265263-13549-1-git-send-email-ddaney.cavm@gmail.com>
 <4F880960.8010803@metafoo.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="k+w/mQv8wyuph6w0"
Content-Disposition: inline
In-Reply-To: <4F880960.8010803@metafoo.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--k+w/mQv8wyuph6w0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 13, 2012 at 01:09:20PM +0200, Lars-Peter Clausen wrote:
> On 04/12/2012 11:14 PM, David Daney wrote:
> > From: David Daney <david.daney@cavium.com>
> >=20
> > v3: Integrate changes from Lars-Peter Clausen to make better use of
> >     the of_*() infrastructure.  Get rid of ugly #ifdefs.
> >=20
> > v2: Update bindings to use "reg" insutead of "cell-index"
> >=20
> > v1: Unchanged from the original RFC where I said:
> >=20
> >   We need to populate our I2C devices from the device tree, but some
> >   of our systems have multiplexers which currently break this process.
> >=20
> >   The basic idea is to have the generic i2c-mux framework propagate
> >   the device_node for the child bus into the corresponding
> >   i2c_adapter, and then call of_i2c_register_devices().  This means
> >   that the device tree bindings for *all* i2c muxes must have some
> >   common properties.  I try to document these in mux.txt.
> >=20
> > This is now tested against 3.4-rc2 and is still working well.
> >=20
>=20
> I've been using these patches with a pca9548 and a pca9546 for a while no=
w.
> Both:
>=20
> Tested-by: Lars-Peter Clausen <lars@metafoo.de>

Both applied to next, thanks to all involved.

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--k+w/mQv8wyuph6w0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk+VmEUACgkQD27XaX1/VRveAACgzATmTRrdC81RV4mAaV37qp/R
bwwAnRlRY27ZXHk2qWeVgF9GfVmesKs3
=jCHJ
-----END PGP SIGNATURE-----

--k+w/mQv8wyuph6w0--
