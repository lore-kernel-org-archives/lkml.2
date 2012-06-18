Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752560Ab2FRJls (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:41:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49332 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751765Ab2FRJlr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:41:47 -0400
Date: Mon, 18 Jun 2012 10:41:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: extend the fixed voltage regulator to accept
 voltage
Message-ID: <20120618094145.GC3974@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="JgQwtEuHJzHdouWu"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1206181017360.23884@axis700.grange>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--JgQwtEuHJzHdouWu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 10:19:42AM +0200, Guennadi Liakhovetski wrote:

> +#define FIXED_BASE "fixed-dummy"
> +#define FIXED_NAME FIXED_BASE "-00"
> +
>  struct fixed_regulator_data {
>  	struct fixed_voltage_config cfg;
>  	struct regulator_init_data init_data;
>  	struct platform_device pdev;
> +	char name[sizeof(FIXED_NAME)];

So, this looks pretty ugly and doesn't seem terribly directly related to
supplying a voltage parameter.  Please split it out into a separate
change.

--JgQwtEuHJzHdouWu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3ve1AAoJEBus8iNuMP3drGIP/16wiez7d03in+HSeECq8ftD
UqaivBQ6fqdtHvhGnN7WEavnwjtxGkJxe0BWycxOu2b2eE1f5T14X5inVno1KXvm
SzMNmrnu+KoUHRRbFcarwo/nYICrwV0MGABNq1FrZJ3cyqOiuywQDqkgF+Sb7xDw
EBFtGPFY/xmfkVKW8XBJ3Q8qGTMQ1uq6CdseJ7//kSiC4Kmu5qEBCTSS0Ba0Am2s
A+KiLJN6IFMFAIHMZ0Ep3Q3p1Oue9IJ/mXHaQ/jaULwR40AtCrZPENZdhL3qF5Yr
21c6pScGUoVZQ/LLsQR3gJN7XqT0VqucIjg9pYler4jq389ba2jcsg/dVUP9NUNX
/4eZ8oIrtb4boJ6uZVQp/BFr97svvIf2EXwh5PvgQSFNazSj9rVo01ANiWAu8EGF
kirVJoC+v0lhAaDCVRkt401ilxDoTzAcyKpqzTXOZhc+HdMpOQtdCl/tUyNox4sV
3ZOMcvjOH1Bme/xYHzWNS2AxRh1yw3ueJ7gnJ5vbwjz5Eod7AnDLAfItYsg6dqFu
GoBLcQ5ac96HWyxJ5w6rO7QsncxBHbYsgXFRHMnQ4h2GJL7qfpXfYS7fG+h9DrPl
bIuPt735ZVXp3raU4o0cJzuXwsx8TCWRUy/wLxnFvrSN87OUjyWWX9lQQAT3+BeO
qOCL6mvKWUitpolmNhwz
=aqDe
-----END PGP SIGNATURE-----

--JgQwtEuHJzHdouWu--
