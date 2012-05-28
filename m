Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754099Ab2E1PQs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:16:48 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33667 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751971Ab2E1PQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:16:47 -0400
Date: Mon, 28 May 2012 16:16:45 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>
Subject: Re: [PATCH V2 1/2] regmap: allow busses to request formatting with
 specific endianness
Message-ID: <20120528151645.GN4032@opensource.wolfsonmicro.com>
References: <1337878047-21177-1-git-send-email-swarren@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="NZiXfHLGvOGtDZMn"
Content-Disposition: inline
In-Reply-To: <1337878047-21177-1-git-send-email-swarren@wwwdotorg.org>
X-Cookie: You will soon forget this.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--NZiXfHLGvOGtDZMn
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, May 24, 2012 at 10:47:26AM -0600, Stephen Warren wrote:
> From: Stephen Warren <swarren@nvidia.com>
>=20
> Add a field to struct regmap_bus that allows bus drivers to request that
> register addresses and values be formatted with a specific endianness.

These look good, thanks - I'll apply them once -rc1 comes out.

--NZiXfHLGvOGtDZMn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPw5bTAAoJEBus8iNuMP3djOAP/153ca7WGYL9YiuCD9aNI4rG
csodvJgw+PrwXYSSHM3nM2NcQXnN2KCNC7yTyYLSfRHKB9eLOR9t5W8rup2VFOdI
gHV2qbU1OS7RtlReWrN69YCHQdIZ95Uki1/U9/DrY7bbpu3lqkRkpTPXNRkkZTWc
Ws+chZuobza6/PaFwsC1okOUPPgme5ikljI03wNSE35FSEmCT3Zbp9LCidvJFJDE
V911XdKi+s56TOqacgbi8ihx6YLElPej/ree8M67JQQCHadB9SZf0vP5KxBiyh/t
xKPlzR4lONZRUg4qz44I6dr39yr3qhTdsvnywn2e+nSs5rE/KoWH/3gCNOYmt15i
1y3SKurCi6g8vG1n2GKFl7zYJRGbJ1VXxtNsvBDhcNcQgpY47Wqo7cLINkKbUdq/
n1W8uHrIrFhPc6EtVykSJclnHqtpDng+ppBsLwt4RMITZrKpEwIjHIItAt43fPs0
N3XwCl8/0nRdUz97rxqknwmARc0xgvxDmPXJcaNRRiruSlvkwoE++d+1ZtZ54/Pf
BndRL07FNjS4gVbof0oxk6Tbbw9JNL3ZPaJzwoweRqjHoZKPZ8crlX13c8Rr6j70
UNezJXyRTI8dFBT0y0pgZ62jMMRpVufy1xvRjmficHeS8YhXkvyoWwKvfLC6k82n
2TzlaKz/T6o1cD+Svr/E
=2MZ6
-----END PGP SIGNATURE-----

--NZiXfHLGvOGtDZMn--
