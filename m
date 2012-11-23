Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab2KWMN1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Nov 2012 07:13:27 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57656 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753248Ab2KWMNZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Nov 2012 07:13:25 -0500
Date: Fri, 23 Nov 2012 21:13:20 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Laxman Dewangan <ldewangan@nvidia.com>, Liam Girdwood <lrg@ti.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: tps80031: Implement list_voltage and set
 n_voltages = 1 for fixed regulators
Message-ID: <20121123121319.GI4529@opensource.wolfsonmicro.com>
References: <1353633954.7586.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="QWRRbczYj8mXuejp"
Content-Disposition: inline
In-Reply-To: <1353633954.7586.1.camel@phoenix>
X-Cookie: Q:	How do you keep a moron in suspense?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--QWRRbczYj8mXuejp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Nov 23, 2012 at 09:25:54AM +0800, Axel Lin wrote:
> Implement list_voltage for fixed regulators, otherwise
> regulator_is_supported_voltage() returns 0.

Applied, thanks.

--QWRRbczYj8mXuejp
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQr2hZAAoJELSic+t+oim9EogP/1/v+RO7ShWeiZeMa7LX5jyO
PfJ2VC8rJSTv+RhYH+6FgmrWYAs3Dav0FPz7R+BtmnAAYscb5ME+cxy5UxXhAWc4
VrT5eLcumLRCMKJkmOX8Hc/fpIAojK7h6Bd5kd6OXR7CusijkoBOBon6eNoDmpOV
eVmrSNefE5XoeAlRn2O7qtXYvi27eN8c6khJf8RnckM+ger1riDP309JRp2+OqDU
OrLijG+u3oJYHl2HUOaOntq0wbYvf/d/YDMiFoM+RGcuPF1/I9E9NdCgSeY2YC75
UV277kbzCBItmUOqk0TG9iaHkFlHFrwTX1VinTsmiubD7OzeCf7G3ktmdRJRBcwZ
z232qeki/ByQOoZa3bkehmQ4bjpg13dzK8B9cULcviE8zRAqDipHH3zbrDR0tTLS
6HIQKsx3u4CNpJMgBGAw0qdMdBNQ/eNUIegJSeF6IHiHt+U7yNILhvf0pvWtaFwN
rh11zFdhsiSLpdveR4RDf8o6MEQLWdCrYd/VXiXz4HEjslZF/Mcf8iHAg3a3PsjT
V8aBP8dTqosikT7uV4VtgX+l9YIRIsRCIry1h2d8EV+u6jT60RXMZl3UJUi/Kgcd
WPOXdG5BFtn3ZQtcx9GBBf/lmV+1qGodQtR7WeIWSZBqUVd8iioJQDQef4T/6xX/
z+iGdqsJQubk8vobg4r0
=zfHW
-----END PGP SIGNATURE-----

--QWRRbczYj8mXuejp--
