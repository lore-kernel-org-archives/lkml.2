Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756260Ab2GEMfc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 08:35:32 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35656 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753630Ab2GEMfb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 08:35:31 -0400
Date: Thu, 5 Jul 2012 13:35:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: ab3100: Use rdev_get_drvdata() rather than
 use reg->reg_data driectly
Message-ID: <20120705123524.GA4111@opensource.wolfsonmicro.com>
References: <1341452295.5435.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="fIj/D6Y6BN1okdX1"
Content-Disposition: inline
In-Reply-To: <1341452295.5435.1.camel@phoenix>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--fIj/D6Y6BN1okdX1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 05, 2012 at 09:38:15AM +0800, Axel Lin wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks.

--fIj/D6Y6BN1okdX1
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9YnvAAoJEBus8iNuMP3dEhUP/1epLn7c5p3+kxolR2qA5yxT
4fhxgeSuDKbU38ws2OVV5H8uZm68uInv2ohta3g6JJYGtY8egWe0gcT61CeSQjlK
JOil/wAyJ66ZyJUtjqI1BoJsGC9pCr647mHxid5ZdviO32zLCRalsWiPJvAbTklz
buIJ9AT7zWfCR2Ig8K3bVauNmB/y4395A+dW+CObW/lYxNnnMNXx7Vtz0j5EfGkQ
/plH8rrE3x1N95YfUvcqxxF3R33BFY2H9/srX9X5FeTI/Xki/7ia3ah0wBqJC+z3
w4D6yBdYxLil9CSCKPN621dFs2A3NmkFoQrThLXkQKaQAhhoZ0Fox7H1NzHbCuAp
jIbT1TZKJAQgkINsxWxtC9OXkm5xNAaP24Y6WQRfto8Y+6i+RzQU/DT2RLISasAL
fh0lylRPn2gw2IxzUSEx+MGVS4p0kujOaefUL8kToGV79gUSsdTsLWtIxifINHt2
dKPpYl6yyYca0WatF6nWi/wde3N9JtVYryNi5+tnhJUkAOBx4wNmcD9fo506bXX9
ovQ7TOHXnf5R7He993WGuzISXQNhrbSuFmFQRoQ/1Hc8EpwH6Yeh4ko5dljlTvRF
MKMQI6DFMrvU3hMVm91MLHMt9nd1zNo3ebm/WbJCJcrmjoCkFgp03HbePc25+80T
n5QDJxkEfQhUV9EKRg+o
=hXhJ
-----END PGP SIGNATURE-----

--fIj/D6Y6BN1okdX1--
