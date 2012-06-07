Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758882Ab2FHAw6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jun 2012 20:52:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:37428 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752911Ab2FHAw5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jun 2012 20:52:57 -0400
Date: Fri, 8 Jun 2012 07:28:48 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Laxman Dewangan <ldewangan@nvidia.com>,
        Liam Girdwood <lrg@ti.com>
Message-ID: <20120607232847.GP14525@opensource.wolfsonmicro.com>
References: <1339058289.5274.0.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="IihjUyvzd0n5Ehsu"
Content-Disposition: inline
In-Reply-To: <1339058289.5274.0.camel@phoenix>
X-Cookie: Long life is in store for you.
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 116.228.53.169
X-SA-Exim-Mail-From: broonie@opensource.wolfsonmicro.com
Subject: Re: [PATCH] regulator: rc5t583: Simplify
 rc5t583_set_voltage_time_sel implementation
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on cassiel.sirena.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--IihjUyvzd0n5Ehsu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jun 07, 2012 at 04:38:09PM +0800, Axel Lin wrote:
> For linear mappings, we can use below equation to get the voltage difference
> between new_selector and old_selector:

Applied, thanks.

--IihjUyvzd0n5Ehsu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP0TkpAAoJEBus8iNuMP3dEUIP/19q0OiXyhgk21e09pbQiNSL
QI+BYEWyo7+xrmChm0wzQ9L72IfArBQ6zdkKMW1FOS4ksquhRUQwPyXOoqaxOCge
pKKKqJLj8zI8Plpnyy7416pLEw58T1xJVAzRn/0H8A6W67bFxbSp7dNyCDcPxJyc
V1SPz7LmpnHxHKcmu7ZqsKn0P/c5rKez4G6QqUn+lBr1G7xur6I6WYwazqgZHKI/
24UgnB7eRFxPRM2wjaTq+xOvMDjgp4ZCAPVwBVGtaU907FDZdXZOB2/k9rXJ8q9p
9zXyXcar87wYQFZAXwVs1EwUwZcgvxoz2bVU7ny/idwJbCHcdl0WGVmeB7keQPrq
2Vb4FQifu8fVWOLD5G9MN4ZjC+K83LNtqyb6dx/sBeAmGJJ0rWL78NXnSqDnYcfH
TzBDcEnBop9EXcKEr5awfAR8BxkPVEuNQ4Z/cE7j1uyVCqay/gqSMR8bK8FElInb
ereYRmQUJv9xrB1y2Yndp0AsV+ZTez6fx1AYk84/7lwtI4jMR0CeAy4UgGG4Pr8J
Tm4Bj8qBR851dIdVR7bG5qoDeaTZKHaeI5ysUvMeeR52886x+360Nds2SqfJzV/V
jwW1HdMxltwAI8inj52CVmOC3g5qQvLIqUaFhLZZa6WhJtK0eIL3FmUnn7ouwnH/
dtfCSfJTAmBHc63kjXu8
=YBcX
-----END PGP SIGNATURE-----

--IihjUyvzd0n5Ehsu--
