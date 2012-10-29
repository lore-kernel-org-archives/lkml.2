Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759777Ab2J2QOA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 12:14:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42815 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752348Ab2J2QN6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 12:13:58 -0400
Date: Mon, 29 Oct 2012 16:13:56 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [Q] .readable_reg() not verified during read?
Message-ID: <20121029161356.GD4511@opensource.wolfsonmicro.com>
References: <Pine.LNX.4.64.1210280034310.4378@axis700.grange>
 <20121028180629.GB4547@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1210290833440.17869@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="a2FkP9tdjPU2nyhF"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1210290833440.17869@axis700.grange>
X-Cookie: You will never know hunger.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--a2FkP9tdjPU2nyhF
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Oct 29, 2012 at 08:40:55AM +0100, Guennadi Liakhovetski wrote:
> On Sun, 28 Oct 2012, Mark Brown wrote:

> > No real reason, though to be honest it's not that important - the main
> > reason for having the function is to make the debugfs stuff work nicely
> > rather than anything else.

> But what about initialising the register cache in regcache_hw_init()?=20
> Doesn't it read in all registers without checking their readability?

I don't know if anyone's actually using that to be honest, I don't on
any of my systems, and in any case most hardware is implemented to allow
reads on undocumented registers so probably it'll do something
reasonable even if it's not doing quite what you'd expect.

--a2FkP9tdjPU2nyhF
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQjqsxAAoJELSic+t+oim9/WsQAIw8XcfwXz1tSTpa6/2UXkQl
cAzpkqH4X0wpOKKKHMWuNqUOiWDPFjpiQ1OYGpurXUpzBkuielMpjBQVHGkqKGea
nEWSydKcRBlO2E7CFzRimgl9jBSjImdzSy4/W+f+/9wqkD5lkCu6C+6zPb+M5nv1
L7q5DReMNQwc/GsA2jPx47ep+aTKkQp0pc1t8S9/ziUMz7ZvhU8mG0t1XWLVSRTJ
H8pXfzjnRlCqNgWeyGhvrVTNUbkall1hB5EKeq7rO/qCSijXyiOZL5+b2dKrn2qf
vjV/81bIeFrv/IKrmXJDZtJwgls72ww9jmx/CxvP0EOCPqfXL0xkHByJoJFTje8n
K8TFwfGWhSd7HjtGc0ddlml9/498Frjk3GWAykn2/QLeOXrsXoaSiFRfIZOPcABF
1FK0eRn0bJOdozRE5tjhoxGEBR8zEhkJMI1E7BUzywJR/MNkw/eFob0GVWQJjBwR
uhJTvDAez2GHo84+kwWUcWSwHmpiBLjcbm6Su5brUQjnVCFbx8dyaueWrvr/7JqA
7FuaP0lzGHeRGxWWWhikHnQnDW4rgLtTmcxQQKO13ZuB/z4Zm/feeEJGscbllKFP
jdu4446T2fbdbXvDDmsWRnJ+HlShk9MaZkOrS2atLnLnF91e4ktjNJAWdhTKaV6Z
9ye5J3rPPIS89lBWH6Pq
=jQXq
-----END PGP SIGNATURE-----

--a2FkP9tdjPU2nyhF--
