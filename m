Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757731Ab2B2MK3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 07:10:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:60795 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab2B2MK2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 07:10:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.50.191.163 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330517573.3545.110.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/4] jffs2: logging message neatening
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Wed, 29 Feb 2012 14:12:53 +0200
In-Reply-To: <1330517290.3545.107.camel@sauron.fi.intel.com>
References: <cover.1329349881.git.joe@perches.com>
	 <1330517290.3545.107.camel@sauron.fi.intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-NrbDzQOsnndpXfpvplAB"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NrbDzQOsnndpXfpvplAB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-29 at 14:08 +0200, Artem Bityutskiy wrote:
> Also, there are several checkpatch.pl complaints, please, take a look:

Ok, I copy-pasted them, but actually took a look now and the
checkpatch.pl ones are non-issues.

--=20
Best Regards,
Artem Bityutskiy

--=-NrbDzQOsnndpXfpvplAB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPThZFAAoJECmIfjd9wqK0VDMQAJpbtyEiSmRGKzWMpQi+nJkU
pANwLZvQ9+hFOeiOap1/3GNDhTHBJjSygh4ZT0xES5N5GReqglbbmvNE2JkRCV1m
GQTCzsFHgw3JZF48+rRhKkgyWUx+8/n5zmYNPxB8Op1JrdUozwGj2+y1Q2UedluT
4KiVT2PjxIy8mfZQaCaEl3C7rDPlT2XNsJYn7PiJ2Sjmfuz0xZhycgm+SfOFR+uV
Hj/wKFohEXC+UdAqXX3ecWE49awG/KlRIWBNmsuK0qos3HKKdnL9emVDcksnSQBF
5W1uF2t3c1bwe69XIJJYKizSnJbBc2o0JjhgWgd9iRJeCBzmCBgwd1HW5EmWdH+f
Q1oyPh54gU1Ozgrp8fHv/Ohcv8hHxq/4pG0ZXCCH6iUQu85TlUwbr+yjAd4e4+oV
Kh+Sjzsu9afylihUN5+JIsjwOabd03mBEMjOf20vnoCSXjO84JmRZ1zQI7/QT8j+
7WwIFmNzKVa7BftjuaQFvC5K1VCHRM3uJcgBh9MO3tC4aHLfO2F1wwYHTp9bYc10
xm09iJ8YEZPWYVjsbi7a4nnODi87gKpOYSecAFBUrKDgEI6jyt0IPmIZslkjp7zb
Ovb08uWXMkQ1pqft1oB2mdNUNHJKwqvfU4r9O6hVJb5dg4hCHKI9jnCMEMvbCmhQ
j5IHgXR5QhuTgpSwhkpZ
=2q3O
-----END PGP SIGNATURE-----

--=-NrbDzQOsnndpXfpvplAB--

