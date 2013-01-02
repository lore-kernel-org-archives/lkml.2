Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752491Ab3ABCS5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 21:18:57 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:45442 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752399Ab3ABCSy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 21:18:54 -0500
X-AuditID: cbfee61b-b7f616d00000319b-7f-50e3990bfa65
Message-id: <1357093127.18226.11.camel@kjgkr>
Subject: Re: [PATCH 3/4] f2fs: fix removing cache entry within proper lock
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Wed, 02 Jan 2013 11:18:47 +0900
In-reply-to: <1356846773-7712-1-git-send-email-linkinjeon@gmail.com>
References: <1356846773-7712-1-git-send-email-linkinjeon@gmail.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-AchlR9i8qRoHaehcWJfv"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42I5/e+ZkS73zMcBBo2veSz27D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDK27jEpeCdUcftNK1sD40mBLkZODgkBE4mXd86zQdhi
	EhfurQeyuTiEBJYxSnw50s3excgBVtR5xBsivohR4vydL4wQzmtGiUunVrCCdPMK6ErsnnID
	rEFYwEti+nQnEJNNQFti834DkAohAUWJt/vvsoKERQTUJCY8SwWZwiywi1Hi2NElLCA1LAKq
	EjNfvwWzOQVcJK5O7GSH6HWWWL7sMdid/AKiEidbPzGC2MwCVRK7r8xihrhfSWJ3O0Q9r4Cg
	xI/J96BmCkh8m3yIBeIVWYlNB5hB9koIPGKXWLHsBStEr6TEwRU3WCYwis9CMnYWklEQcU2J
	1u2/2SFsbYllC18zQ9i2EuvWvYeqsZHYdHUBI4QtL7H97RzmBYzsqxhFUwuSC4qT0nON9IoT
	c4tL89L1kvNzNzFC4lF6B+OqBotDjAIcjEo8vDf1HwcIsSaWFVfmHmJUAZrzaMPqC4xSLHn5
	ealKIrzFXx4FCPGmJFZWpRblxxeV5qQWH2JMBvp0IrOUaHI+MIXklcQbGhubmJmYmphbmpqb
	kiasJM7b7JESICSQnliSmp2aWpBaBLOFiYNTqoExYgfvhhdVqi0uYrHb/J8cPr+qiK2+zYe5
	z66x9MnTXZ7ht/WDHn+4Hr1suutdY90Mp7iQ0/KuRw67q0c1/Bapvb5PKHP/dyV5h5+fGl8s
	jRQ0OVCT2uDRO09y2sPDRlcebA3sTeTgbVu+SsKxg38/i9LO3zdepnol3VqRGT3B+YnUcVam
	yd+VWIozEg21mIuKEwG2n49lFwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrMKsWRmVeSWpSXmKPExsVy+t9jAV3umY8DDG5sYLXYs/cki8XlXXPY
	HJg8Pm+SC2CMamC0yUhNTEktUkjNS85PycxLt1XyDo53jjc1MzDUNbS0MFdSyEvMTbVVcvEJ
	0HXLzAEaraRQlphTChQKSCwuVtK3wzQhNMRN1wKmMULXNyQIrsfIAA0krGPM2LrHpOCdUMXt
	N61sDYwnBboYOTgkBEwkOo94dzFyApliEhfurWfrYuTiEBJYxChx/s4XRgjnNaPEpVMrWEGq
	eAV0JXZPucEO0iws4CUxfboTiMkmoC2xeb8BSIWQgKLE2/13WUHCIgJqEhOepYJMYRbYxShx
	7OgSFpAaFgFViZmv34LZnAIuElcndrJD9DpLLF/2mA3E5hcQlTjZ+okRxGYWqJLYfWUWM8Sd
	ShK72yHqeQUEJX5MvscygVFwFpKyWUhSEHFNidbtv9khbG2JZQtfM0PYthLr1r2HqrGR2HR1
	ASOELS+x/e0c5gWM7KsYRVMLkguKk9JzjfSKE3OLS/PS9ZLzczcxgqP9mfQOxlUNFocYBTgY
	lXh4b+o/DhBiTSwrrsw9xKgCNOfRhtUXGKVY8vLzUpVEeIu/PAoQ4k1JrKxKLcqPLyrNSS0+
	xJgMDI2JzFKiyfnABJVXEm9obGJmZGlkZmFkYm5OmrCSOG+zR0qAkEB6YklqdmpqQWoRzBYm
	Dk6pBsa2Qk+O1vcZvSG7JJf8j9nkN8HTc33595mMnfdTDffVWi2+bsS9QCFU6/r6olWrtENu
	TsrT7Gc6lnBbrPPF8bLwn3f/s/7eXlD4Yn7tXH7u+Bi/o72ZyxZ5SubXMk5/+Uar6KMV84SH
	HW9t7t1UmuHPny3PYfLhzQ6RlZnKB+eGeqYdu7N48k8lluKMREMt5qLiRAATtTc7RgMAAA==
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-AchlR9i8qRoHaehcWJfv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

NAK, we don't need to do this.
There is no relationship between kmem_cache_* and free_nid_list_lock.
Moreover, IMO, it would be better unlock free_nid_list_lock as quickly
as possible in order to reduce lock contention.

2012-12-30 (=EC=9D=BC), 14:52 +0900, Namjae Jeon:
> From: Namjae Jeon <namjae.jeon@samsung.com>
>=20
> Cache entry for free NID, is not getting removed under proper
> lock in case of error in add_free_nid. So, free the cache entry
> first before releasing the spinlock.
>=20
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  fs/f2fs/node.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
> index 5066bfd..09139fb 100644
> --- a/fs/f2fs/node.c
> +++ b/fs/f2fs/node.c
> @@ -1227,8 +1227,8 @@ retry:
> =20
>  	spin_lock(&nm_i->free_nid_list_lock);
>  	if (__lookup_free_nid_list(nid, &nm_i->free_nid_list)) {
> -		spin_unlock(&nm_i->free_nid_list_lock);
>  		kmem_cache_free(free_nid_slab, i);
> +		spin_unlock(&nm_i->free_nid_list_lock);
>  		return 0;
>  	}
>  	list_add_tail(&i->list, &nm_i->free_nid_list);

--=20
Jaegeuk Kim
Samsung

--=-AchlR9i8qRoHaehcWJfv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ45kHAAoJEEAUqH6CSFDSqTsP/3hhJIRRbOBZBHTk6/A/wfsH
Q4tvKGgE8QZbMzTsSMNUv32ICDGTX8nZ11fmgztWZNnFvQrvzGxuxJGA3Q7z/ayd
DSsaubiG8SOD8OvvVUcgNJNWmQy7lqxMhRu6xMFU4+zyt986FqGw3NR9Lr2cntwN
J+4bc3n6IHs99+zh5nU67NCuFeFgC59Cwu6YFWjRjC3o1UnnSz+lQUk5vVXzflAv
iYZV+Omxbph+wUyXT1aZkH30x/SRa5fFzYsw46apG2RSVmtXWtPKtu++Ske2hHCH
b64ASLy99vYf9iyYlY5TiLQPfhqRh60nZA5jn2Q4sy4FIx5IADhVidaELFhSDiRi
7CmAWMjL5VX0YU9UrB7r96b2dULr8JJzUnMWcMmKwSDjFRFhoW3f7R6pQdIXheTq
8GpUVo+ZMkGn7m3Iu6wVl+js53NKJd3Sdl6vXt7v/vd5G38Gpc/yMR4MlsCxxwwT
RTyJA2hIwjdhuXGuWE59ilvKfT3GAIqbBbK2kPR86Rm9Ax96uSlQ+ZugfRXqBQU7
vMsUs75Z03TIRac8TWyvj4wA1xYXPvON4GTilAOpLy/Xf6B9F6l0KXI42otXw70P
DsJLrvnn2B861T0Ag8YYR3H+jiLKyRlvRUPogy+ocsWgWih1MoEYrFRN2/rRikr7
RM9EE9U13jium6qZkLwD
=QNvM
-----END PGP SIGNATURE-----

--=-AchlR9i8qRoHaehcWJfv--

