Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2AUIVL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jan 2012 03:21:11 -0500
Received: from acsinet15.oracle.com ([141.146.126.227]:19282 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752116Ab2AUIVK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jan 2012 03:21:10 -0500
Date: Sat, 21 Jan 2012 11:22:08 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Christopher Lais <chris+android@zenthought.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: [PATCH 1/2] Staging: android: binder: Add some error checks
Message-ID: <20120121082208.GL3294@mwanda>
References: <1327118181-3542-1-git-send-email-arve@android.com>
 <1327118181-3542-2-git-send-email-arve@android.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Qgd2S+2VS1hsWwXW"
Content-Disposition: inline
In-Reply-To: <1327118181-3542-2-git-send-email-arve@android.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4F1A7570.008D,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--Qgd2S+2VS1hsWwXW
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Jan 20, 2012 at 07:56:20PM -0800, Arve Hj=F8nnev=E5g wrote:
> - Add a mutex to protect against two processes mmapping the
>   same binder_proc.
> - After locking mmap_sem, check that the vma we want to access
>   (still) points to the same mm_struct.
> - Use proc->tsk instead of current to get the files struct since
>   this is where we get the rlimit from.

This doesn't seem related to the locking change at all.  Probably
this patch should be split into three patches, one bugfix per
patch, unless they are very closely related.

regards,
dan carpenter


--Qgd2S+2VS1hsWwXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPGnWwAAoJEOnZkXI/YHqRq2gP/2yvNw+nzg7qx2uOasWUA2Ol
rXwIKHQ2sbV2ojR2uzzSnU9uKlFmx0KWBFdSKLJdkeoeVUZekeRnc8YPXQzxKJ10
PUjKBsTQKWq7yTvR8N3IMOwpYiJbQDgzZyMT2YeVJ7BA93YtcWGwcGKNEHgtOJ7P
IZrHTU+rBe9LIbnHaNpLQeQchd1H/P35XM7D7eIWS4rNnrXJLXN4MeTcHZ/sPaPT
CmwHIQKFCT5DVvzlOgdMxfmiSuqFBnti5O74+b5NQCTKnP0h703X6cQu5B0jARnI
9VpsjebmOuRdqnPV+F2QdfFTn047SKhej2shh2nyOV4CIMpELIZIRC5daVfrbjJg
0L5E7EUZ33RFNrLqhqwntazKYVwtyTgpuo9HCDSyqdTkY2qOhCzyGfu/bluURDvy
CEYaNf2zYTlfyVxdn3f7cHs7gzdfwUPl2QzgTReZGL3x0NQrgUZ6w0LMzVFSyOqa
eeMh/lhaLNumBUfi1/jNpIg5PdsQr8LUCjdvGbpz1UDiZDlp7QqSTE296kpANbxg
WDwY8NbhGOi5ebpPCyhMHT9ljrVF5Atl8RJc3ZoM5aX/8L9mlN4VV4C8JA3HU/LL
5N9fIDAp1Z2fC9qmfpZQbkJBlK1L/GShdGKfStBGRju9VtE7A6niS+Js0erY4XNN
ovNmSxp7Waq4G/MjLGz2
=N0s2
-----END PGP SIGNATURE-----

--Qgd2S+2VS1hsWwXW--
