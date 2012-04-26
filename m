Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2DZJ2h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Apr 2012 05:28:37 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39763 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750972Ab2DZJ2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Apr 2012 05:28:36 -0400
Date: Thu, 26 Apr 2012 10:28:32 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: NeilBrown <neilb@suse.de>
Cc: Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] twl-regulator: Allow CONFIG_TWL4030_ALLOW_UNSUPPORTED to
 be requested.
Message-ID: <20120426092832.GC3207@opensource.wolfsonmicro.com>
References: <20120425122924.0f08f5dc@notabene.brown>
 <20120425082417.GE3195@opensource.wolfsonmicro.com>
 <20120425195956.5b3d9c2a@notabene.brown>
 <20120425101258.GI3195@opensource.wolfsonmicro.com>
 <20120425205002.104ff358@notabene.brown>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="uh9ZiVrAOUUm9fzH"
Content-Disposition: inline
In-Reply-To: <20120425205002.104ff358@notabene.brown>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--uh9ZiVrAOUUm9fzH
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Apr 25, 2012 at 08:50:02PM +1000, NeilBrown wrote:

> So maybe something like that (completely untested as yet) ??
> (and this seems to have changed between 3.3 and 3.4 which confused me
> a bit.  But if you think this approach is OK I'll come up with something
> that is right for 3.4).

Yes, that looks reasonable.

--uh9ZiVrAOUUm9fzH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPmRU5AAoJEBus8iNuMP3dWSsP/jBAuq3hjw7/fsGFvLI2Zp3+
cnNQPi3bXsEgQW7z3aGdj8khERdN+XvpVYt9HrItvl1G2l0f8+2Xz82C3bjTXVFe
R6EPcxTmRiirNqTWLSRcf9hquxOu6vq8YSsx2HeuWwHh+xNHuAN3RQdL/O5aMFkc
TEfw+VyEVhU9+ycEtCrBEKVeeWE5HFcRZe3EiNdS/w/U1TenKNJocyu331ZPYth+
F0O94q14gmm3v9pj/mtFcw6RYR9xZkPYqMDzZN4nd3bwY/O5H8JJpQhX1T0SE6ad
gy0VdA6NnA2AjmkrxC683I84iVrQDgb4z4nykxR/czvHaDjpGnzo5m+KMD6V2gfn
zmib+JkJrQXJtxprqj4/OQccJxJsO/7JEP4vcRQmQS6OlIjDTYdQbpcn8/e7Qjwr
Vtv+YAX98S7bL9LWVDJzHDhUk4q7pqQsIZIbUVy5IbLa+tlZBD0ftxf721/S/R7o
my6rvkaFQ7Sp9z/cfEJxaC7n24yS05G1QYwYJEB0gKG0OzVcVQ82A4x4kUgMtBKh
UlndiLETffJ+y7vgtl1Y4EJcvNoo9hpJsVUiC3DyqWPckDizXOViUrnpOjvrEd1C
Oi9MWBXQrAqrsP0LTJC8AJ3+4znEnbS6tpW0KXUVJqTzbHujTvdxkk43QypxXy6k
uw96q3Wm65SKa+8C+ZfZ
=pd0h
-----END PGP SIGNATURE-----

--uh9ZiVrAOUUm9fzH--
