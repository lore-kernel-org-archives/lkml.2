Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab2GSJKQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 05:10:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:59619 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753768Ab2GSJKO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 05:10:14 -0400
Date: Thu, 19 Jul 2012 10:10:12 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] regmap-irq: use mask and val rather than using
 mask_buf_def
Message-ID: <20120719091011.GI4495@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998FD99F@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="byLs0wutDcxFdwtm"
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998FD99F@DQHE02.ent.ti.com>
X-Cookie: Beware of low-flying butterflies.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--byLs0wutDcxFdwtm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Jul 19, 2012 at 09:04:39AM +0000, Kim, Milo wrote:
> Default mask value is used when updating irq registers.
> Rather than using mask_buf_def[], use mask and value explicitly.

Why?  What is the problem you are seeing and what is the intended effect
of this change?

--byLs0wutDcxFdwtm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQB858AAoJEBus8iNuMP3d9IoQAJP3BPQ/NT4Grp0z7cjhxa6c
eT/MhA77gCTWJUe25/cP88yQm0IYP3SlWyIyAYef/3HTTTjgvgMjfLT7oYyQCU1Z
ZvHon02AhRweCNfnxY5bR9+BNgqjMG6RosQvRGnrXKFhS5YqdwqN0N864BznM2ux
MO3CrXb2mP7uvQzigCei9ErkcQN82/Ii/YLIZWfei3IHx0nq45xG2yxUdMFf3C9u
L5p4Fy3XiWJLQz4PExZ/DNj33AXKP4zcKFrtZZAKOff5sm7cmh47UGKwZjhJ/to2
xPp4zYPYklsIygfCoJf9b6tfqxmoNhR0M/RS3PWd3MwQizej3+7tfjvi024/182a
VLtRcA2tNllXyd59R9iIhHs+zL1btN5I/el4VtoxOufTbDe7uzq8Kstfpdi2Z+bS
+vTJJxOWcLxcoF50BOjw7HhRZfocShlY78GSmzY9ZB3tAWcvBNbCSP3szhVhQ1QZ
IzNjBQebULFqmTaiVkfCFyPKjiEYyh0MYlGrXpipgjo0C69bm7h30enlb0Kki8vP
chVMjLNlPHQFdbLSrcieYSKawMnJ3G2xyiYbc3jK36+cAIIqcIfRsgrCu8VBFzE5
5m0f1E/Lfj2K85vU57bPqHkTRDCu/lB/H4UcW/eu+1g8gKfmgKw7OpqFADDc+HYV
LrluShtZvjuQY8tgGFaS
=/2zf
-----END PGP SIGNATURE-----

--byLs0wutDcxFdwtm--
