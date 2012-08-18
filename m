Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754043Ab2HRMQj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 08:16:39 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:58833 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750984Ab2HRMQi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 08:16:38 -0400
Date: Sat, 18 Aug 2012 14:16:28 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Jean Delvare <khali@linux-fr.org>, Ben Dooks <ben-linux@fluff.org>,
        Daniel Kurtz <djkurtz@chromium.org>, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c-i801: Add device tree support
Message-ID: <20120818121628.GB12839@pengutronix.de>
References: <1344409609-1904-1-git-send-email-thierry.reding@avionic-design.de>
 <20120818094846.GA24812@pengutronix.de>
 <20120818111745.GA15702@avionic-0098.mockup.avionic-design.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="aVD9QWMuhilNxW9f"
Content-Disposition: inline
In-Reply-To: <20120818111745.GA15702@avionic-0098.mockup.avionic-design.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--aVD9QWMuhilNxW9f
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 18, 2012 at 01:17:45PM +0200, Thierry Reding wrote:
> On Sat, Aug 18, 2012 at 11:48:46AM +0200, Wolfram Sang wrote:
> > On Wed, Aug 08, 2012 at 09:06:47AM +0200, Thierry Reding wrote:
> > > This commit adds support for probing slave devices parsed from the
> > > device tree.
> > >=20
> > > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> >=20
> > How are the devicetree nodes of the slaves connected to this PCI device
> > which should not have a node itself?
>=20
> The matching is done by pci_set_of_node() and pci_set_bus_of_node().
> The latter will eventually call pcibios_get_phb_of_node(). What makes
> you say that PCI devices shouldn't have nodes themselves?

I thought to recall that busses which can be probed at runtime should
not have nodes but should be probed. Maybe that was wrong. Can you point
me to a dts-file with an example?

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--aVD9QWMuhilNxW9f
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlAvh5wACgkQD27XaX1/VRvjTwCfaK03r/DLNoxuRZnN3QdTO6+h
qhUAoJyBcZCUf9NbcFUJEW/H7wQmf0dg
=ZmQM
-----END PGP SIGNATURE-----

--aVD9QWMuhilNxW9f--
