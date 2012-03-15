Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756013Ab2COGu0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 02:50:26 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57202 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755434Ab2COGuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 02:50:23 -0400
Date: Thu, 15 Mar 2012 17:50:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Magnus Damm <damm@opensource.se>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the arm-soc tree with Linus' tree
Message-Id: <20120315175000.897f1172c296d4a687be0537@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_17_50_00_+1100_PIrwKDEQ5CZdHgqx"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_17_50_00_+1100_PIrwKDEQ5CZdHgqx
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-shmobile/board-mackerel.c between commit 1740d3448012
("ARM: mach-shmobile: mackerel: Reserve DMA memory for the frame buffer")
from Linus' tree and commit 5d7220ec000f ("ARM: mach-shmobile: sh7372
map_io and init_early update") from the arm-soc tree.

The latter moved the code to another file
arch/arm/mach-shmobile/setup-sh7372.c and I have no idea how to fix this
up, so I just removed the change done by the former.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Mar_2012_17_50_00_+1100_PIrwKDEQ5CZdHgqx
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYZEYAAoJEECxmPOUX5FE5foP/3fxDWdMRLbw/TsNPHKrs+U1
FxhXP5MnaFPKJWa8FE/+iUQ0BryJCN0evOHYTRJ1wx1FvuY0zTijMA5YibICBIBz
rfKYh7RuG7tZU5x14ZWWW56qCI7DSHLhqx+KTupfzljnOXnMmjEMGJiIK5g5+kXK
pAWHGRj/HizCVXz+C4zTbj54D+/q0uuBKCpvQ7tLcTXGx+1GP802Qi5gIfxV9+E7
++aG6SZoEnXGJjrsrCfVa8dXorMr1hL82f3D1al+BIdblMt7wmGqf8iInv7QwLhA
e/+hk0kFV/g+z+I8LEq2rxZddd0DBOEksGcuUSA/uZQHg+BvjB7SyMNorC7FBAN6
32vhxVkOqL+DGDD1B2xNHbhJhJ9jYirqsBf4kWRi01NuCATeArwhV5rlojgJm927
4FRFISZkZSbBVCB8ikuggngsPEFHyqkSm1yMaXC8ylfNLkdhTTC0wYUeTLODdHhA
a2A9pzDP/Nw6YI4KNw3t+c85DUu9PqjGeELeTckHx4bGup70bu46ivZOvSmjv9IT
g+pcZkX0PINuqnZHhtieZc3Tugvx5Q2/XPq6LuNGnM9TBynStW0HEE2IGUzmnW38
cHcoVbING3XJxZiY9K/LnUy/6tY3A5daCpCvUMkd+mWQamaY8mZXBdHbOUriRVdH
3pzxkyMfc/nPdof5R6Ak
=kbYc
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_17_50_00_+1100_PIrwKDEQ5CZdHgqx--
