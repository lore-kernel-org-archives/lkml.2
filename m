Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030509Ab2CFMRO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 07:17:14 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37942 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1030439Ab2CFMRM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 07:17:12 -0500
Date: Tue, 6 Mar 2012 12:17:11 +0000
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, AnilKumar Ch <anilkumar@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH 1/2] regulator: tps65217: Use DIV_ROUND_UP macro to
 calculate selector
Message-ID: <20120306121709.GA24091@opensource.wolfsonmicro.com>
References: <1330998862.3708.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="2fHTh5uZTiUOsy+g"
Content-Disposition: inline
In-Reply-To: <1330998862.3708.1.camel@phoenix>
X-Cookie: Give him an evasive answer.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--2fHTh5uZTiUOsy+g
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Tue, Mar 06, 2012 at 09:54:22AM +0800, Axel Lin wrote:
> Use DIV_ROUND_UP macro for better readability.

Applied both, thanks.

--2fHTh5uZTiUOsy+g
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIbBAEBAgAGBQJPVgA/AAoJEBus8iNuMP3dZ90P+JrotoEVI45LvXF4jyIfXQ0W
UYvQyix5b0m5002om/DQXAaDj89pRQlKhHw38i5udUep0cBXhJMrcmSg/GOk7Esv
EHvJVJXV7H2eLg251DlKJ+rwKYgR81hr8vUWtgc0gymZ41amLn0+iqqLdLF6OhUd
ncWCMzMgraR/ek3/EwnCwzFNMWWvADzDz6YYvK3ZQ609X/WYrXhGBa66u8yQPjnu
e+3bvIziYCroCsh012JJ8wsL2oO/+jgLJZHvPvFr2NZaCeyTkCykmzPVIpY/TEa/
3RU2tA+MqHZ1ofx7PfpYT5OwkKnp7npZwj7ugRt3JktW1xjW+IpwRTZ4MPF6dfI8
Mwj+ikW4o4WMjTi/QQZnb7BH9EOFmYQ+f/oxbREmb7d8ndVURmXHkv5rEpS99jdp
guSABARQ2IkvTUiURdIjPyXoML1D6x8oW2Z0ZmjN2acRZB5NIg8awW0ldS03VfXY
R2bOIGrcSEoM1IRcYyQ1qJmReOkTcNrcbH8nV0qNano4ca3U4f3B4WxuR6+8bl2O
xxEY4ZgD8m7unqLUtH7G/Yna0RHFLMcnSDBRyCcYnYEqer1g7hIRe192n374/htb
E/FARuForM+Klh4ItRYcr/rGdNcUcOJ2Nhlk+XVGzrIW2ZB7ebUtWCaisQtRIloX
xn6YajRmhIhAWC5BZ6k=
=fTt0
-----END PGP SIGNATURE-----

--2fHTh5uZTiUOsy+g--
