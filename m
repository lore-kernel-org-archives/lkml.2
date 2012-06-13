Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab2FMRqX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 13:46:23 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50335 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754323Ab2FMRqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 13:46:22 -0400
Date: Wed, 13 Jun 2012 18:46:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Sangbeom Kim <sbkim73@samsung.com>
Cc: "'Liam Girdwood'" <lrg@ti.com>, linux-kernel@vger.kernel.org,
        sameo@linux.intel.com, sbkim01@gmail.com
Subject: Re: [PATCH 5/5] regulator: Support AP watchdog reset operation for
 s5m8767a
Message-ID: <20120613174620.GD7804@opensource.wolfsonmicro.com>
References: <042301cd493e$8d95d7e0$a8c187a0$@com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="BI5RvnYi6R4T2M87"
Content-Disposition: inline
In-Reply-To: <042301cd493e$8d95d7e0$a8c187a0$@com>
X-Cookie: Advancement in position.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--BI5RvnYi6R4T2M87
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Jun 13, 2012 at 05:28:47PM +0900, Sangbeom Kim wrote:
> After AP watchdog reset, S5M8767A should be reset too.
> If AP is set on lowest voltage, AP can't execute boot sequence.
> This patch support watchdog reset of s5m8767.

It's really hard to see how this patch addresses the issue above - could
you explain in more detail, please?

--BI5RvnYi6R4T2M87
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJP2NHkAAoJEBus8iNuMP3d9icP/33+6E7oE9I4KFp1vKjy0KbO
KWW9Eyi11+IQJ+pxFWraE3MaL9jKqHDgTPbTsEIgSliSZBtAVWM9g3mCVTOuf/mu
1aBPLih5LX+LYMzKGLhDFtVrcyxP50KIjaGfs/qohk7MIiOXdaP16ebucxwpn8Rz
o1Qq4JdR8gpMfmkpHnxYq0iFbuJcyjEccsslp5RGrKH8lllJo8i/ransjbwTeRCJ
rX3+I/ejBwp+p4iGC6M1NDLdDNGC0ZJcZO2L8MPUYePj1OGIihwINZydbrwOnWoS
qtOZl1LEmhM1jIHcCzy+WfNFhCeqxFR0mdfouiu6+pGbKuIh6zIDsi5dynK+Tkr6
am9W9aGmULZQ3q0m3oRB2RQP5Y0cqE1zqrmU6UuV2Qh1WuSs+BfJf80CTH/0Xkxk
ulLyjIOxnIG53TdYRUyP+nAopUrIdqhDt1UzR2wdKmhIvD07agFnMPqzryk14Zzh
//abADlsULlzG4+4H9M1PUuQ+9Z8GkZsa55NkVE5vxEr0tx2W2tMLVSFdargbsen
BM/4bcuQYo9i03RY7//l+6bZk0ymfDnlkj1hmyrKo6ykHR2AxnN+dQoW/Xp0NgRG
qCeAWu+WcNNNdRPxc/fdQEXKyGo6l7I6PS6ssJ/vgqj49erqpBc2yZVNyOVxpbux
DHl67P/S5QnSTW4irtoc
=DGYM
-----END PGP SIGNATURE-----

--BI5RvnYi6R4T2M87--
