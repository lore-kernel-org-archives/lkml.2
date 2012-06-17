Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753202Ab2FQTul (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 15:50:41 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47191 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751605Ab2FQTuj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 15:50:39 -0400
Date: Sun, 17 Jun 2012 20:50:38 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Philip Rakity <philipspatches@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org,
        Philip Rakity <prakity@marvell.com>
Subject: Re: [PATCH 2/2] regulator: core.c Only delay when setting voltage
 requires this
Message-ID: <20120617195037.GG4267@opensource.wolfsonmicro.com>
References: <1339711676-3488-1-git-send-email-prakity@marvell.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="vJguvTgX93MxBIIe"
Content-Disposition: inline
In-Reply-To: <1339711676-3488-1-git-send-email-prakity@marvell.com>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--vJguvTgX93MxBIIe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 14, 2012 at 03:07:56PM -0700, Philip Rakity wrote:
> minor optimization: move delay code to where delay is set and
> thus where it is used vs in the main line path.

Applied, thanks.

--vJguvTgX93MxBIIe
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3jUHAAoJEBus8iNuMP3deyIP/1l/LFe8RfhSNpjyXuTnOJWY
AFwe2e9DvX5dWesWZr83Nv9ROVHFfEVlhfezGnrO5D1qpudh03w+Y+JugM1/ES5L
UtlBYVul/Mj8yYnC99PslBOkZ9BL5FGa2d45A1qGTrgqnYj9Kc68L8ZdMhC6O3F+
5LcSdAgY7MeSdzRWv0h2cUXyNABgl2BWsnfk2VUL8FcW6MMyEbZfOwDbrvrB7D3K
Oq0rWGrwizoSVsWIaIcZRUHqUSo4RNRHe78hP5f9Qfy/hB2AiBBipu7crF8PkhMc
DUh1bkjkhEWwJsqqcJ/cZo6onGdPYQcC/vl5KJO4aSDMTkr8GayEEuXZu+fXwr/m
ovY9CSnJC61Cq458Lwj2J4+cpS8tbsFGHRyV3uZisuoHAcyPATQwGzDeQzxNSkjM
OiEhSK3rJTv6qYm5i31+uXPULA4Tx6Y7fXhWjUBR503lumggZNDdwqhp5+z1OKxg
kqj8+kJR0703QmVWpgSrHRjzkhKmLSbvR/gkut2LMu0NMftqAcI/OHsS/YoB1oER
YcuJn62Uyzrs70hopyJCeLkK9BpKA9pTxAqjYjuPTKQYckwoywtfrL5e7SiZbswm
ZgXxdo/UJ0KloN++ntq5lS2jzi/XYfqEOq5qaSs9v8JSoV7IT/mGzmJDPKICe30J
0MvKon5ldGukLjwoKphU
=jAUb
-----END PGP SIGNATURE-----

--vJguvTgX93MxBIIe--
