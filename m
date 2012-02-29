Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966158Ab2B2XWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 18:22:39 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36082 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756999Ab2B2XWg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 18:22:36 -0500
Date: Wed, 29 Feb 2012 23:22:32 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC] regulator: Fix the logic of
 s5m8767_set_voltage_time_sel
Message-ID: <20120229232232.GC8295@opensource.wolfsonmicro.com>
References: <1330066365.21167.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="DIOMP1UsTsWJauNi"
Content-Disposition: inline
In-Reply-To: <1330066365.21167.1.camel@phoenix>
X-Cookie: Beware of Bigfoot!
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--DIOMP1UsTsWJauNi
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Fri, Feb 24, 2012 at 02:52:45PM +0800, Axel Lin wrote:
> This patch includes below fixes:
> 1. The mask variable is not used at all here, remove it.
> 2. We already have the new_sel and old_sel, simply returns the delay by:
>   DIV_ROUND_UP(desc->step * (new_sel - old_sel), s5m8767->ramp_delay);

Applied, thanks.

--DIOMP1UsTsWJauNi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTrMyAAoJEBus8iNuMP3d3w0QAIGKHcp14eqChD1Es4uNmvED
ezanqPpJMkY9k52KguIwo906HN/1OUJpseC/5awMZTw+55kZh4qG7Ewn6YfKdg2p
5yjvqiIIIH7Ubg2tj3BuI6+Kd5Mu/A+KoNXpOnhxC25NYdfKeVWNS8hSyU4rzOEy
oWsCx1rVpe2ba3xg01VVResrtFB0kz1FrCEgJwfaphm9RbUIfmAojvREq2hRTHfT
596AgXhqvXUmQIBHSdcAPXSYOcpqyknlqEkjasUsNuOnIBiFsqR3fq+dYTtMhfPa
5AErO50fQTNwJfnveTg3sNaSieqmH5N3Y2jqJQKkifVOCaZDsVtRWI4qK1N6fXYN
AsbBb/eVu673IHKPR830JcrsK1oku93lzapwqTmur1T2bmr/Y33REXhXigiMqn8h
CP1wgTjzivFqpe/GC9+Ph5RbJP1pKmMACeFhMM3v3vclBS4hBB0NdY2g6Fzsk7/B
YPg9je7iaOKrn7QSrG4KUz/A86H4MODDgCaFPVn4eUrAJaTnRRJ7lPQcpiZsZhqD
CLvY89VsHoFrDB5EiKhjEsoYrGon45f4bsApeK66EyV2Gm5TkR5Ae3DYoZxiE8WT
2UZUk7aooGjEqQ9CHLQGBDMdlG2dIKA9Cw39QUA3VwvusAfTvnH228ccTsOv0ACZ
RaQgeizDKkFrMO0ggT2E
=usYK
-----END PGP SIGNATURE-----

--DIOMP1UsTsWJauNi--
