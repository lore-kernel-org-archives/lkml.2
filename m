Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752375Ab2IZE6J (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 00:58:09 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:57963 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751918Ab2IZE6H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 00:58:07 -0400
Date: Wed, 26 Sep 2012 14:57:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Subject: linux-next: manual merge of the arm-soc tree with the fbdev tree
Message-Id: <20120926145756.e00474c7d2f1a4734c10fb0e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__26_Sep_2012_14_57_56_+1000_eqvLJw9Sh+yzJ6f_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__26_Sep_2012_14_57_56_+1000_eqvLJw9Sh+yzJ6f_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/video/msm/mdp_hw.h between commit 8abf0b31e161 ("video: msm:
Remove useless mach/* includes") from the fbdev tree and commit
1ef21f6343ff ("ARM: msm: move platform_data definitions") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/msm/mdp_hw.h
index 2a84137,a0bacf5..0000000
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@@ -15,7 -15,8 +15,7 @@@
  #ifndef _MDP_HW_H_
  #define _MDP_HW_H_
 =20
- #include <mach/msm_fb.h>
 -#include <mach/msm_iomap.h>
+ #include <linux/platform_data/video-msm_fb.h>
 =20
  struct mdp_info {
  	struct mdp_device mdp_dev;

--Signature=_Wed__26_Sep_2012_14_57_56_+1000_eqvLJw9Sh+yzJ6f_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYotUAAoJEECxmPOUX5FEnj0QAKb7X78h9TgtTwUscGo7wufc
lYvRKiaPEiUMmWxyHivnb40rx0NtDMW90YJd8RfZ4Bk3eOLQLwiMZjFNEKf6rQa6
wj6BfblzSEPimuF1kxfS4t9FksjFuUId30kcz/ZiQR35Tecd9GgzV1eigOg7+5rA
rAhMKVe51XpIESzqZgnyL7MZBe0mQDpIVAccvBc5/S2b76TFG+wBq/fYzE2QslNc
UsHYr+dI7k8DXPqt3ttbFfNBJlwsAZem+FyuVlFJt4FL+VPPKpVsW1YSoKzAHarD
m7kOAf5CJs0zO6zoovx3SecCJk8Ei9iQFUv+5/VjOjVA9DhaEne3XI6jQzYqIYUB
dv2W8d2TJeY79Z2aBA56icexnXGQ9bI9M8pNQouDkDfZHlNqTnUtnWGubw2KAYia
iclxOJ02Kf8DV43FLrbD0dXD2FGyJJNbRo3SVZo+gWv7XB47c7rPZqcMZmNYZKRB
mbs3edBmXVGOFFtNRo0cKiro5BdOxMNmf0Cdfyq/woDO/y8xYfzl8wKmywzcDOyQ
9+dDsQ03mbWaVgGuDfJvk8q/wKe+s6vm9cp7q8C/BChwiTNk/WM05kN6eN686Jev
qH16afg/uVd25M7AgueWA0V9Ymbj3F6ycBU0UrzuuhTD9UqrfsyqX4iDodKwG86P
Ve4uA/uS6ZwD9r6QjfzJ
=6b9S
-----END PGP SIGNATURE-----

--Signature=_Wed__26_Sep_2012_14_57_56_+1000_eqvLJw9Sh+yzJ6f_--
