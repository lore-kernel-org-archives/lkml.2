Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab2GEMK2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:10:28 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33787 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752887Ab2GEMK0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:10:26 -0400
Date: Thu, 5 Jul 2012 13:10:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: grant.likely@secretlab.ca, rob.herring@calxeda.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        swarren@nvidia.com
Subject: Re: [PATCH V3] regulator: fixed: dt: support for input supply
Message-ID: <20120705121024.GV4111@opensource.wolfsonmicro.com>
References: <1341471708-1225-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="w5nY8nmEklXMR7Cj"
Content-Disposition: inline
In-Reply-To: <1341471708-1225-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--w5nY8nmEklXMR7Cj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 12:31:48PM +0530, Laxman Dewangan wrote:
> Add support for input supply in DT parsing of node.
> The input supply will be provided by the property
> "vin-supply" in the regulator node.

This doesn't apply, always send patches against current code...

--w5nY8nmEklXMR7Cj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YQqAAoJEBus8iNuMP3djukP/2vlxZKtNQzBk4S9OTKed5uu
H706ILUjL7umguzhzru75AAd4FVnkjcXkQB/u8e6lV6CB1OAN6WfKCfFtuqlKo/d
ZJTfDY9YJ+02f4vQvXMJ//ovEWE5D28BtJcuhROJhlYMiI8nxEVbaxHP65m7TpYn
fMCuOtPO6GtClk8Dq0jFrGPUShLaOlNkSoU2Ui167oKROPa9KWK4p3ZvzTJqlsVj
eK4m+alHUafzfJbot6JreErors8I+XMBsxc2sgJiFZn1tI9B7oXnwtGGp1hssmBa
Hfj7mzy+aemkpVSxBorSB6cfAU21lkUl54Wxc2SJpM4fewlV9JYpIaQGJlGe/tpY
w74NvS72wwI5c03n5uJKwAU63gQf4IDUuXOhf/F05kARbJW4cGr+yFLCsoZWZnwo
5mKDeM5c5KgKYO+IXC67on3aWUmN9ewJeRDsFjtq+idWjCjNvZb9sBRCt1oBwtTM
iDVO/7w8NUgkqqmteeW1bJJaR+aszj4VUhQzHHvbF10IghRJyGpcEsOgltgkPaOr
RagCHDpa3wNBHOLWjxois8xcnoVohexNSF9O4HernEREI3mMIe/R3QgQgOhtxlni
tVHxrYKN/fRmOgY6aknk8tik85wgA1CT+VhABMFcv7a3paEUiCZGFYbZr4GtpBbw
sOyMDAnod6Mq2uIH/r1R
=W7n2
-----END PGP SIGNATURE-----

--w5nY8nmEklXMR7Cj--
