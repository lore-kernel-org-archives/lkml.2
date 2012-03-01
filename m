Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab2CAHea (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 02:34:30 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59989 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757085Ab2CAHe2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 02:34:28 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of dedekind1@gmail.com designates 10.42.142.200 as permitted sender) smtp.mail=dedekind1@gmail.com; dkim=pass header.i=dedekind1@gmail.com
Message-ID: <1330587394.2384.1.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 0/4] jffs2: logging message neatening
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Thu, 01 Mar 2012 09:36:34 +0200
In-Reply-To: <1330542157.13689.17.camel@joe2Laptop>
References: <cover.1329349881.git.joe@perches.com>
	 <1330517290.3545.107.camel@sauron.fi.intel.com>
	 <1330542157.13689.17.camel@joe2Laptop>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-XVaUwrsE7LMNm5AHaqiz"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-XVaUwrsE7LMNm5AHaqiz
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2012-02-29 at 11:02 -0800, Joe Perches wrote:
> I believe this simply exposes a current defect rather than
> adds "new" ones.  It seems the old D1/D2 macros hide them.

OK, I'll take a closer look as soon as I have time.

> > Also, your patch does not apply cleanly to my l2-mtd tree - and this is
> > the tree which is currently used for merging MTD and JFFS2 stuff
> > upstream, and it is in linux-next as well. Would you send patches
> > against the l2 tree?
>=20
> This patchset applies cleanly against next-20120229
> Where is your git tree?

git://git.infradead.org/users/dedekind/l2-mtd.git

The conflicts were minor anyway and I am able to fix them up myself.

--=20
Best Regards,
Artem Bityutskiy

--=-XVaUwrsE7LMNm5AHaqiz
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJPTycCAAoJECmIfjd9wqK0E/QP+wUN3Lh6bW9bY95TUuz0oyzt
HlcqI4C/hVk+ofZzwYO2m1mKl7BIC5+o6Zn+x4Q3hAjGMNRurMgOmAYGzon5fUEa
OfjBbfVvOHvxd65LU1jPNN+v7W6gvbBi/bjiaaR1ucLwlY0vMhhv7RPY28odH7vG
Y5sOAk+qp+CLpmfOn6bLcPjr7gW+negRDWPlF/1j7m5hzfTGS9Q/F0WoxE3PsC38
HqAp5zQ96ShLNjnZfxIz19ImPAzSHmmJjXVCRL2b6mUquIUt52BZVEUTWrWINQmD
6XxI84V42T8EDSEslPKqSSuA++yZlcdtU+vzSS5xqDLB9TKs7suBTmfofZcgDzrH
AY4InDDoM8MB/OJPlp84sAtVAXeeWcJT+35DSjz+XHfiyo5HbuGQ69JX+M1pIi7G
5iANpUZzNX2aGo3QEn2g6MQQ1josP+A9da8B0GxQ5fvyMqHorlaDaXFxT6Xd8bz6
6f0ANUGZ+m7jg6ijM01XRhz0RaLPLEgw+qni7jmYdp9PiVxSF1c9GJMveNa87y1e
NT3OZRZ4djeb83z0Q22kTZYvWe0IpVtCkN5ATcA+h65yJSsL3sxYkko/f+kDHLH/
ia3V1V/At73yHLefcoMIuP0gOB1EybQW7UVv49c/yrxAwlmjVLDMLIKyCb9gopRb
dedP440Bb9ccf9HYce+c
=hF7e
-----END PGP SIGNATURE-----

--=-XVaUwrsE7LMNm5AHaqiz--

