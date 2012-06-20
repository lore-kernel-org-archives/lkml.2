Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab2FTKTA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 06:19:00 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:58599 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755963Ab2FTKS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 06:18:58 -0400
Date: Wed, 20 Jun 2012 11:18:57 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, "Milo(Woogyom) Kim" <milo.kim@ti.com>,
        Liam Girdwood <lrg@ti.com>
Subject: Re: [PATCH] regulator: lp872x: Return -EINVAL if pdata is NULL
Message-ID: <20120620101856.GH3978@opensource.wolfsonmicro.com>
References: <1340179995.18879.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQmOcGOVkeO43v2v"
Content-Disposition: inline
In-Reply-To: <1340179995.18879.1.camel@phoenix>
X-Cookie: You enjoy the company of other people.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xQmOcGOVkeO43v2v
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 20, 2012 at 04:13:15PM +0800, Axel Lin wrote:
> Return -EINVAL if pdata is NULL, otherwise we have NULL dereference bug.
> This patch also moves the code checking pdata earlier in lp872x_probe.

Applied, thanks.  We should really not be insisting on pdata though.

--xQmOcGOVkeO43v2v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP4aOKAAoJEBus8iNuMP3dRScQAIBL3tOwcCQhz4zGhaGPy2Mx
4NF/fjm7RZPSmWywxCLE7lqYPbe1lGnnrd/YBhJ+VaAoVyWIP5qwUEy+VkESdBnF
AJPzpvePTuKgX6mJ07azCqxMzS5Xb+Bzu2g3ZqorwYOdG0w0+iIndKDTOIhlPtBA
I9mlSuXONCh2rsOGYpvUC1NpByFH5Rf4JfoYrGappMyhaIG0Z/tT9CKPGTI2lmeA
62mzAbSDS5n/lnWDE3vmnHfowKDJlrN704c7vLRew8lFsmKKjuqs5yr0vvVqFgQS
jNsO19FtAoNm9tuS9T2Ly1/No5s6IM6/+QDglXps4vjaE8K6hLEQ+Lbw5NBsMR+V
cSvArfeo36oq++ImdRJnTaDWkM1E7PCuHa7XXAvuBEuQid9rMwY6KLNWueymRfaj
5kSUYIvBAH/XsGjD/jBJ3QicHIn48MtvpztbgP2POS6m/Wk+0LrjPfKqLB1kGauy
NVEmmgySGX22HS3ktaGqPL5mXXI1hP+ShuYtDodKjOCAJAaCfmHB7J76MORHp/qx
zwFJNDZWPgir5DZLInChgAT59TM0IqiYa8cEk4DHCt8E/nw2RhhyA8YLS7fb2c3g
u+v5CIxrG38MegR7cjzYD671w1qPpbE98MmMHbg9KIMbOJOa2nomtH8KWNH9/IxM
ecTkTsmUO4BwhYqXPcCw
=yeZm
-----END PGP SIGNATURE-----

--xQmOcGOVkeO43v2v--
