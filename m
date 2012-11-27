Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756533Ab2K0UXZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 15:23:25 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:60438 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756190Ab2K0UXY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 15:23:24 -0500
Date: Tue, 27 Nov 2012 20:23:23 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: da9052: Ensure setting current limit within
 specific range
Message-ID: <20121127202322.GE32691@opensource.wolfsonmicro.com>
References: <1353914618.11550.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BZaMRJmqxGScZ8Mx"
Content-Disposition: inline
In-Reply-To: <1353914618.11550.1.camel@phoenix>
X-Cookie: Your ignorance cramps my conversation.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BZaMRJmqxGScZ8Mx
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Mon, Nov 26, 2012 at 03:23:38PM +0800, Axel Lin wrote:
> Checking da9052_current_limits[row][i] <= max_uA is not enough, it is possible
> da9052_current_limits[row][i] may less than the requested min_uA.

Applied, thanks.

--BZaMRJmqxGScZ8Mx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQtSE0AAoJELSic+t+oim9l3UP/ROa/exHxEv55ZM9M3KPXLns
zS+72bL1Wpg8JMMS/paAtCjW/TKHg/8VksN7uEtBwqRPMGnLBtIRRl9GPHSut+/V
yJMYT6a3xsMI5suZbHMJ/Ro+psYHHoFDc5O4A4YvN64skLNCJw/F+wzPOLF10xeo
6+SgJY084uCpwn8HfRILJzN5uW3QoKoDYx36t/wa8L5VRSSoxeF/wdXQi3yQvwLU
6AlKAGLQuecHmc2uyZD6Fh1qTa6G+z0jXPVa1cfXX0Nc8KCWd6TwF5LHG/4bBlzr
RGU45ZfNBwlKeeZKA7m61O/86OFAXI57TQTvTdgSVS4IPl/i5DvNRtCnmT82a+19
4fMH1dHg2EYINJx6CsDx4Z3Lcf2T+LmzET4DY3Bhg5lcf65FPpOSpQ5RPkMMR9i7
nzI+kQqVrIGGAgpEShe8HE9thW21y+FTO/4KfWjmT90K+SSTp6Ir83Ib4b6VEXdY
1T1FZ3xvfXvnm2aY0StHt4bhSv05tExquP0c5bhbLRjAkFpFc98SkrHEmLiI7xYa
HmZb74M5CBqoEMEpHAdpJu6cQmnel9VF7RTuE+/WffIXxlPkUbVc7uqZKIY+UT61
RoCfYpj6Kz3oCIRtbwJ/xDTe/OTGPa+KEGdoIvntp+UToVZ93E0XnZnNQPAwA2u3
pMagilCpXXCVuUC1WNMI
=qw9W
-----END PGP SIGNATURE-----

--BZaMRJmqxGScZ8Mx--
