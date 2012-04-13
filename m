Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932839Ab2DMI5Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 04:57:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:57208 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755213Ab2DMI5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 04:57:14 -0400
Date: Fri, 13 Apr 2012 09:57:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: Update regulator_register() API signature in
 Documentation
Message-ID: <20120413085712.GF3168@opensource.wolfsonmicro.com>
References: <1334302325.2879.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="UBnjLfzoMQYIXCvq"
Content-Disposition: inline
In-Reply-To: <1334302325.2879.1.camel@phoenix>
X-Cookie: A is for Apple.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--UBnjLfzoMQYIXCvq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Apr 13, 2012 at 03:32:05PM +0800, Axel Lin wrote:
> commit c172708 "regulator: core: Use a struct to pass in regulator runtime
> configuration" changed the regulator_register() API signature.

Applied, thanks.

--UBnjLfzoMQYIXCvq
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPh+pbAAoJEBus8iNuMP3dDdIP/3eE/7dit27koPvUROgUg9HR
9e0rCRQ9qI+Pv5Is5xB/xWa1SUZR6zweS6Xd7AQcP1N4WHg56pGAuXLW2aF7ywdh
SopciuTuhepciJME2yNZFUy/bbNwKWZHqN+tQeuVNwesDn/9VnCVCcSKuT2Q7mQ2
l4wENRr9j8FJaXP6DAGr5YPNywymspTL6adxW2LE1nPD5Dv7iO9955JkfXvLxzFE
zHtWFAXOgL4zkyRKrXziTo/xUp79Kcpkqnr0fqdBo1FeSdFRvHXV+aFhxh7PKxSe
6bCwuLM8Dm9wP7NyryoMTYBFCmDjTsjMdAJK8yQWeUaIxnu+5tlKOjVTTVk51X4T
PPVeaFkCkfJjKa+pOaaRcvi9E4tGT9FP166oJT4Ub8BHPIP9JzLiyuUvWt+btQTx
RKNFlORrt2e1qUzlVtxD4hmG02itg27amrpKpF+EEApe3Jg/xgkrZJjARCSdwONu
c52eTPN/XWRFSxv0UKQLcdhJDfcDvK9UBiZKAYt3ZI0Cglyb59zir5a/J5CE915d
zkMY1KbSPRBmeRQ729HdmsOanqa10Y9MnPZEWfZ6uxn+NzCR773jm8e4+q6V9y0H
Syrk2hQCdheHdD8TtfmnuPIZbSo3bQ+BGma/1ASucn3wmotiN7eaHQADA9msj7Lv
Jv1ozU7bJGMeiOspaSYn
=zmFu
-----END PGP SIGNATURE-----

--UBnjLfzoMQYIXCvq--
