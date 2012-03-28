Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758087Ab2C1NcY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Mar 2012 09:32:24 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52545 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758015Ab2C1NcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Mar 2012 09:32:22 -0400
Date: Wed, 28 Mar 2012 14:32:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alex Gershgorin <alexg@meprolight.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        marc.reilly@gmail.com, s.hauer@pengutronix.de,
        fabio.estevam@freescale.com
Subject: Re: [PATCH v1] mfd: mc13xxx: add I2C support fix building for v3.3
Message-ID: <20120328133220.GR3232@opensource.wolfsonmicro.com>
References: <1332846260-18145-1-git-send-email-alexg@meprolight.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gV1yUYniiDLxW66s"
Content-Disposition: inline
In-Reply-To: <1332846260-18145-1-git-send-email-alexg@meprolight.com>
X-Cookie: You will be run over by a beer truck.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gV1yUYniiDLxW66s
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 27, 2012 at 01:04:20PM +0200, Alex Gershgorin wrote:
> This patch fixes the following compilation errors,
> when using a series mc13xxx-add-I2C-support-V4

> 1)
> drivers/mfd/mc13xxx-spi.c:50: error: unknown field 'pad_bits'
> specified in initializer

This (and probably some of the other stuff) is already merged.  Is this
just a backport of stuff for 3.4/5 to enable testing on 3.3 or are there
any errors that need to be fixed in the relevant places?

--gV1yUYniiDLxW66s
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPcxLbAAoJEBus8iNuMP3dlmAP/A+8bhVcxFcpKUW9fQc4a3Kn
LNq1EXyK8anupT9ok8JBxP3LBSsdb4e8+mY0weKtPFe6QkuqqvVf5bAlDYCmJQwG
apdboQ8zE+s9om/svexSNMQKNa5062MvvdRDMoKjBYyVngwy0WkT/0zHqnD5O0HJ
0GaerjPp2Xn/fbse3Wm8zob5fw53mT+IzsApIUdh6OUgpEsXDxgTBa/vJnPLxDBU
56PAxYLu02KmEHoWuChftBQiCBakg+27KTX/66jQZbyjT/hnRl1pa2mpSXBjHX7d
DcBNfPCteq7dkdtLIlaDkCgh9DI+MWPyDY42bZzEQsPpEYrLLej02rch4lb80Swz
yz6CwDr0vVSVbmUemVu/7GWIZqxYNKxC1voV3Z5xRIaBh/89O6KVTirqkDWzq69a
xmz50+IvlFrUxhjDv2v89mnlcK0asQ8lfYs0+n1ie86KSai8+mVDZ2M6Jkza4g0X
cqEMrXmhtj1y3AB8cWVPyq/f3aZ8Yq7AHpSlbvEGGnuptLtS72ixDiwDfIEzVMGV
kj8Th49KHf4TEYbaKEhhoY6bSwsANoGEh7htnRUjAeR1s8bDBFaOxoYIPftdaz2O
dzAmUKF09zZk3KvV+ZjwPOiGcuxv4S4Fkh7UeeWLL91KMygXFbGoe+1o4mivzODn
jESDWhtyd6WbibRIczic
=wadX
-----END PGP SIGNATURE-----

--gV1yUYniiDLxW66s--
