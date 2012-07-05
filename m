Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756517Ab2GEOA5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 10:00:57 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:47448 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751151Ab2GEOA4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 10:00:56 -0400
Date: Thu, 5 Jul 2012 15:00:53 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: Vinod Koul <vinod.koul@intel.com>, Magnus Damm <magnus.damm@gmail.com>,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/7 v2] ASoC: siu: don't use DMA device for channel
 filtering
Message-ID: <20120705140053.GL4111@opensource.wolfsonmicro.com>
References: <1341484183-10757-1-git-send-email-g.liakhovetski@gmx.de>
 <1341484183-10757-3-git-send-email-g.liakhovetski@gmx.de>
 <20120705120826.GU4111@opensource.wolfsonmicro.com>
 <Pine.LNX.4.64.1207051549010.30191@axis700.grange>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="gphVtybrzJJtG9bX"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1207051549010.30191@axis700.grange>
X-Cookie: You're at the end of the road again.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--gphVtybrzJJtG9bX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 05, 2012 at 03:54:30PM +0200, Guennadi Liakhovetski wrote:
> On Thu, 5 Jul 2012, Mark Brown wrote:

> > This doesn't apply, please regenerate against current code.

> Sure, as I mentioned in my description mail: "This patch series goes on=
=20
> top of my earlier patches to split shdma.c." And that patch series, also=
=20
> available at

Ah, right.  You didn't send me your cover mail, you only CCed me on the
individual patch, so I hadn't seen this.

--gphVtybrzJJtG9bX
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP9Z22AAoJEBus8iNuMP3dACMQAICxFxX/kxjlIMOANkmNywBx
Eari9Bxtu4RSK1+XeKM4qYtYTeC9nifv+3owtj3h95kCHXVy2C6Dul6rDboCDCaw
c6kxEUmpHwcMmlzYN21dkTVca07u7bznLRpqsfGKnfz2TxF9fB/M3vSY1zZX1ECj
tbdmFOSHggZl3d7XT+qOTnb/0hzKkKEnhmwl0OEdVEZYpP8xfQCE9DiVhzwnQwrn
SodGEQMOcZguvlpxd0Nh6kuifZmqbI3/BEd5ZisF54SeOrvchUSigZynLFIJtg0g
FsZLMNU7GKGliD8l5alBiNOZmtauzsbROrdOrdVq8hdGwd4nmrhtCY7/5M7v2ew6
OHKVUjVJHwQnMcZ2/uLaasRmsCXe1Rq5r3zFq9IXrNNmjfzijcjR53PlJcXoHL94
Y6JGbHsHe5xYIguNXqA3UQm5cNV3bDghvTwuK5HA0SQ7YU/9VNM1mj5b4bSMoZ0t
pEdC/ng6peYDDKGaEhy75+YP1KcOe39q4b1/7qKLjkPo554jg94xg+wuOtkrR3AV
4lu1yrITUkOj/QTgYD5qO8jGRgFGhDWeCZN3lCA5R02dBIXUFBPwwXJzGQC8c6iv
4o1iSug0C6VF/a+WNO4G9rLOadlYcQoigBWvU1Pb7nDfXOl/sS/JB4WT6/vxbNbb
In64jWuQ0OlR5HINqVnd
=3az+
-----END PGP SIGNATURE-----

--gphVtybrzJJtG9bX--
