Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756700Ab2EHPs2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 May 2012 11:48:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50101 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755421Ab2EHPs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 May 2012 11:48:27 -0400
Date: Tue, 8 May 2012 16:48:21 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Rhyland Klein <rklein@nvidia.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 5/6 v3] mfd: tps65910-irq: Add devicetree init support
Message-ID: <20120508154820.GA15893@opensource.wolfsonmicro.com>
References: <1336502563-31789-1-git-send-email-rklein@nvidia.com>
 <1336502563-31789-6-git-send-email-rklein@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BtNCO5h84ExDStzY"
Content-Disposition: inline
In-Reply-To: <1336502563-31789-6-git-send-email-rklein@nvidia.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BtNCO5h84ExDStzY
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, May 08, 2012 at 11:42:42AM -0700, Rhyland Klein wrote:

> +	if (pdata->irq_base <= 0)
> +		pdata->irq_base = irq_alloc_descs(-1, 0, tps65910->irq_num, -1);
> +
> +	if (pdata->irq_base <= 0) {
> +		dev_err(tps65910->dev, "Failed to allocate irq descs: %d\n",
> +			pdata->irq_base);
> +		return pdata->irq_base;
> +	}

I'd expect the driver to always call irq_alloc_descs() but to use the
value specified in platform data if there is any.  This is the normal
way of doing things, anyway.

--BtNCO5h84ExDStzY
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPqUA/AAoJEBus8iNuMP3dXpgP/iaxTdpK8yfhWwckz9oQAatR
WbAsz8Gkf6iiZrxX4kW8OaClB7Ug68VKpA6V+h5hqfIw8YfHMS4QWyQP9X0SZBDR
eJbItS38oudgpae8nQp7rIESBk5wQrRJqK4tp+UCsLJ/XX9OS26Mstzi9WXuCYby
o6zw6mlawGrMu5ZlbWBIUePJ0WhXRK0LrVEhUdd4eMiMwKyo1/oCiowoU22CfIAJ
5OY22W6Bkca+PxfmdMnat1KkPMNpuaYyjt0s9YWXZPJPiDb4srOPWZ7dLSTDwgn9
F3QL1IyVURUBeLwON8DRFpuFF104/ofiaLCLAGs5/0O2gAkr+s0mF5j5MrGdn1f0
777UFzCWvaiLcsjTdPyKOZkk+aOiMmAlJaIenb3oJDq5zXhbg+IehyQotk3wHgjv
+jH5K7Y8h+oJJcaEIRwLuN7JH5NrZjGaz28bN9eVhYE4s85rgXOe4hZ5PycnOUlK
gREyH4reb43t5ADskKRXytntE9kx7wTTs6cwlWm1rpF5QCuq/WharX1Xfn3Mky9r
XVr2PxnLGtSw94rBEo4lXvliuT0wBscod32VJ66+kYuQnsf0a2chUotI7LKisHtw
WnF6ot4LX9R2boOiAWoigqceNYx5JLpD02NbbT/81SfEfBOVSZlqRqyuuKMEMBVq
+tDcluGIeN71kRWAouS0
=lrxs
-----END PGP SIGNATURE-----

--BtNCO5h84ExDStzY--
