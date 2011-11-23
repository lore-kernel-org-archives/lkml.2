Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756997Ab1KWGOO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 01:14:14 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:36831 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752868Ab1KWGON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 01:14:13 -0500
Date: Wed, 23 Nov 2011 09:13:55 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Xi Wang <xi.wang@gmail.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mori Hess <fmhess@users.sourceforge.net>, security@kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Greg Kroah-Hartman <gregkh@suse.de>, Ian Abbott <abbotti@mev.co.uk>,
        Franky Lin <frankyl@broadcom.com>,
        Greg Dietsche <Gregory.Dietsche@cuw.edu>,
        Mark Pearson <markpearson_de@yahoo.de>
Subject: Re: [PATCH] comedi: integer overflow in do_insnlist_ioctl()
Message-ID: <20111123061355.GA3295@mwanda>
References: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="liOOAslEiF7prFVr"
Content-Disposition: inline
In-Reply-To: <5C0D372F-F03E-4EB8-8440-83A8D1C95363@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4ECC8F1F.0056,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--liOOAslEiF7prFVr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I sent a patch for this already.

http://driverdev.linuxdriverproject.org/pipermail/devel/2011-November/022469.html

regards,
dan carpenter



--liOOAslEiF7prFVr
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJOzI8iAAoJEOnZkXI/YHqRhskP/3yKSZwqYitt0J0wmfa4k6zw
grdX/11DjQJcfs2vhK1FHSOTb+aM1ihub/Gxqd62HSPmThzGEs2bDfEWZNxAVYOF
dVrbF8FiDW6MDV7mOnqFWg/ZEq69KM4l5fQL6QUXTcwrA29J0DDAkaLovYrC1ee5
X5vbPqP0j+U3PHSgppwbEdApj4jy1f28Cwx0sMR9OptTDLYpHQMkkaPLV1Dinw5F
S7UdzI9HBnlYwj3GkeqwEfTdeh53de5t9feb8olGzUS5+cFHFfb9G/N4FAEpshil
jujCZTMGHmQ4ZNEIt2JQuvQDA2Y5bCtR7oVSoFRC57mtqza3twLVKOqfyJjrjYwG
T52Qz2w2SPIm7YatbXL7kAMGYyVXFdb8x05jTxb+N+nrEZ7Za4Y4kGmy8uLtHDJ6
AEm6Qz7FqValVsXqjQaIDwRU4aPtaU2cXvijeB1uLGKiJYyDY/ptLQ0EwoKkoeIq
ZhM1EAAeicDM2L5MEGuJ4ciCVHUETlm+1NKIpXYli8vS3oBweWUhstlA9R39aRox
H5LrPTuS/23CrruGCnosIsapzwUWbTlgAEw4UuuWYmJdwyvmExYVB8mGSoNOgWHD
/fqpbadA/UyVrRSYoSH25sTb3wBM8ZIBeF98xZQevvqrGA2vcECr41joOOeX65tO
v96uiLJIM8YC/4loawx0
=9j1z
-----END PGP SIGNATURE-----

--liOOAslEiF7prFVr--
