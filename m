Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab2KEK4o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 05:56:44 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58816 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753136Ab2KEK4m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 05:56:42 -0500
Date: Mon, 5 Nov 2012 11:56:39 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, lenb@kernel.org,
        rafael.j.wysocki@intel.com, grant.likely@secretlab.ca,
        linus.walleij@linaro.org, khali@linux-fr.org, ben-linux@fluff.org,
        w.sang@pengutronix.de, mathias.nyman@linux.intel.com,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 2/3] spi / ACPI: add ACPI enumeration support
Message-ID: <20121105105639.GE1385@opensource.wolfsonmicro.com>
References: <1351928793-14375-1-git-send-email-mika.westerberg@linux.intel.com>
 <20121103201310.GQ16648@intel.com>
 <1535917.BaYBBNgGy0@vostro.rjw.lan>
 <4052192.ry8JrGTr6H@vostro.rjw.lan>
 <20121105105602.GC24532@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="T7mxYSe680VjQnyC"
Content-Disposition: inline
In-Reply-To: <20121105105602.GC24532@intel.com>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--T7mxYSe680VjQnyC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 05, 2012 at 12:56:02PM +0200, Mika Westerberg wrote:

> > struct acpi_device {
> > 	...
> > 	union acpi_resource_serial_bus *serial;
> > 	...
> > };

> It is also possible to have several serial bus connectors on a single
> device (although we've seen only one connector per device but it should not
> be limited to that).

I've got practical systems where there are multiple buses physically
connected, though in practice almost always only one is actually used at
runtime when it's I2C and SPI there are some systems (usually with other
buses) where you might want to use more than one bus.  Not sure those
buses will fit in here though.

--T7mxYSe680VjQnyC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQl5tgAAoJELSic+t+oim91GMP/iyqvgjKkbCGjnaffRPy1vXD
s/up+6mOdqNNcz559ti7LE0JcK2nXab0ffcFT0cbhQ46pTdrPqZS7FdEvHqeOPWK
WDpQCPqVfWTBpQC8CttjRhUdtBFnDrfbJeHcvsz4OboW7EMkXxRilfES0yYuUOSV
OQJ4dJvjtfBawsN19gs607rOPMCBjKtsHdhRtqV4pL4x3dzp8WwDSbgxSJQ1doxm
REgOtrAgCOdUisacRpm1epu6rLPfYsiDrN9Pho47gjUbSNL2Jo+6FJupcFxYjjGL
Zt6BhGArrPkCHH0Ziyb0epyQIIWBo88SQSTYZiPRF1CXbiVtH0ZRoODwyCa0FdeC
zd8LIRobvsDWgNdCD1dtwFr27YyeLOtHcK2rCGC7ttbtaWhmrfJkKlLc7fBqCm+v
XF1vyzSAdAMk4AsYvm33DGhXubhDPIPyMbTBicx5eNMn0StEqVeauK1HZGuAa8rM
xsVSKBOf/cA5zxRQQD8ZdgFjtYUpWeqpP10H3MOzapBl9G/QAnVryLH+2A65bH3y
yk7S2sgDeDwTrkMQKmpDVd5WHVfxTRi1txEvrcbI0QVRk8MoWA2g8DvWMKReGvf4
evqZ1NrUKDqWNVopXQH6iQcFVgdXWyHtRsWyo0b+GpepSVl4DJDpPhGFB0k4aD+6
6KFEpuVpJqiRA3x2CiKp
=hlgk
-----END PGP SIGNATURE-----

--T7mxYSe680VjQnyC--
