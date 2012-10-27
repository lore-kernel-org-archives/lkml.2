Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932402Ab2J0RS2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Oct 2012 13:18:28 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:58189 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759140Ab2J0RS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Oct 2012 13:18:26 -0400
Message-ID: <1351358293.4834.14.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [ 26/85] usb: host: xhci: New system added for Compliance Mode
 Patch on SN65LVPE502CP
From: Ben Hutchings <ben@decadent.org.uk>
To: "Alexis R. Cortes" <alexis.cortes@ti.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        alan@lxorguk.ukuu.org.uk,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Date: Sat, 27 Oct 2012 18:18:13 +0100
In-Reply-To: <20121026000033.747087636@linuxfoundation.org>
References: <20121026000031.107227138@linuxfoundation.org>
	 <20121026000033.747087636@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-IsfGMUsCSEs2kcQFj47V"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IsfGMUsCSEs2kcQFj47V
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-10-25 at 17:05 -0700, Greg Kroah-Hartman wrote:
> 3.6-stable review patch.  If anyone has any objections, please let me kno=
w.
>=20
> ------------------
>=20
> From: "Alexis R. Cortes" <alexis.cortes@ti.com>
>=20
> commit 470809741a28c3092279f4e1f3f432e534d46068 upstream.
>=20
> This minor change adds a new system to which the "Fix Compliance Mode
> on SN65LVPE502CP Hardware" patch has to be applied also.
>=20
> System added:
> Vendor: Hewlett-Packard. System Model: Z1
[...]
> --- a/drivers/usb/host/xhci.c
> +++ b/drivers/usb/host/xhci.c
> @@ -479,7 +479,8 @@ static bool compliance_mode_recovery_tim
> =20
>  	if (strstr(dmi_product_name, "Z420") ||
>  			strstr(dmi_product_name, "Z620") ||
> -			strstr(dmi_product_name, "Z820"))
> +			strstr(dmi_product_name, "Z820") ||
> +			strstr(dmi_product_name, "Z1"))

This will also match any future models with extra digits after the '1'.
It might be worth using a slightly stricter match.

Ben.

>  		return true;
> =20
>  	return false;


--=20
Ben Hutchings
Never attribute to conspiracy what can adequately be explained by stupidity=
.

--=-IsfGMUsCSEs2kcQFj47V
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUIwXVee/yOyVhhEJAQrKkhAAs6/ZHDKJZGy7F8nNdNzR8UAW/0ebThcv
c1+8icrDl3mhP7KgVLU6E4XG9kW+Tzf5giAcBLNi5W4fUJApx/q1KrVmACZ4Oehm
Ais17H0JfUlq0/yL+2gOr5Sx7g1j4DCALDTGSP7umgTOpoDST9Os2bu5jOi3opN8
7H+KSpCd8DkbxIAsQaYcW3Vw4U9RfHSjmlUxzGxxdhcfsPqjilArsKbGQZ0oqrsx
ZN5OtJ8VL8BasCSfQEh+hoJtJdnyUsFzIvZ9IfzZmbvGy+BNDTuJ1iKXOYmIOqGs
bzhik6ih4IgmdfGhBZdXy9I51csbc3vOqXcAgG1VqxKYXctVIZ4otLmnQ4IVQhgM
DgTx7yMEraPS2C/AH1qYwvSodjwDrds2otfIkZvv3noSr6Y53LCVR6N23q+rX1iC
tbG8UIyS0exV2zAy+tqmYojgkyZEVzlL/arDhRLVjHaz1e96vKJyF28+z/PY6Sdo
U8ozmItD97VJ6hZVu4M3kotVU6Y1zz0J9kTp8trMAvBtNndd2cguUHF9zZ2drIxY
wLKgznea3I+R46hWjqkfppXVRPDsCkavqetgGxnEXEY1KcXK3YM3spTLBRnMPFPY
ZHHPW6sk2uWbQrefbAOfvjG3QsJnQLUTQvqSPkCDMQsRmkH+6pFanGk1kXTCVUHF
8NrTw6uqEU8=
=MTIC
-----END PGP SIGNATURE-----

--=-IsfGMUsCSEs2kcQFj47V--
