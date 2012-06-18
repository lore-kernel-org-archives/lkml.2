Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751589Ab2FRMuI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 08:50:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36445 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751016Ab2FRMuH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 08:50:07 -0400
Date: Mon, 18 Jun 2012 13:50:05 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: sameo@linux.intel.com, "'Liam Girdwood'" <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/7] regualtor: Add samsung s2mps11 regulator driver
Message-ID: <20120618125005.GN3974@opensource.wolfsonmicro.com>
References: <067801cd4d45$a743e820$f5cbb860$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="lBqJz4CGKwlWe7/k"
Content-Disposition: inline
In-Reply-To: <067801cd4d45$a743e820$f5cbb860$@com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--lBqJz4CGKwlWe7/k
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 08:29:41PM +0900, Sangbeom Kim wrote:

> +static int s2mps11_list_voltage(struct regulator_dev *rdev,
> +				unsigned int selector)
> +{

Please take a look at the new helper functions which have been added to
the regulator core for factoring out things like table based and linear
maps.  This and quite a bit of the rest of the code can probably be
converted to use those.

> +	case S2MPS11_AP_EN32KHZ:
> +		mask = 0x01;
> +		break;
> +	case S2MPS11_CP_EN32KHZ:
> +		mask = 0x02;
> +		break;
> +	case S2MPS11_BT_EN32KHZ:
> +		mask = 0x04;
> +		break;

Use the clk API for clocks.

--lBqJz4CGKwlWe7/k
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3yP0AAoJEBus8iNuMP3dtX4P/iIF1KFdXzYZPNpPZLLWHALb
3o7tQqvvOa86erOj9cum9/ybPIht0YcP84TfHfjDOTohcC/FILAHeuwfI9Q/P1EX
IFRjkE+DBFNlc573hrwcNPFs3PqMeNNXqJs1r2he6Cp79jTzdP1ZPZdZq8A/uXjO
M1709kIrpsJ4HBnmY/bcmZrPQyUi2mkalGn4uu74YK/BFMIUj9UwR9Wor0bzTmAy
fVsKB24zmKnXE133aVA7pJH0I9d6i1fIEu2BIs1Ow+SsWAq7cC+vn6IG1zWi7DeJ
ad5XqVidRkjRVXosp0wzZbvXtXKBVve/tpmky+Sp87f3mmgCPByQlWlDT5cfbBZL
5NnVZ0r4zJIKjH37JW8mfKDWj48C+zBZOYQXAzDJfxaTNZ7/jTJepFErqX1gK9ql
lPCi9RUOLfpSKM9A/sEpmJwOaf+TuhqyYyXTPNCJgH0mC1ZKA6F9Mp12fCVlAkPb
IR6wmhYC0lQib3w1oZ/Ahdwno7l0J8/HAUf3/s/LSGLoP+EeyJ4r20dFTP8yXvGh
IjmkZLJwo4ftBbFItlHbGQKw1Dca86xK1yZ85rJSRIUHD9hV4FkGO9D4X5XmfGp3
u7b+d+YgbjU8cXF0Kll+YYZhvoelYezG5M0dupiYJZeoPtwkOYORDhEp9g09BDio
WCpgM11ZA5yQjpcsmYPR
=saWX
-----END PGP SIGNATURE-----

--lBqJz4CGKwlWe7/k--
