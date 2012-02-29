Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755570Ab2B2HIY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:08:24 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:43830 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754353Ab2B2HIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:08:23 -0500
Date: Wed, 29 Feb 2012 10:10:02 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Dmitry Antipov <dmitry.antipov@linaro.org>
Cc: Rusty Russell <rusty.russell@linaro.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linaro-dev@lists.linaro.org, patches@linaro.org
Subject: Re: [PATCH 1/2] vmalloc: use ZERO_SIZE_PTR / ZERO_OR_NULL_PTR
Message-ID: <20120229071002.GA1003@mwanda>
References: <1330421640-5137-1-git-send-email-dmitry.antipov@linaro.org>
 <20120228094415.GA2868@mwanda>
 <4F4CC19D.9040608@linaro.org>
 <20120228133037.GG2817@mwanda>
 <4F4DCB59.5060205@linaro.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="FCuugMFkClbJLl1L"
Content-Disposition: inline
In-Reply-To: <4F4DCB59.5060205@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090204.4F4DCEE1.0060,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--FCuugMFkClbJLl1L
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Feb 29, 2012 at 10:53:13AM +0400, Dmitry Antipov wrote:
> On 02/28/2012 05:30 PM, Dan Carpenter wrote:
>=20
> >Could you include that in the changelog when the final version is
> >ready?
>=20
> What changelog you're saying about?
>=20

The commit message to this patch.  Right now it just says "fix
vmalloc" but it doesn't say what the bug is or why the new version
is better.  You and Rusty know the reasons already but we should
write them down in the changelog so other people can follow along as
well.

regards,
dan carpenter

--FCuugMFkClbJLl1L
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPTc9JAAoJEOnZkXI/YHqRO8IP/3rAPE5uQw79xZdjXcCp+3fy
/jg1Bi6QACf4aImUxHN8vb8e+7q5T26jlknpw8URxiUqeZpHNRAix157Uo4uMBw2
Hj3SfKuR6i1RkNuJm+XgNb9F4bM59aOE1AwR6p62lDmivr/stUW80GUor9XOE4+o
dOV2WPbWian5Q+2wC6sKT9jRrk52zNmZq0Ke1nRc14b4f6ESXqpxCt9KGkU++Cdm
vX/7gS7CiDw6DPYFujhBpKQt4b/np4X/Ny/2w9DsqywWwoUJSBmEDZk7HnAATJSn
ytLQpeMXUmFOFmZU3GjhNbC3uMRb9Fq7dR3rR0r9tyhCCM852nOmOR83ql34u32V
C3+bia/jExny+Vxy6y3U22ifwK0WT2bs0uQEWjFgrAQL6i00LL5HxkQh9EMYtRMZ
q/+2jS0kIleIHJMG7Bku40/s0LYx9CkDGgYh3oYZ2xggP9qPptk9cYyI48Dgf/pF
b4JCp7MdUFu2Q0s84yi7MKkRsLpa0hd6mxwj+mettTJFhikanrDKge2ettrW91bH
S/7t6ElpYIOcxz6Xy3EOtwRhlr1iPk74nHhSG59cUZd7XqYiZhls+4PXXVx8ouYZ
Cr+ntJ9gJBwizelRnbXfMzfYZ6TWdi0Hr4TUY92MWIO9lImCfVkFxVzleZpXEvJp
ngHFsYR0CHF+5x6tiVp/
=SZuG
-----END PGP SIGNATURE-----

--FCuugMFkClbJLl1L--
