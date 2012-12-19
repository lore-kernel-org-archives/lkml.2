Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754105Ab2LSLCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 06:02:48 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40519 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751155Ab2LSLCl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 06:02:41 -0500
Date: Wed, 19 Dec 2012 11:02:38 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Luciano Coelho <coelho@ti.com>, Felipe Balbi <balbi@ti.com>,
        svenkatr@ti.com, linux-omap@vger.kernel.org, linux-mmc@vger.kernel.org,
        cjb@laptop.org, lrg@ti.com, linux-kernel@vger.kernel.org,
        Tony Lindgren <tony@atomide.com>
Subject: Re: 32kHz clock removal causes problems omap_hsmmc
Message-ID: <20121219110238.GR4985@opensource.wolfsonmicro.com>
References: <1352968293.10872.51.camel@cumari.coelho.fi>
 <20121218095450.GB27751@arwen.pp.htv.fi>
 <20121219094552.GN4985@opensource.wolfsonmicro.com>
 <50D19040.5090404@ti.com>
 <20121219100909.GO4985@opensource.wolfsonmicro.com>
 <50D19463.5010605@ti.com>
 <20121219103206.GQ4985@opensource.wolfsonmicro.com>
 <1355913954.5273.21.camel@cumari.coelho.fi>
 <50D19D54.2000307@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Eu9PQ+LfZADlAtIa"
Content-Disposition: inline
In-Reply-To: <50D19D54.2000307@ti.com>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Eu9PQ+LfZADlAtIa
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Dec 19, 2012 at 11:56:20AM +0100, Peter Ujfalusi wrote:
> On 12/19/2012 11:45 AM, Luciano Coelho wrote:

> > 0e8e5c34 "regulator: twl: Remove references to 32kHz clock from DT bindings"
> > e76ab829 "regulator: twl: Remove references to the twl4030 regulator"
> > 029dd3ce "regulator: twl: Remove another unused variable warning"

> Yeah. 32k clock is not provided by twl.

If these changes do anything to the platform I'd expect them to be
leaving the clock enabled instead of disabling it...

--Eu9PQ+LfZADlAtIa
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQ0Z67AAoJELSic+t+oim9nGIP/0oQthRcZh2KwkYuYG+10FYl
rlKAIZcpZAH/Eat+eJXM/gmfQC7Z3UvbxRH/o5I3GPiKn1Dk1UgcURA+3D4vzi+P
FRFba8/my/4uPZcd7JOM/17NJbOD5I3TA0VB20/Yr+psa6JJZLmToYmUsibLpu2D
14r0NInaNg023GCCSoESg3vl9ZILdFsR8wpqKnVKuAo0Qt3h3xNOkKJSmzxk8tzN
rOda1ZuN3apCBhGw3RN8hJG50Skvr6IGkkkihB8ACNfnx+odLgArDFaa73fSQ9Yn
+x+CyzSyoEcGC7zgPHdgK5SxAQBSfc75hTxaZ7lh/pot9TGFmSQyVivcGZ6u7u+Q
DTYEYCVIoaZVYRNLAS+aLyLRCq72FiQdrB8TKOyucnFy0W2/K3E6zICJAvnbt163
ru7uz+3uu3l6ZVIxFzZTfyfbmvpabQHCNtOyyXtgielpGvXfmRJ3LsL+HxUhIvVr
/Ap7hMNCweqZmjbaq6wsQKpXbDFQnFKY4zzwwKTfS3vqwaR82cvggvCB+stElGH5
H/R2CR7wu+UOdAeqP/pV4CNgworm0kxLAAIwKmrDB7Vx5hKi/AuoS1NkRTb0PdWm
p+9Zu6jbeGXFYDq8LE3ocoS2/Wm8P2CCZCFMRDuOSbJU5Z8rGXKBHHravAirQ/XU
0hNjmBNfPyXddCvTS+dZ
=SW/c
-----END PGP SIGNATURE-----

--Eu9PQ+LfZADlAtIa--
