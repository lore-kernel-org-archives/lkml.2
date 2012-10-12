Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751583Ab2JLEGr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 00:06:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42072 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750744Ab2JLEGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 00:06:45 -0400
Date: Fri, 12 Oct 2012 15:06:43 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20121012150643.11f54c87d0d03ad4e37f4ce9@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_15_06_43_+1100_i9+6VeYOpkvaTP86"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_15_06_43_+1100_i9+6VeYOpkvaTP86
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/powerpc/kernel/process.c between commit 2a5e5beb88c5 ("vfs: define
struct filename and have getname() return it") from the vfs tree and
commit be6abfa769fa ("powerpc: switch to generic sys_execve
()/kernel_execve()") from the signal tree.

The latter rewrote the function modified by the former, so I used the
latter and can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_15_06_43_+1100_i9+6VeYOpkvaTP86
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd5dTAAoJEECxmPOUX5FEFW0P/AsPJmUVrhoSMsfutQLjP890
yAND9oqGl7WwA4rTgFNmquxXcVMd5cTuZjBbLMUOqJCU2C05nZu4d4e5mnMyn/GN
m/UWk3aYEJRzU4qBUmeZCMjlbNqfjVHd5ITwCIouOq5jSx8A7UzJzHOKRlcRCdxF
pIhNxmhyF/V8EuPCXJrwp7t6Ol0jDgKXBS0uKc3TaditriyPXTJkWjaCEp123IhZ
5DDh90yinuZz24sH7AvYBbyfJ+hnx5eDr/U7vFIP6qgIV2mGy9OZOu0p8hcq/1fO
A9kcRnduhsUqqBHUa5kt49yg/1PFU6oZuGj6yxYFoqpjxndbbOqwHrFh+XF/OlZP
fmtfk/W2T6k+nKEZz6OQUdQFkNtL/Ay7JmybJ+RrwQ9DET39fd5g3BmMnpuX+T6o
h+d5fAY57VqXNCoqF29xQ5mcCgrKhEysjwRYXBssGLqzKpbwg59rmgpGdrVyJyAF
QI4a/+0Ayicv8kQy/ISDY0nh0xPK5DbPDktHwh8FyCZX8haLov71IJFlFe81sBhH
xP8ZLjI7vRdLVO7OovGVpSW/3akNdKe53b92wyVYFn8u3Ishuly1cyPELfWo1iRL
Ocr0kArG6AfNXpwUVgsQf/nvX4gofZAyPChN8XrMRxTjlksZgNOYTO7/xdrC6HkI
jj8++UwEq8+Zrt3GENW/
=GFa6
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_15_06_43_+1100_i9+6VeYOpkvaTP86--
