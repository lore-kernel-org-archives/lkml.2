Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757514Ab0KPVHa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 16:07:30 -0500
Received: from metis.ext.pengutronix.de ([92.198.50.35]:46880 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756185Ab0KPVH0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 16:07:26 -0500
Date: Tue, 16 Nov 2010 22:07:16 +0100
From: Wolfram Sang <w.sang@pengutronix.de>
To: David Miller <davem@davemloft.net>
Cc: wg@grandegger.com, tomoya-linux@dsn.okisemi.com,
        andrew.chih.howe.khor@intel.com, masa-korg@dsn.okisemi.com,
        sameo@linux.intel.com, margie.foster@intel.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, socketcan-core@lists.berlios.de,
        kok.howg.ewe@intel.com, joel.clark@intel.com, yong.y.wang@intel.com,
        chripell@fsfe.org, qi.wang@intel.com
Subject: Re: [PATCH net-next-2.6 v4] can: Topcliff: PCH_CAN driver: Add
	Flow control/Fix Endianess issue/Separate IF register/Enumerate LEC
	macro/Move MSI processing/Use BIT(X)/Change Message Object
	index/Add prefix PCH_
Message-ID: <20101116210716.GA19893@pengutronix.de>
References: <4CE275A4.9010400@dsn.okisemi.com> <20101116.091443.226753420.davem@davemloft.net> <4CE2EC13.9090707@grandegger.com> <20101116.124325.116396459.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gKMricLos+KVdGMg"
Content-Disposition: inline
In-Reply-To: <20101116.124325.116396459.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gKMricLos+KVdGMg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Nov 16, 2010 at 12:43:25PM -0800, David Miller wrote:
> From: Wolfgang Grandegger <wg@grandegger.com>
> Date: Tue, 16 Nov 2010 21:39:47 +0100
>=20
> > Please take into account that this patch got accepted by accident
> > (because the maintainer did not respond properly in time). At that time
> > the driver was incomplete, not ready for mainline and did not even work
> > properly. Therefore it makes little sense to debug or even bisec these
> > changes. Just for that reason I made an exemption and added my
> > "Acked-by". Hope you can share my arguments.
>=20
> You don't put stupid on top of stupid and justify the latter using
> the former.

Is reverting the incomplete driver an option?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--gKMricLos+KVdGMg
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkzi8oQACgkQD27XaX1/VRtrIACgi+CtCNRF473vsCJMbh82g930
YNwAn1YkvzB4e5XOR2YIZsOu1LaLJVVG
=FZWz
-----END PGP SIGNATURE-----

--gKMricLos+KVdGMg--
