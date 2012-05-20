Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756809Ab2ETVtC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 May 2012 17:49:02 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:45605 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752328Ab2ETVtA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 May 2012 17:49:00 -0400
Date: Sun, 20 May 2012 22:48:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@ti.com>, Anuj Aggarwal <anuj.aggarwal@ti.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>
Subject: Re: [PATCH RFC/RFT 1/7] regulator: core: Allow drivers to set
 voltage mapping table in regulator_desc
Message-ID: <20120520214853.GE9337@opensource.wolfsonmicro.com>
References: <1337481021.7204.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BQPnanjtCNWHyqYD"
Content-Disposition: inline
In-Reply-To: <1337481021.7204.1.camel@phoenix>
X-Cookie: Chess tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BQPnanjtCNWHyqYD
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, May 20, 2012 at 10:30:21AM +0800, Axel Lin wrote:
> Some regulator hardware use table based mapping can set volt_table in
> regulator_desc and use regulator_list_voltage_table() for their list_voltage
> callback.

Applied all, thanks!

--BQPnanjtCNWHyqYD
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPuWa+AAoJEBus8iNuMP3dKKkP/0Pl+nzEaUKiURw13MIbSSON
pPmGM45tghl4yj2aavn9yRQWNaQRUU4Plul0XfiZVKbzYik6ahVUg4CC428pk1hK
0zz5RRaLXhfrEAyLvwS2657Z3mtBzhgSFa4xQxLW85dQjK9UUVIizLmLFHZkhGpN
8lv/gUOOevozOmtYX2RvxM+At5vMV6kxOpguLzFbxKR+nF5sjVqMJHIZx1wzHXaQ
Iwch4OxRe0ACd/Zc2NAGYpS0ycnrQojZu0FMzSIrrd3mTP8aaGgVlYE02JacgwCP
r2voA49j5Mf6BboE5GdLm+4/zIJutjGQfTPe5mlIAMp64VeibZROeGjqiQZJZnLO
zaDCZd9wTsax2odDgz9i8r4t8v5Y4CcvOLkNmWxzCl2tjwxXj6CCX00ouItSuE1+
a6HQvbUzQH4xyZdHrOFy8cC1rF9EQw+gb+PQ5ArSgjsYl8gKADEyTvga1Z28PGaM
R+gmiv3x2FqEhL9aHurXOX6BukGBOYBrwz5bTJZ6dzBcC63dUzCp6/SYH3n5MJE7
+tfu8AAlPfCEdQ4PIfzGiXMW0Rov0yiT3tNc2LO2VxsKy967Z5qUR/3fqwCnhF3K
C6fl0CZwZ7gDJfNj23SXogsW9oyay/AM9yvCXspTuFQI53FRqsZfVGiMFXbiCuj2
YUv5SzzmKowxYsPRktDC
=FrUj
-----END PGP SIGNATURE-----

--BQPnanjtCNWHyqYD--
