Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753200Ab2LZCsn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 21:48:43 -0500
Received: from mailout2.samsung.com ([203.254.224.25]:58658 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752968Ab2LZCsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 21:48:40 -0500
X-AuditID: cbfee61b-b7f616d00000319b-f9-50da65861fcd
Message-id: <1356490106.16178.146.camel@kjgkr>
Subject: Re: [PATCH review] f2fs: Don't assign e_id in f2fs_acl_from_disk
From: Jaegeuk Kim <jaegeuk.kim@samsung.com>
Reply-to: jaegeuk.kim@samsung.com
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Date: Wed, 26 Dec 2012 11:48:26 +0900
In-reply-to: <87obhh63wz.fsf@xmission.com>
References: <87obhh63wz.fsf@xmission.com>
Organization: samsung
Content-type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature"; boundary="=-BrLpLRpAfyc54VAPcTGn"
X-Mailer: Evolution 3.2.3-0ubuntu6
MIME-version: 1.0
DLP-Filter: Pass
X-MTR: 20000000000000000@CPGS
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpnleLIzCtJLcpLzFFi42I5/e+ZgW5b6q0Ag4lPhS327D3JYnF51xw2
	ByaPz5vkAhijuGxSUnMyy1KL9O0SuDJuvZ3HXrBMsOLDsU+MDYxr+bsYOTgkBEwkjl0s72Lk
	BDLFJC7cW8/WxcjFISSwjFHi6YsprBAJE4klbz6zQiSmM0r87zjADOG8ZpSYtOolE0gVr4Ce
	xKVtTYwgtrCAp8S+l7/ZQTawCWhLbN5vABIWElCUeLv/LthQEQF9iZvvJ4FtYxY4wygx/95+
	sDksAqoS/3YvBJvDKaAlsWb+RTaIZk2JSa/+sIDY/AKiEidbP4HVMAtUSfx/tJYd4lIlid3t
	newQ9whK/Jh8jwVipoDEt8mHWCA+lpXYBHG/hMA9dokzMz4yQfRKShxccYNlAqP4LCRjZyEZ
	BRHXlGjd/psdwtaWWLbwNTOEbSuxbt17qBobiU1XFzBC2PIS29/OYV7AyL6KUTS1ILmgOCk9
	10ivODG3uDQvXS85P3cTIyQqpXcwrmqwOMQowMGoxMPL+etmgBBrYllxZe4hRhWgOY82rL7A
	KMWSl5+XqiTC6/wRKM2bklhZlVqUH19UmpNafIgxGejTicxSosn5wESSVxJvaGxsYmZiamJu
	aWpuSpqwkjhvs0dKgJBAemJJanZqakFqEcwWJg5OqQbGlDsJFas3fds7p23/49PzT6x6sPb4
	Rps+Rr67J4QfJv097nzt5IqNCaaX/Dbcf9x5sK3vtvjPBb/D7miLtkzu85P/F5dUz//Ev7x7
	eRWL44U9L0q1/dXusts9fOu39bHb4Z5i+aK8CBvh6QIum990x0+/fO9PQ/sZyWQ1XfG+a8qH
	ti1XjM5QVWIpzkg01GIuKk4EALviowQaAwAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOKsWRmVeSWpSXmKPExsVy+t9jQd221FsBBh1t/BZ79p5ksbi8aw6b
	A5PH501yAYxRDYw2GamJKalFCql5yfkpmXnptkrewfHO8aZmBoa6hpYW5koKeYm5qbZKLj4B
	um6ZOUCjlRTKEnNKgUIBicXFSvp2mCaEhrjpWsA0Ruj6hgTB9RgZoIGEdYwZt97OYy9YJljx
	4dgnxgbGtfxdjJwcEgImEkvefGaFsMUkLtxbz9bFyMUhJDCdUeJ/xwFmCOc1o8SkVS+ZQKp4
	BfQkLm1rYgSxhQU8Jfa9/M3excjBwSagLbF5vwFIWEhAUeLt/rtgQ0UE9CVuvp8ENpRZ4Ayj
	xPx7+8HmsAioSvzbvRBsDqeAlsSa+RfZIJo1JSa9+sMCYvMLiEqcbP0EVsMsUCXx/9FadohL
	lSR2t3eyQ9wjKPFj8j2WCYyCs5CUzUKSgohrSrRu/80OYWtLLFv4mhnCtpVYt+49VI2NxKar
	CxghbHmJ7W/nMC9gZF/FKJpakFxQnJSea6RXnJhbXJqXrpecn7uJERz1z6R3MK5qsDjEKMDB
	qMTDy/nrZoAQa2JZcWXuIUYVoDmPNqy+wCjFkpefl6okwuv8ESjNm5JYWZValB9fVJqTWnyI
	MRkYGhOZpUST84GJKq8k3tDYxMzI0sjMwsjE3Jw0YSVx3maPlAAhgfTEktTs1NSC1CKYLUwc
	nFINjErZdRzyvT47j3AxVAYxXT55U+Fqtobi0yjm6ZM0nGdpOlbk33/e0LbD7lL0c2/5eUl1
	V9iXK+0UXLZYzrVolbZB29wGicLCTUwPTt7kkly68VFO7UfeyJ+nAzJmsHEH1LI0lsmufbm5
	IDR6gd1hJxaPLIbgO094P+x6u/rHkyl2LOlT5kyMUmIpzkg01GIuKk4EAMjLbpBKAwAA
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-BrLpLRpAfyc54VAPcTGn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

2012-12-25 (=ED=99=94), 16:41 -0800, Eric W. Biederman:
> With user namespaces enabled building f2fs fails with:
>=20
>  CC      fs/f2fs/acl.o
> fs/f2fs/acl.c: In function =E2=80=98f2fs_acl_from_disk=E2=80=99:
> fs/f2fs/acl.c:85:21: error: =E2=80=98struct posix_acl_entry=E2=80=99 has =
no member named =E2=80=98e_id=E2=80=99
> make[2]: *** [fs/f2fs/acl.o] Error 1
> make[2]: Target `__build' not remade because of errors.
>=20
> e_id is a backwards compatibility field only used for file systems
> that haven't been converted to use kuids and kgids.  When the posix
> acl tag field is neither ACL_USER nor ACL_GROUP assigning e_id is
> unnecessary.  Remove the assignment so f2fs will build with user
> namespaces enabled.
>=20
> Cc: Jaegeuk Kim <jaegeuk.kim@samsung.com>
> Cc: Namjae Jeon <namjae.jeon@samsung.com>
> Cc: Amit Sahrawat <a.sahrawat@samsung.com>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Jaegeuk Kim <jaegeuk.kim@samsung.com>

--=20
Jaegeuk Kim
Samsung

--=-BrLpLRpAfyc54VAPcTGn
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJQ2mV6AAoJEEAUqH6CSFDSb6wP/js1kKHJOpb/bPBGoLD012nh
5iRGPzkr227wiDMaDf/+eqkdTQhDjwCuHzfsWSykWkSKN6pdUIf40GI8DNLB3sbT
7lwNEU9Ek7DtL95NLrYDcyf3ZejCh33us616icnuGFCmRrct5khdqUbu0Aup3Bwu
bdA2lTJJrtwIuW1Adra0VZBJwi/3lDUSTd2i4tfO6Dx1nR4hnsxqUBp6lqvQDur8
9g+ae/fbteWjvWki89Mzzgtg3gDJtYZC3xiUOnw9QyqEh6mI3xaVQKiqb815mlw0
Rwc7TH06RoHKi3quCYfzCy0kocoRzKa4ydqmkGJAjsSSDMxwswWgNHgziUdaU2ZX
03hjz/+Wk8rgaG5vr9rUYctjznACYD2gyqqxb7xh1nbPOE/unKJXeeF6pxnGeQCz
Kce4ezDOgrVQbby42N+bNA/B+u+VtLN76fu9J1sUbKyp8PcSIV/Wf+i5hc2svc9x
78lmRKaLqP0LS4rDibyHmT4SoAGvEsxinhhMsStPw12mXCrGjc15n2cmbqBHFiNt
PSb757BXo6WPQPavo1ypgLS/BWfcsQzHXAR385lqIF+wZCpT0UDoubwvBNWkHjrw
77dS3LGER7nSZf6nEYI4NRFtRtNtpgYywrB9hCZQtNWu8Od6y7qUg77o/OGEzXJa
4zPucCNJ3CfOXO0YJy0Q
=+htg
-----END PGP SIGNATURE-----

--=-BrLpLRpAfyc54VAPcTGn--

