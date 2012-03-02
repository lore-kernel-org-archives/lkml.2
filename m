Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758270Ab2CBHmT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 02:42:19 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:30864 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755015Ab2CBHmR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 02:42:17 -0500
Date: Fri, 2 Mar 2012 10:44:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: santosh nayak <santoshprasadnayak@gmail.com>
Cc: marcel@holtmann.org, padovan@profusion.mobi, davem@davemloft.net,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: Resend: [PATCH] Bluetooth: Fix Endian Bug.
Message-ID: <20120302074414.GG22598@mwanda>
References: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="6BvahUXLYAruDZOj"
Content-Disposition: inline
In-Reply-To: <1330622196-12967-1-git-send-email-santoshprasadnayak@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
X-CT-RefId: str=0001.0A090202.4F5079D4.00CB,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--6BvahUXLYAruDZOj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

When you put "Resend:" in the subject it breaks git am.  Git am is
supposed to strip out the [PATCH] but the Resend confuses it.

Put the subject as:
[PATCH v3] Bluetooth: Fix Endian Bug.

regards,
dan carpenter


--6BvahUXLYAruDZOj
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPUHpOAAoJEOnZkXI/YHqRHeIP/jxrFMsvkRKXf/nG60GkpcyU
06kc4HL6Q8ga6KH6LNU9jPXSYEQ60m/a//aWrSQbbDBoErxDnDHrskQGxIX5beMv
wPzCTW36kquiuVhQ6Gpsa825aKhZl2Wl87R91PCieN8lZFnpCyYC/qZmVCc3M1hu
Dfd/ca7dBhQNrjHMrv2aLSUL3VkXwwyPcrGc0OAzVrPaHBSyMXR2tzi0WyR5aKdb
0ebvJAqAEduI/xPa57VMnnAzIt2JPo6byt2B6HNn8rhL9QFEreB0i49HJMVSZzGj
Bwh71j6IejcC+FQW0apRdjAGktgBd48rdVu3HE8kxlWdyidNcfXMGG5rgIHYPuPs
yyBsRmNjUZyWPCn7ANiGUfBFM+T9IlAycy0++IxTDgNozwHWrioP51hxIIPinyVS
3orJFq4cB5OHJNQ3e9Q7+r58Kt6+b/S7+Xw4fStYyEArKCTuLgCZs4CgJf4/hanY
n2YxhFaVFkj2Pnc49v6rWlg1zPV0/knFDkCEpEtcQjHBZ8SdBaJWHmlmLDtQ/mEV
88WkGJQVsXJ/vWDw7PQFpN5ZR4y5QT5YVAF8ZHLAiiAfiA7r017VMg5EANGmVJBz
M4dW66Eh5C0lZCjOmNe9P+QGtL0+xl49Zu8UpGdMxA6i1mJbr4PVoHNHO3dxk+t8
MG/aytQAWw2w8mm5vlfN
=B2LU
-----END PGP SIGNATURE-----

--6BvahUXLYAruDZOj--
