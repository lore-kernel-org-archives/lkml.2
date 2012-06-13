Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2FMKDp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 06:03:45 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52295 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751384Ab2FMKDo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 06:03:44 -0400
Date: Wed, 13 Jun 2012 11:03:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT 3/4] regulator: wm831x-dcdc: Convert wm831x_buckv_ops
 to set_voltage_sel and map_voltage
Message-ID: <20120613100342.GI4545@opensource.wolfsonmicro.com>
References: <1339467650.22991.1.camel@phoenix>
 <1339467789.22991.4.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CD/aTaZybdUisKIc"
Content-Disposition: inline
In-Reply-To: <1339467789.22991.4.camel@phoenix>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CD/aTaZybdUisKIc
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jun 12, 2012 at 10:23:09AM +0800, Axel Lin wrote:
> Signed-off-by: Axel Lin <axel.lin@gmail.com>

This patch is way more invasive than it needs to be (and therefore hard
to check) because

> -	if (dcdc->dvs_gpio && dcdc->on_vsel == vsel)
> +	if (dcdc->dvs_gpio && dcdc->on_vsel == selector)

you've replaced vsel with selector throughout the code.

--CD/aTaZybdUisKIc
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2GVzAAoJEBus8iNuMP3dwbIQAJhk5dXs4II73KXvkFViLyZZ
fELRGOGx7SetyjjnQhtp7u9I0yYWm9jjOKY4gySI+ZJCMRRQFYA0Z1YTd7ZNYK11
gWlVW3nmPWAV6IyYcd2vgESRR6vlBdqjmjP/9LywB7R+U2N5p1gD9aFM/EOdu7AN
a2kVghvKJIa499V9niPpefa7SWoBq5K0YhsqP4YrkKnbqCV2ilUWjg0MRRw+TZ67
i92PnboUJ4rgZAiw6CZMge+arq5YRn0TJu4StKd+EnLX/9m3MTPNJoRBHhbrcqfl
rJSI3UrTSvunV7Q99M3yETRJc0hyj+nFQXq4w6n1fx2cZO0Q15MJwbjLogv7QIZ0
YgQREFSfDxl8zXgul2BKPsPnd2w8uXfWPWWbDgZpvjdQEuaS5u+aprEtyXD1K/jY
Cikgr4SjS43x567+hF9NYqyvk4SnAgTd2Fnz58LIBPnJ8LxroZgQC/RjPjdS62Ws
BplPOBZzkrbYdhVk+dr3UbJqTUoRY2swZaJnSiDepge+EcnZNDtmz2T8z3paFqPX
EOr92Rcap3iWlv3X1WVtYUMUbjOUUi4ed7ndivbvGRpJTrdT97xPqMfSgaE0K78H
pHMTOEgvu7p537NpDxCzh/hXMUa+MOrxUQTmwg8TM62NyJ0/AH0laAsh/GAqJn5l
Fp+LbhSS/9EgqMRfT/wy
=6ugV
-----END PGP SIGNATURE-----

--CD/aTaZybdUisKIc--
