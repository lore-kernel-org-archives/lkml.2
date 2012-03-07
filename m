Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211Ab2CGF6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:58:09 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:44730 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894Ab2CGF6G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:58:06 -0500
Date: Wed, 7 Mar 2012 09:00:17 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Zhengwang Ruan <ruan.zhengwang@gmail.com>
Cc: gregkh@linuxfoundation.org, arve@android.com, chris+android@zenthought.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 v2] Staging:android: Initialise buffer and
 buffer_size before used
Message-ID: <20120307060017.GP22598@mwanda>
References: <1331087818-9942-1-git-send-email-ruan.zhengwang@gmail.com>
 <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kynn+LdAwU9N+JqL"
Content-Disposition: inline
In-Reply-To: <1331087818-9942-2-git-send-email-ruan.zhengwang@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A020207.4F56F8E8.0097,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Kynn+LdAwU9N+JqL
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 07, 2012 at 10:36:58AM +0800, Zhengwang Ruan wrote:
> GCC warns 'buffer' and 'buffer_size' are used with being uninitialized, a=
nd
> 'buffer' is used as returned value, and 'buffer_size' is initialized using
> uninitialized_var to clear warning.
>=20
> Signed-off-by: Zhengwang Ruan <ruan.zhengwang@gmail.com>

These are resends.  Why are you resending these?

regards,
dan carpenter


--Kynn+LdAwU9N+JqL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPVvlxAAoJEOnZkXI/YHqR26YP/0+WETDUFOuRNA21xJGtacM6
kn0+SJT3tvVaVK2Ux18g62neLN7hnxIsuKIsnlU/n512h2t7igHR7bs0I1nVzrdg
RVoqVx93jFnuqUiulrw5li/R5GFfm3yLToj2C4U1RDrVTXwSAu3ufGDIQGoTudYN
qoOm08zphgSonb99SfyqqF4ntzSSHlx+cBtpAbYhIeCzkMCSfriekJ25FLGeNqQ5
dmJtkz2meTiSIxGLSUaj8iQkxGSvMN86q69aD1NJ8wq4B49tdConnXoW0P6Z2Oxz
TyCYBMgbv/V/q1FcjOSuwffSomRb/nezP+FPRDJi9yfTKhP7fd7Hf/KwbizVuLIo
dFwdZvQGWOpN7M2tpNd868DwuNtoOcuxkswenR5APaObj5D+0SYDWqi6VdPG91iP
BFGLm4o1kyf4XvasKun+IYeLmun2FhWoV4sLjjVhB1EbIr/1KdZbtWeV9qSifW5N
GfpHJ8bssEaQmp7tctS6NaTCZypWrIwkxOLKIAc6+ph3GJdlWJts1nxV7GQ/MOg5
nXKwe9q8lHjJraIO/wCubt8h0a5ig8/r7KWVHvEqzhkeEQ8Hpb1rL39ARfCl0qzK
+lxd+i7xI7tqX687eq80yrUpSXZkVfiVj+rQB1PpFojwMLwtJ9HydkBWCyY2gnfx
rDilrhnCLchbVsg3/zbL
=1W4u
-----END PGP SIGNATURE-----

--Kynn+LdAwU9N+JqL--
