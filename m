Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932314Ab2HQIX6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Aug 2012 04:23:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:19390 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab2HQIXz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Aug 2012 04:23:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,783,1336374000"; 
   d="asc'?scan'208";a="181864282"
Message-ID: <1345192119.27859.28.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/2] UBI: add ioctl for max_beb_per1024
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Richard Genoud <richard.genoud@gmail.com>
Cc: linux-mtd@lists.infradead.org, Shmulik Ladkani <shmulik.ladkani@gmail.com>,
        David Woodhouse <dwmw2@infradead.org>, linux-kernel@vger.kernel.org
Date: Fri, 17 Aug 2012 11:28:39 +0300
In-Reply-To: <1345128723-13582-3-git-send-email-richard.genoud@gmail.com>
References: <1345042639.3393.150.camel@sauron.fi.intel.com>
	 <1345128723-13582-3-git-send-email-richard.genoud@gmail.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-M46YEja31aWRzSyx2JaH"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-M46YEja31aWRzSyx2JaH
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-16 at 16:52 +0200, Richard Genoud wrote:
>  		mutex_lock(&ubi_devices_mutex);
>  		err =3D ubi_attach_mtd_dev(mtd, req.ubi_num, req.vid_hdr_offset,
> -					 MTD_UBI_DEFAULT_BEB_LIMIT);
> +					 req.max_beb_per1024);

Do not forget to explicitely validate 'req.max_beb_per1024' valuse in
'ubi_attach_mtd_dev()', as we do for other parameters.

--=20
Best Regards,
Artem Bityutskiy

--=-M46YEja31aWRzSyx2JaH
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQLgC3AAoJECmIfjd9wqK0BswP/R/bARX2W2RlABSMUx1ytXHI
jyuFZSFOiSj7UjrCCFvXzaxgIdbgUHPCxJ9IpEoVY/ELW7hgLJNt5Jx2W2BAQ/yF
dBMk2ZRIctbKRQo9YLlWRvi+elTLL0Qjt4A+iTsxqENbHtXbzWs5rHOYInjvGrUU
vwBFI861JrmOrOVJrcI1mH5Z6mld1q7IQi0fPY48MOpHUEP99131yosH2srs3lGn
c6nRCzcvJfsWRe+BdJ0Yc0O0pmsYr3YWDjwW7aXgOlwbmd+9PDW5sji0m3W7FXWZ
BTX/4bsuRKLFuLWMEZRqjoXs0csk5ThRKdozNM8VF3iZhqxHYaJPclQuuusft1NU
NsflO6QsBnbjhJZkg9lZQIc4pLYC9H99DhWs4dC4WYllrFa0gDqpOHjeb0ck1K07
cxliW8bg+KHceYuZMCVgjfE1ISSFSSbF1z089jRedti22LnHizwibJMHsFcdYJzH
bfw3SLu8dOTUwlBCCATocLMYH0822ewFjBYqjulWjcug4k62cD6/R13aYqJqEc9T
cavfjXS3UrVezYIoYdGlJxPxfolJhq/RA+Hbf1gcI+R0a+Jcw058XysKS5P2oKYH
QREFJ62ax1WOJh0L++wPHBofGxIYDDLztLFQdWMvejxVOtAp4cHEomjKInLco/GY
TbV0lAtL8rPZCpWDXdav
=LU7B
-----END PGP SIGNATURE-----

--=-M46YEja31aWRzSyx2JaH--

