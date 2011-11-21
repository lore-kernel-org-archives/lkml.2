Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493Ab1KUMUI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 07:20:08 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:57053 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752572Ab1KUMUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 07:20:07 -0500
Date: Mon, 21 Nov 2011 15:20:29 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Vinod Koul <vinod.koul@intel.com>
Cc: dan.j.williams@intel.com, linux-kernel@vger.kernel.org,
        jaswinder.singh@linaro.org, 21cnbao@gmail.com, rmk@arm.linux.org.uk,
        Vinod Koul <vinod.koul@linux.intel.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        Viresh Kumar <viresh.kumar@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Mika Westerberg <mika.westerberg@iki.fi>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        Li Yang <leoli@freescale.com>, Zhang Wei <zw@zh-kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Shawn Guo <shawn.guo@freescale.com>, Yong Wang <yong.y.wang@intel.com>,
        Tomoya MORINAGA <tomoya-linux@dsn.lapis-semi.com>,
        Boojin Kim <boojin.kim@samsung.com>, Barry Song <Baohua.Song@csr.com>
Subject: Re: [PATCH 02/10] dmaengine: move drivers to dma_transfer_direction
Message-ID: <20111121122029.GA4814@mwanda>
References: <1318570705-17595-1-git-send-email-vinod.koul@intel.com>
 <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="d6Gm4EdcadzBjdND"
Content-Disposition: inline
In-Reply-To: <1318570705-17595-3-git-send-email-vinod.koul@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090207.4ECA41C3.0138,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--d6Gm4EdcadzBjdND
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

I haven't followed this discussion at all so perhaps you were aware
but this introduces a Sparse warning in linux-next.

drivers/dma/timb_dma.c:168:17: warning: mixing different enum types
drivers/dma/timb_dma.c:168:17:     int enum dma_transfer_direction  versus
drivers/dma/timb_dma.c:168:17:     int enum dma_data_direction=20
drivers/dma/timb_dma.c:172:32: warning: mixing different enum types
drivers/dma/timb_dma.c:172:32:     int enum dma_transfer_direction  versus
drivers/dma/timb_dma.c:172:32:     int enum dma_data_direction=20

regards,
dan carpenter


--d6Gm4EdcadzBjdND
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOykINAAoJEOnZkXI/YHqRkpsP/j9kyJOVpXeoakx0PM+Z8Ae0
G66aFaFdGKDpSEd55D2nX2NgJE+pVgBm31xmb2AoxVDnJUHhfPwXpiQmN8I7coBO
CRFJnr5SnkJmzsBejoFe6PTygAiOKntVkp1Bw0mcPzE/aknVoCf1ES15rEAj5IzV
KRh15+lKn5rA3gnmEwmssZxQ9xmDzkUr0Sz3ELxLi2d57/s534/koH2eIYCgHvbl
4BTboysvlcR5cr57yoHKwUx+jUQskHG71MMxde7YWiXO4NEspnA3BHjB3S7VMklR
EEx0uX2Tb/Gv8qJ8A3hMwbfXUL8Naje0j5j2ino7eSXJZ6wZYqE4zLq6Ifn123k+
gXB1hJLh5my1tJB5N15BXJ7orz+tu34KlSzbVjGCggEkRc/TK4jqWPP8z7R64k5X
Xi8TE9LR4oIyd5ZuxkeBQETmhlkHUOiCRDJI78RwceeeY48udS15PFBuWnh0oI36
zWvvpnMCft74tqIgq9Nht5NeW5NnQXl3sVnEZR1MCIJ0M93UmNNIx5zJQSn+luGM
wE1903O7faxDjYRRr8w95TzHFOwXA4Gm/J6zOheOD1CGQh4Sqidb4UiuqMYXo+1+
H05WuWbu0JpoolQ9e8Q6v7nLpIcHrqADD5Z70M7fhOraVCsOj/M7H9wW7Qh3ZUIm
s0RCw78T2YcBa7wdqai2
=w5rk
-----END PGP SIGNATURE-----

--d6Gm4EdcadzBjdND--
