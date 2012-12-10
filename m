Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753690Ab2LJI6K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 03:58:10 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:47313 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644Ab2LJI6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 03:58:07 -0500
Date: Mon, 10 Dec 2012 19:58:05 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: build failure after merge of the akpm tree
Message-Id: <20121210195805.0dbb562b5e890cb8e35f3116@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__10_Dec_2012_19_58_05_+1100_0LGLlZv9nlrCO29="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__10_Dec_2012_19_58_05_+1100_0LGLlZv9nlrCO29=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "do_take_over_console" [drivers/video/console/fbcon.ko] undefined!

Caused by commit "fb: rework locking to fix lock ordering on takeover".

I have reverted that commit (and the following fix patch) for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__10_Dec_2012_19_58_05_+1100_0LGLlZv9nlrCO29=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQxaQdAAoJEECxmPOUX5FElMQP/RD63wGeyRwVnDnf7De2qQtx
xA8Yd57f/mBpKC3x5TUhTzf5NdjeJBvGlVtNn8qIiBWjsGyWpvKovumYzrEsXxYp
OryZZYooSRhKE/8vK/wWZJV7HDi79tnf7IjdAKchF8HjvkBmxpUFMZxMVMYfSc64
BJOIx03HCAVGpYYVgdS07gem7CUAgHoWy4xlnigoZerU/W3rOM/u2hcqUDZYqq4/
Cq2UsHBZLcPrAyBCYLdYDDRCCBLQmGA7E8qxpCcamvt7NejJbfbt8ntGpu6aAAVL
dZu2eNL8fGldR6+g3F9Krc06NDL4zo/ldhbA27x3xFv3ce1RhBFzyLc9RWSx+Zqi
x5Y5pgkl7hkaF0tKIAQjZZ6teTLyUzojl/hZJNUOkzXir7aKqq3h6FyOiKnPvK4X
MY73EXSL96uW9vuvk6/W7zyotEfe7aWnhHoLUV3ame4dy5kWXA1WnqkdpDWKIrKe
9M+5D0b09/QTJ9kv2fnZWPa6l1bTvAEg5fRunJiJGJS0UvX8tWwJoxGl7qNAb8Gx
XVkGQMddi4v2uJVxOoA7IyYuY/7KzwDQvu0T2iINdpHHb7iRTWl+6bqkXvJ5QkFz
EuJopID3YiqIsTxEkZ8ZRoIax6Za2ork+lgCn2D8loGAofV5+I7Kr79oo3AxDRvE
/slD3ZD3aXW6RVhUwIfs
=9yK/
-----END PGP SIGNATURE-----

--Signature=_Mon__10_Dec_2012_19_58_05_+1100_0LGLlZv9nlrCO29=--
