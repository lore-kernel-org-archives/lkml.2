Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753046Ab2D1L6j (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 07:58:39 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:39980 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751335Ab2D1L6h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 07:58:37 -0400
Message-ID: <1335614313.1937.11.camel@koala>
Subject: Re: [PATCH] mtd: block2mtd: page_read() never returns NULL
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Ryosuke Saito <raitosyo@gmail.com>
Cc: linux-mtd@lists.infradead.org, artem.bityutskiy@linux.intel.com,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 28 Apr 2012 14:58:33 +0300
In-Reply-To: <1335178037.3060.7.camel@HDL00099>
References: <1335178037.3060.7.camel@HDL00099>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-ZR4h+uVcq+YhJ9S2s/AQ"
X-Mailer: Evolution 3.2.3 (3.2.3-2.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-ZR4h+uVcq+YhJ9S2s/AQ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-04-23 at 19:47 +0900, Ryosuke Saito wrote:
> page_read() never returns NULL, so we can remove the NULL check here.
>=20
> Signed-off-by: Ryosuke Saito <raitosyo@gmail.com>

Pushed to l2-mtd.git, thanks!
--=20
Best Regards,
Artem Bityutskiy

--=-ZR4h+uVcq+YhJ9S2s/AQ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPm9tpAAoJECmIfjd9wqK0v2YP/ioq2oahVcooAX7+ejoNUbUy
Kmkyty85dz+EC4pzP6gX1bYcJGWscxwffAU7EfutO2kVfFuLne0UndiHCj4j1c0V
x4pDsM5qz/kYDLMrln5AQjQ/9L8tcvfHPqmRJeY6d9iDP/Uw7y9Ruy7lGy+tNUlZ
dIsGizZ3s6fM7Vm4DHwep1avxAKNK0t9ggapXDoquzSppwCHDY6F3pGZQgDoG1AH
RBuz7nPXSYcZZvkEFXaVRUUK+cOmzE3hHF3CpHWStSaJBXmIy807jRHSGNep4TaD
lU4NsHQ8uENQb6Od9ZnqdQQA0ImrT0depd3f0cuRqDleHPpjmpC9NrUehj2TwyEu
Qr3X8MzLr15SwQXTCfaCF3OTK/QKFb4+wzRG6AW6S+LCe/onzgexGEm26ZnEP9Ud
Uq3+Y+jUcBdTjmYeR8PqE9uIcmKVazI2OuxCiqcotbv1R7Ve7YqAcbkYWEincfzf
nDNvmvY+DIMKlx9PQlGdGIuMraaVVQz85+7evjUBGYaGbfctIoVobXjo8yA8jLfH
j4TPWzFnHjaTQZAfg3rJApr6UUEiDEbnslHyjJ5/jMhYaX3OG4yj2b+L6ANv+VPp
fvwnq3C8sXKClpXeVM3GSI4XHkCfcBOh4v0RDzNdLdHCW1WsZWp6P2kIWAzzvcZ3
1p3Btrr4x7F9d4m25duF
=9RXd
-----END PGP SIGNATURE-----

--=-ZR4h+uVcq+YhJ9S2s/AQ--

