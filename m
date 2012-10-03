Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751172Ab2JCEMa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 00:12:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42117 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab2JCEM2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 00:12:28 -0400
Date: Wed, 3 Oct 2012 14:12:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Kosina <jkosina@suse.cz>,
        Haojian Zhuang <haojian.zhuang@gmail.com>
Subject: linux-next: manual merge of the mfd tree with Linus' tree
Message-Id: <20121003141219.529f565dc7950ea12257026b@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__3_Oct_2012_14_12_19_+1000_7pA/HCtkW0jxEAhJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__3_Oct_2012_14_12_19_+1000_7pA/HCtkW0jxEAhJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

Today's linux-next merge of the mfd tree got a conflict in
drivers/video/backlight/88pm860x_bl.c between commit e1c9ac420ef1
("Revert "backlight: fix memory leak on obscure error path"") from Linus'
tree and commit a6ccdcd98c39 ("mfd: 88pm860x: Use REG resource for
backlight") from the mfd tree.

I used the mfd tree version and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__3_Oct_2012_14_12_19_+1000_7pA/HCtkW0jxEAhJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQa7sjAAoJEECxmPOUX5FEhpIP/0jltKkL1yIPFULcr2lxdNTk
RYeBru9/7dKH4ltH4UdeB6l7fUkv7K9WRMw1/uKzG1fgr5VvHFyJlZqSwY72pfm6
4OSTcP9kQHmlK5G3h5rjI4du542tl9xo/RmMFUGsVJ+IKd4j/DOC/LCmQ0SO3TeM
C/o/KkHNe3iYJtCwEHioBZy86E7KjiCi1AoGvy9g0XGb3gnVjcsnoWVSEA/MKIuz
Tnx3PAgzmLY6TQTTTy0w+KCQdjGE/0tFQx245/fuo3nVo0pzyUDDTOY9IzsyLHDi
KRxAi80mIE6WJac668Dqsm9qJ12FieNPbppqky4i/GT0KRuPIikpcfX9Cyai2qWZ
gKt7/h53fKRpaVfAkwI/anz3vQcydeDtpfqAYi6adEQD5nmj1ATgm8CwMD7k0UYH
EtlML3cYlGLZOJRsvDvL3gVaY6mqXGIW60h6jXU4YLELUn7l58LK4UxiEr/c7gUD
Z2+Y5+nLpzTOpeJPNslDR74EQNnY8mEgm1JyAGcx2JIErOs4gfVB/fDD1SncswVS
Hr3AvKPVy74f4fqNWBwbYrpZk4thVNT4+j7VxJO2A+Qyr6axKzp6Xd9LvZO9NYlm
eltOKlm5dNPV/XBRY6l+wN4kZ8FRLiwTmdBqGrqbvbqFKcfLb8riIhacs44TJ9X8
a7Z3zkAqDXbuL6SXX02w
=XwA9
-----END PGP SIGNATURE-----

--Signature=_Wed__3_Oct_2012_14_12_19_+1000_7pA/HCtkW0jxEAhJ--
