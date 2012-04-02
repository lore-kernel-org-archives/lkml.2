Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2DBWS7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:18:59 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42120 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751615Ab2DBWS5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:18:57 -0400
Date: Mon, 2 Apr 2012 23:18:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Laxman Dewangan <ldewangan@nvidia.com>
Cc: lrg@ti.com, linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org,
        ldewanagn@nvidia.com
Subject: Re: [PATCH V2] regulator: fixed: Support for open drain gpio pin
Message-ID: <20120402221853.GL3160@opensource.wolfsonmicro.com>
References: <1331116113-22565-1-git-send-email-ldewangan@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="KSn4sQg3MnruwCB4"
Content-Disposition: inline
In-Reply-To: <1331116113-22565-1-git-send-email-ldewangan@nvidia.com>
X-Cookie: Is this really happening?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--KSn4sQg3MnruwCB4
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Mar 07, 2012 at 03:58:33PM +0530, Laxman Dewangan wrote:
> Adding flag on fixed regulator board configuration structure
> to specify whether gpio is open drain type or not.

Applied, but I had to fix up some conflicts caused by other development
that had happened in the meantime.  Please check that I resolved those
correctly.

--KSn4sQg3MnruwCB4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPeiXDAAoJEBus8iNuMP3d8UAP/Rv0ZqYn01KvbRnE/jjs2gvb
mOtl/j1YuiW8aobYhyWKucN3mV1Bn49WSvpddQboim/3eMzKfuwMJHhouK/4eyZ4
n5iWe4QY7MqLcE5fR9W90Hx0xbbAahKZXIF1/GaPTDC8fYi7N5r9SKpOQTj4cEbp
DpoQcwUhnsceaP8Edm5oV7WBAgwPIguwex1RAclVmQH444C3s1M4pZYh0WngFmRf
Aj7cmIo98vX40kiW9PVh0jobCsXxTwRLg0q6j5RiZGwdOR0yM3ClRMx2rXZ5LMRq
PhjdGXclgHMgL7CfHDPSuw+a4uo2OsZkvdcyW5Sf4fJ21F3OOtAwRyfxCzVnnNNZ
JkB/tJKZPdoo2TX8dTAraF6RDqGf9cj8zJ+Pcuf7fzTpk/TUiTTLLIVg36I9lpYD
ywipfdxBvQlpb+o43CEkuBoznuZB04jxMdz+TflDxaBi4BK3OgHTRWMLMhCBmAEX
2e11c8kmnhmVGKxjD1SvYFy9AL/2zhPbxqkGuFr7LCcYUl0ByDWy4NO2xbrCeRI5
l9/BU633gS+UN4ON9JzUE0zWaLHTdNUhG3qVexjFUOmIJDlGr/0i7To/Na113BRN
fQ1fV6S4ioPe1loitn/WIgC1mVdkROQ53Tgd9jQ81v3YYYpx3tQyFD1Hh38uhAty
oDVdsmehaVDYSqshb7yP
=IcyQ
-----END PGP SIGNATURE-----

--KSn4sQg3MnruwCB4--
