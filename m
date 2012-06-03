Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2FCTK7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 15:10:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:35173 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754131Ab2FCTK6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 15:10:58 -0400
Date: Sun, 3 Jun 2012 20:10:55 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Chiwoong Byun <woong.byun@samsung.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: max77686: Use regulator_map_voltage_linear
 for simple linear mappings
Message-ID: <20120603191055.GB26676@opensource.wolfsonmicro.com>
References: <1338734774.21662.2.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="yNb1oOkm5a9FJOVX"
Content-Disposition: inline
In-Reply-To: <1338734774.21662.2.camel@phoenix>
X-Cookie: You are number 6!  Who is number one?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--yNb1oOkm5a9FJOVX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sun, Jun 03, 2012 at 10:46:14PM +0800, Axel Lin wrote:
> Both max77686_ops and max77686_buck_dvs_ops use simple linear voltage maps.
> Thus use regulator_map_voltage_linear is more efficient than using the defult
> regulator_map_voltage_iterate.

I've applied this and your other patch but really what should happen
here is that the default should get smarter and use map_voltage_linear()
if list_voltage_linear() is in use and nothing is set.

--yNb1oOkm5a9FJOVX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPy7aXAAoJEBus8iNuMP3dR9gP/RfozEx9wb20M2wBo3NfdxAF
WhHKssjm5h46fJAk+iR8ie4YpeLQT3tRh49PmPyGbQoTXEtUn00J9hCU2JBJyNoi
Qb9xMdUvSr9RaLKTY9cW0LPda9bfNnO0atR1PRsBs4xs8Cst9UODXkuWppxsTqSw
UeaItDAO5IIWwMCDVKWj236OF1g7SnVtN1My0RaZn6r/dHX6tspLea1F/nzz1K4Z
aF+AhqjG1sH/Ej6RyyyUTTofJX0JZaY+RCNrzFqN/Z8Yyxt2koK78Ucr2MExw8ol
wMHuNvvlgHwhUiKKcIMqc/T6FUacemZOe4293h1ZzsGZCZSjSdaRlOubrpCdi+rh
1hMmQRnznOUvOP3x26rtStsUhGj8bVoC0cMBPR4702PcQ4nm9tNDpZB9UHbuSnos
mmD3wEBbWlLQxz/KFtxuq5gQfTwHD9Rg6UmyIADSDn1rjOFV4nTByqrs9uQNeuRv
cjULhsUdVWhykxkEqwMjJJtpuQL6sS8B+7VDV38+y7NkJMCPXr+CluzqUpWQOEV1
EqPvvXm+VDP/C7eeUNoOMq6KGb8kthUTa54rkGIs0W0UVVIqVUEQRK81Up/gBfeS
x7Q2w2JhgzG+J4A7p9VE6/FIlUEIH7PwALdM03HGdAY9guqAjiu7eBFX/Q0kj/YX
M8ZYdPCDU7BUX/cHmoeQ
=fJn1
-----END PGP SIGNATURE-----

--yNb1oOkm5a9FJOVX--
