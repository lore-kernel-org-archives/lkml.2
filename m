Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754750Ab2FMSJq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 14:09:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37466 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754507Ab2FMSJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 14:09:44 -0400
Date: Wed, 13 Jun 2012 19:09:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH] regmap: mmio: Staticize regmap_mmio_gen_context()
Message-ID: <20120613180942.GA9171@opensource.wolfsonmicro.com>
References: <1339599444.8531.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="tKW2IUtsqtDRztdT"
Content-Disposition: inline
In-Reply-To: <1339599444.8531.1.camel@phoenix>
X-Cookie: You have a truly strong individuality.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--tKW2IUtsqtDRztdT
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 10:57:24PM +0800, Axel Lin wrote:
> regmap_mmio_gen_context() is only used in regmap-mmio.c. Thus make it static.

Applied, thanks.

--tKW2IUtsqtDRztdT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2Nb2AAoJEBus8iNuMP3dPYMP+wRD16R1NGHHzuVF+3eEaTuV
+vy0pdO9Wj/52UKMn38aO5TUgNaiR47ymzQWTZfPs9JZiUYRiJ02RyA1yL37vHmZ
PlAvFlMPXAY7WBlt6Mexi61rCNhJ2XMA4C09eraRd72COXceacEObP5e4V8/3tvs
ER+xk4aGbjbmwqZin5i48UJeDePF5TVLIwKgJhZVCPo5s/zAijJHYByDDyKwihfj
gcADmGSyW5XdETXCIumMmVKJhQ8zy6S7TYslyilsKXb7+DHnygCEAbnGuJV37em1
4J1CsTalDG00JlstsAIjAKFt+X/eJNAOjkp1hLJ3ITos35MDCRXBfDV/21gIF0a8
wKWBjhbyy28VrWPD5HskWzu7KDFKJ6kOcQLN8nnhMTt6Fn9UQu727E6mlQmroYIV
hetFm0Z9ZhGJnIpmTB4D0reUjZ4FNxX0ZiZJD3wOvnkbxUKnf0XmV3YNHZrvYa6D
TcChDaeCSjaFLtj5mb6cm+gagTqYeN30+LipjckinS+xstt3odU3qQQbQIEAfq1X
DpY6xyhVeOnvTB/OcmqwBHdILNiW4YfRywgnzIif13Qz5DhnuQnkqgxBhVGwx7SW
qMPL5DVjNGZWQUos3R2qe73uuAXbPJYL3zEBSSYfIfQAit99+bv/Wz5Qf1/EOH34
Y4kCw9RwI17hF0eZI2ZM
=PKsH
-----END PGP SIGNATURE-----

--tKW2IUtsqtDRztdT--
