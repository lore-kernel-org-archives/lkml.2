Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752728Ab2FRJ6q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 05:58:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56203 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751496Ab2FRJ6o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 05:58:44 -0400
Date: Mon, 18 Jun 2012 10:58:42 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Yadwinder Singh Brar <yadi.brar01@gmail.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH RFC] regulator: core: Support table based mapping in
 regulator_set_voltage_time_sel
Message-ID: <20120618095842.GF3974@opensource.wolfsonmicro.com>
References: <1339985488.11918.3.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="7mxbaLlpDEyR1+x6"
Content-Disposition: inline
In-Reply-To: <1339985488.11918.3.camel@phoenix>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--7mxbaLlpDEyR1+x6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Jun 18, 2012 at 10:11:28AM +0800, Axel Lin wrote:
> For table based mapping, we can calculate voltage difference by below equation:
> abs(rdev->desc->volt_table[new_selector] - rdev->desc->volt_table[old_selector])

I've applied this since it's incrementally an improvement but really the
fix here should be to just do this in terms of list_voltage() - call
that on the two selectors and then do the multiplication.

--7mxbaLlpDEyR1+x6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP3vuyAAoJEBus8iNuMP3d3psP/RV4Qso8D+RYq0nKsWCAGP9I
BDpIUjWENFA4yRwKCFBV4HCFK5uC9JSWVxB70leasWNF3aZJW7GqZLOiisM1I1Bu
4qvG+h30dcih9MSkAnBR+t42otlDlvsl73bUtsq4ojbhy+cyUWTFW81ZiciAwt/6
utMyYxPkP4vA3IoHBBDY3IkB9jYSEK8+rub4oiLvlgQrVxyfaDosliSFF7HOWVmG
guAekfy8YUqmi/iNQnxALZowSfBe8AiUjYYm8cfiDmlT/KPnnzz5e6kBxw9HChFp
R3iP8C7vXqO1OeWmT+wQ1dVed2dgiXDsSlLCQFgaeGwL/CNRdc4xXghLPiIs5Mvx
0EvCr/IFdd55BnKVxiODfDyLONklGJR3C8DdwXZejULT5JTGOuOoFszjHqmmEG2h
k4rko9xl0tc+9rbqEknTb3H2z6Pi4CJq10pXKDnszVupoinpYpPpSBKjo36kNQbF
X0MrjJP9Pgkp3Pcy54C6y+IJyz04Nwqhq/9xv8hL6BEpHl6Ct0MCYSm5NHfaFju3
t45heUMlFlBrY4Z9IAL+Czkj+Gp95m3uQKeVaWLAkHNoqwaXql3z2SvK2zBiQyQ+
/h3z+cPXlyUVd1vDR5LPcMNDu8eUPOjNuuEuf5nBndQD4RV9KIAGmXvEAxemAGIF
2RmCWcjk1h8V8Kh21SXi
=/FSo
-----END PGP SIGNATURE-----

--7mxbaLlpDEyR1+x6--
