Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755139Ab2GQKIk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 06:08:40 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40578 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755055Ab2GQKIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 06:08:38 -0400
Date: Tue, 17 Jul 2012 11:08:36 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFT] regulator: palmas: Fix calcuating selector in
 palmas_map_voltage_smps
Message-ID: <20120717100836.GB4477@opensource.wolfsonmicro.com>
References: <1342495743.16433.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="XOIedfhf+7KOe/yw"
Content-Disposition: inline
In-Reply-To: <1342495743.16433.1.camel@phoenix>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--XOIedfhf+7KOe/yw
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Jul 17, 2012 at 11:29:03AM +0800, Axel Lin wrote:
> The logic of calculating selector in palmas_map_voltage_smps() does not match
> the logic to list voltage in palmas_list_voltage_smps().

Applied, thanks.

--XOIedfhf+7KOe/yw
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQBTmcAAoJEBus8iNuMP3dtWwP/iRS9vIKL5RrZLpRkAJ3ZE0G
j7MqMr/5pnK5t5KSs0luJKCEuP2jaHoP5rXI/K4zIUdNi28neFYdhiZWavBgwDZ1
rm6O8xhcKMaj0wuaZpODFsZ01/NUDVBJe72+NkNqh2XERTNOyycOJxxEMWvFuy6U
i6nzG6WvwG7TQJFTd/64rB/91jbE21myB5OqaIAi99GGzytbI7cdi5YexGBxLnd6
y48W9h5iIigRoCWRwASVVwC7r3QNmhX8GrQ63XGh2dzRE4Vqje797CXakHunWvCN
IxvFeEOEEHHyf/gEpnsDF+u/jyvYu0O1cnO6UxmlWn9gWU6Gh06XooNG0KeXj2xZ
I7LbI/qsxFCm9wRQzEa5gfEA4/XZjMDTIyKVJdlTNCNTDazTtCNJagCo7I0ciPm8
xhphPdu28e09jN86X9sbh/+BQ09jYU3geSXhN6BrcX+KwMV/nDeWsM3MGjbUlqpJ
uOLaYYdZcakithhuB9LECPAGDoyV+c7KRgBwxvpIcB31oj3Zt+Hv/djubCYKP7BD
YZJCOTaPU/dGdC22C05RpSEUe9HnJW7XT8aVkjmD9XcXz+9ptkfj9EV3Dh3Iqqko
p+zUUv64/lAoYYLknmN2CMCbAUO/GlEmZhI+7Z7/z5Dajh19cxdepfJfDEacEGPq
78VtmQgtrEjD7kzsQhzz
=0XvY
-----END PGP SIGNATURE-----

--XOIedfhf+7KOe/yw--
