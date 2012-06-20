Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756181Ab2FTKS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:18:27 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58592 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752532Ab2FTKS0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:18:26 -0400
Date: Wed, 20 Jun 2012 11:18:24 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Yadwinder Singh Brar <yadi.brar01@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Jonghwa Lee <jonghwa3.lee@samsung.com>,
        Myungjoo Ham <myungjoo.ham@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Chiwoong Byun <woong.byun@samsung.com>, Axel Lin <axel.lin@gmail.com>,
        Yadwinder Singh Brar <yadi.brar@samsung.com>
Subject: Re: [PATCH v2] regulator: max77686: Implement .set_ramp_delay()
 callback.
Message-ID: <20120620101824.GG3978@opensource.wolfsonmicro.com>
References: <1340169651-7844-1-git-send-email-yadi.brar@samsung.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="PyMzGVE0NRonI6bs"
Content-Disposition: inline
In-Reply-To: <1340169651-7844-1-git-send-email-yadi.brar@samsung.com>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--PyMzGVE0NRonI6bs
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 10:50:51AM +0530, Yadwinder Singh Brar wrote:
> This patch implements the .set_ramp_delay callback to set the ramp_delay on
> hardware for BUCK2/3/4 if ramp_delay is set in regulator constraints.

Applied, thanks.  It does seem reasonable to set the fastest ramp if the
ramp rate requested is over the maximum rate suported.

> This patch also do some cleaning work for unrequired members of
> struct max77686_data.

As Myungjoo said this really should have been split into a separate
patch, please don't do this in future.  One patch per change.

--PyMzGVE0NRonI6bs
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4aNpAAoJEBus8iNuMP3dVZ8QAJwyjQ9DBtWJxL4i2pw+YVXN
zOrgc/+a23/Rjt30Wx0jz6B8fplVjLY79+1MzLRsS+eRqmAYc+mjSBq3AX6aJaip
IIly1MBFdy5RI/sDCn+QFcwB1mla0hr+PMcfHz78H3sgrrpikrOosWnmyexyqSR2
2YQms/X6JDS3vqqieZdDkSDLOwdsvJnhrPRnIjBWPf6PF8yOAjbLLck18yrAIBnM
R67rUeUTky/O9aM9eWmGHfTs9hJrOWV8BEa2aSAKK03Kx1Ic56VAfjY7h89nqDPZ
qAubeR72pu0j/ArENmsxPNSgRUtLke0n1SuNz9jW24qklRXyMYB+LfVvLrHmeqLT
dMZUfrrGoZXkLVKLYXoomQdLdl7F1rMtlR1UAIa1W2km06NjqtVKcyqmnYyhO6bg
/QZPGGF7DCvVel5k0Px68Yd3SZawoi/L9WkC9iaSNmQDcd5m/L0aadybakSTl5Gy
D75TMDRKIDO27pnebbaEAQ/VXYx4Ldu8HQYk2c2CFkCLbK2hg6PwR1sa1rcK5L5C
orU6SxWDX10QsWKP21QR5CPML5xJ6g9fAsthroWx92IhzB48INd2EnPxQ+SBStw2
ZUiQidWNjz726LDMEp33aGZsN3gYs1GznTs05vOsHiDHn4IUxeg6+ipjH/oVtHJ7
uk+ZgQVHk8/9mqavC99y
=aZed
-----END PGP SIGNATURE-----

--PyMzGVE0NRonI6bs--
