Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750942Ab2JLECW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 00:02:22 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49586 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750735Ab2JLECV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 00:02:21 -0400
Date: Fri, 12 Oct 2012 15:02:15 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jeff Layton <jlayton@redhat.com>
Subject: linux-next: manual merge of the signal tree with the vfs tree
Message-Id: <20121012150215.e0cdeb26e2f7ec898129432f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__12_Oct_2012_15_02_15_+1100_UWWKtfm06tI4eloR"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__12_Oct_2012_15_02_15_+1100_UWWKtfm06tI4eloR
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/mn10300/kernel/process.c between commit 2a5e5beb88c5 ("vfs: define
struct filename and have getname() return it") from the vfs tree and
commit 8f1597e959a3 ("mn10300: switch to generic sys_execve()") from the
signal tree.

The latter removed the function modified by the former, so I did that and
can carry the fix as necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__12_Oct_2012_15_02_15_+1100_UWWKtfm06tI4eloR
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQd5ZHAAoJEECxmPOUX5FED5kP+wcViuv5BALL+2B6n0Cpa7fE
NaQPliDSpxgBpNYkfPOU/EawV+uBBvV9WFQ6ZN0JSTsNotW93/GbW00gePzLWgnv
MP+BY90nyGZonNCGV9Rei+XvcvYoJTttksULnXJe1QOhsTpzS//wdg/tiblsbN1q
YXVRMlo3bqv807um9ut9vMtTsuA1fuiZyJOVCaj8AC+Iqav2t/nk4CKV4oY1iSDs
kO2Iles8QYUC0rvRkcHV4ZO7oyeJ+VCebuTCozxsbDQxnyo1C9WRmorioP162XuM
1xhJjRi41cDwDc0CYyZWeQ5qx7VzExcZ4f+AX98TKa0SHrqgUn+LT0bjpKqf/mfz
8QrehaTXIwHg3T+NwURIbjgRnzw7aAvyC+Yhj+D0b020KhQqMd+z23IiydtR+47r
QqsfCB/XxWR8D1+JxJxkvtfoMN0g9zpOx67M/+sTFFjbQqAiaSFmo28SpH82RAm5
pqo5QfUG4/Mgp1AxIABfXWkyq4+0BXsHD5jxBnk9vfAwDUprx+nXk3dMTXmrb7EW
e+sLrlIoGKPaeT+h+pp8JVkTZ/Eh27ZgphTBYizTwABtSKqbHGWFq1bV+RHuXmdY
EPeuzg6seJnVlIh3GsCYWy/r5u8hmdAOsn16dfrumDzMgTSq+W2uksDiFmwOJrWL
gSTDrOcy+5PWRqTfGI3E
=jNuf
-----END PGP SIGNATURE-----

--Signature=_Fri__12_Oct_2012_15_02_15_+1100_UWWKtfm06tI4eloR--
