Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751858Ab2HJLhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Aug 2012 07:37:31 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:54307 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2HJLha (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Aug 2012 07:37:30 -0400
Date: Fri, 10 Aug 2012 13:37:27 +0200
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Sachin Kamat <sachin.kamat@linaro.org>
Cc: linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH 1/2] pwm: vt8500: Fix coding style issue
Message-ID: <20120810113727.GB19616@avionic-0098.mockup.avionic-design.de>
References: <1344573730-21907-1-git-send-email-sachin.kamat@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="v9Ux+11Zm5mwPlX6"
Content-Disposition: inline
In-Reply-To: <1344573730-21907-1-git-send-email-sachin.kamat@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:M5VXSzcY9oJrDe0B+goq7D8KIVHBvd/sGwNisUxHqIO
 ryb/CC4AS80ctiEbf90aiN+bNjViYX4HXW7skLKtrCiYcnpQUV
 ih5dG9bbi2mzko43RpLrlr65eY2PrtmTO4amzBVBhdDqbx3k/J
 p2QKjq14F8nH01TEtX9KEh7uvdM6YyY8h55pktaYHmiqutLhYo
 w9z1uncazACLhd/mPrSOx5zQwgsEwep+nPj7sXvrjxKBRlNGid
 4asRCt+1oYPAThSInMPmJQ4oZR7nwoxNVFbxqHYaGaF+J+E3KO
 ne0QhSYVhp7ufO+4SBipxvJr1ZoCZyNAcd71q4tY3fd6u+HFH5
 EYmPWNKni+Z+8YkxeOHeqpvkhYvxnRWxljrS7TsBzsjp08yRqn
 QloTen1tzgBDd1qiEegNWrZm+AW/2LKyzg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--v9Ux+11Zm5mwPlX6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 10, 2012 at 10:12:09AM +0530, Sachin Kamat wrote:
> Fixes the following:
> WARNING: Prefer pr_warn(... to pr_warning(...
> 	pr_warning("Waiting for status bits 0x%x to clear timed out\n",
>=20
> Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
> ---
>  drivers/pwm/pwm-vt8500.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)

Applied, thanks.

Thierry

--v9Ux+11Zm5mwPlX6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIcBAEBAgAGBQJQJPJ3AAoJEN0jrNd/PrOhRq8QALzut3YvNuNHbAnd/+7TVWF/
b2aRTJj9SPfsxDzssuniXWASL8Ko/HfM1hc12e0zLY/3VB79pcqyCJ9v0CqVeKY8
+tQIAHoqN7ywsbh5s/95YafZUKGx5CekQztoKFczH4cQctcN7G3/evWvrQLFTYY0
a2kfITjUgiHG2D4kKhRBkv37cwoZFyfcuJiLiBDy+0AHb8uJ/xLstRjotZXpgsdc
YMU+VFScn89ni4S97Mrsow40FRGF3CEG8jIegJGn2T/jMSRJRKRUVhF2iBrvCN2E
zLHbEzy7RlGRDF+kgq1IbkSLSnQUF+b0yrY45jwao3V4S42Rxr+BkHOpBkJbqR/5
it+BDFVdmcP99R1HK5e7R+JPQTKNQjyjYfx89msc+dt1B5EeeNIvSAmHzPFQUhrn
Tya8zFZssmqPr1PuOOHWLfrdG07Ga7O+cu+xjgPglvIzU1zuj3p4FzlwPRP568OZ
BdiYBUd3CihULFEs0XxbkUDmD7Kmts6vCNCd+BBh3MvetHKKY6wOnZlx97eTJ8X4
An8U+vzyOHQeO2iQIPr3mjelTiYLXYdPLpo5iTmzJWr95sm+hJn7zIbZIjHiFOtO
cN6BdWwqlAtLSne7/wU5q9UvjUyJIvkrpdBhw5ANSyl1eABnk/BVlVWFsThUDXvK
+lEVf2y/8YUqzEJnpGgv
=CVFx
-----END PGP SIGNATURE-----

--v9Ux+11Zm5mwPlX6--
