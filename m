Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753609Ab2BCG6Z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Feb 2012 01:58:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58320 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753093Ab2BCG6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Feb 2012 01:58:24 -0500
Message-ID: <1328252423.6750.47.camel@sauron.fi.intel.com>
Subject: Re: [PATCH 2/4] jffs2: Remove unnecessary OOM messages
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Joe Perches <joe@perches.com>
Cc: David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org
Date: Fri, 03 Feb 2012 09:00:23 +0200
In-Reply-To: <98592226b940c1fa59ced4a28418343508714161.1328049542.git.joe@perches.com>
References: <cover.1328049542.git.joe@perches.com>
	 <98592226b940c1fa59ced4a28418343508714161.1328049542.git.joe@perches.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-IGf1R394+TPJhxFq/2C3"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-IGf1R394+TPJhxFq/2C3
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2012-01-31 at 14:42 -0800, Joe Perches wrote:
> Per call site OOM messages are unnecessary.
> k.alloc and v.alloc failures use dump_stack().
>=20
> Signed-off-by: Joe Perches <joe@perches.com>

Pushed to l2-mtd.git, thanks!

--=20
Best Regards,
Artem Bityutskiy

--=-IGf1R394+TPJhxFq/2C3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPK4YHAAoJECmIfjd9wqK04o4P/jseB136azEkGBN+9OdQCjh1
m6Gdxu8z1VPvH+/E0okJmoYrzl3W6Vwf56tz3lsDflOorFHtlnsTTEA0SR0Ci5/V
o8CPoAMpvXR9ZuM4ZKezKqT8rrz6R9Kxcy6jaOfq3RPkjz0s5inqJvJa8jMHkpD5
BfqUKxo/vQsTU3UObgenm6QfVd+D+GTDL6dw0QiPuGV1NqwwxiJZqUUrcoKU16l0
UsW7Q/pYfVSYaJrr+SOcqEewi1GpBNDk9oG9gCygb6lwHt9t/uO8LFJRHoXpiDpd
ZEITACcEkshZqEfP4nk5TNAOZUwMxqQ2QqazraKWvTnjr7GbzmpbPx1MGxtYEKqR
wae/M1EXJDzRqk2Qd2hElX7mD4Gr73y5eUKEdmO37im5z7UddvVlZNCFZcwY71EL
2JkE43LftqEHwas9rNSM2/2wKCuBMn7Stw4yUUtD33g7MRx31p/abE29hWyF8Juo
DUeMQ56E+aGsLXLmLLrs4ZC3XQLueARuBtwugy42PjAUMDYdRoUOt9kZWFl7a0g6
d8uTrjqHSZ/wDlzm6JC59rxcjPvGUeY7q1FLaYfb8cyrVVKVoCOAOjMu8yWVgFBU
h7WawO7/hLH24hCuUjgKVpYWX5vgV80YHXom9IW0s7Tj0f7F6AaaJhH/AE6PWQwA
akY6iQKc14NTQAmD2bl4
=BP6n
-----END PGP SIGNATURE-----

--=-IGf1R394+TPJhxFq/2C3--

