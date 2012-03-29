Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759082Ab2C2LKi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 07:10:38 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52208 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751479Ab2C2LKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 07:10:32 -0400
Date: Thu, 29 Mar 2012 12:10:31 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: Fix setting low power mode for wm831x aldo
Message-ID: <20120329111030.GI3668@opensource.wolfsonmicro.com>
References: <1333004575.8548.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FK65GREB+Evh/hTL"
Content-Disposition: inline
In-Reply-To: <1333004575.8548.1.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FK65GREB+Evh/hTL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Mar 29, 2012 at 03:02:55PM +0800, Axel Lin wrote:
> Set BIT[8] of LDO7 ON Control mode for low power mode.

Applied both, thanks.

--FK65GREB+Evh/hTL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPdEMgAAoJEBus8iNuMP3dKBMP/RlOnEpoG/reBmom0/oMHvhC
7b+VW8il4+46dmlMlu09ReoRlUcq/X+d2bE8eeeEiB6jIS14H0nO7ZGIqCY0xtZy
RJQfrB2kMWaF3AYyx54fbDGOmjs6yF51QguzfvYisB+Q+gjdLp6hjbyAKMF0nY5D
gMTXIx40oLUUQIvqhaqZUluMNKzPhQt0p1H0ifAhcOwYb88JOvgNbu2xoqSK/Al0
Rd3m4cCBB1UqyYVVtctCsug8oEuBb5dMJURorsqsAr4T7LuRntKM7OgENgiV0wXp
mzRouU0G1rfVl4COV50+g8lNE9Vsa+WdVGhmsh8qhp8o8GBZ4IeymKSOdy336C3d
ccEwoHQO0AHbRxk/j24xIfZV1odlTTQeO4aKHM1sE23uemXZp4MoFyNPUiJcdV7a
AEegJLoY5+nwB9t3CWGCavvdyF3YbZaR5M6gfEXmORPqZjy4jBzhm42Z1k6uizrY
LkUyPi9uEsSIEME1PLF9ptt26i5W+mbax6buJIv378FQe78bfQQePXAGONfJuLqK
xv3Lcg8P1s3HnieY7so7bdFn/F5jNKpkwf03Aw5xWGE5FCF925aYG+VPRCMX9JER
CrRFWo6mW5tKvHfTebdpj+c7ZhjrpDd2WVF5ctFKbHZpsvpHj5AZl4mxLnwvPWhC
9KanchNdnWUGHlpuBe9K
=d1h3
-----END PGP SIGNATURE-----

--FK65GREB+Evh/hTL--
