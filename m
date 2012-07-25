Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab2GYEIl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jul 2012 00:08:41 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42762 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750755Ab2GYEIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jul 2012 00:08:40 -0400
Date: Wed, 25 Jul 2012 14:08:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lee Schermerhorn <lee.schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: linux-next: manual merge of the akpm tree with the tip tree
Message-Id: <20120725140827.4332a5448e4d8d200164ea2e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Jul_2012_14_08_27_+1000_p=79pxaS4wx=iRaE"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jul_2012_14_08_27_+1000_p=79pxaS4wx=iRaE
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpm tree got a conflict in mm/migrate.c
between the tip tree and commit "mm: memcg: fix compaction/migration
failing due to memcg limits" from the akpm tree.

The commit 4783af477d3d ("mm: Migrate misplaced page") was removed (among
several others) from the tip tree since yesterday (and thus linux-next)
so the above akpm tree patch no longer applies.

I have dropped this patch form the akpm tree (and the following patches
as well:
mm-memcg-fix-compaction-migration-failing-due-to-memcg-limits-checkpatch-fi=
xes
mm: memcg: push down PageSwapCache check into uncharge entry functions
mm: memcg: only check for PageSwapCache when uncharging anon
mm: memcg: remove unneeded shmem charge type
mm: memcg: remove needless !mm fixup to init_mm when charging
)

Hopefully this doesn't cause other problems.  I guess that they will need
rebasing depending on what gets merged via the tip tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__25_Jul_2012_14_08_27_+1000_p=79pxaS4wx=iRaE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQD3E7AAoJEECxmPOUX5FEu9kP/0OjrUoyppntDw9aHInNceuO
ZjxHyO78epmp3pMDbeiuFxg5Br02mdfKdFr+o990ii76D45/FqXNZliNbmurBnG/
hKrejYqzivzo6Sba6MgokROpJwKnoemWvN9FPXdhDjgvwWI0B/XJgKMf5dCJPfkF
kI5Wgeyz0QdXSQrLk9JIraMmU/99WiP3jY70fRO7mSo9NK04l2m5+HY2ZGrL6jd4
glomxUVCcK9PZ0jWr0Vu1dmBpFA3FMjh/pjRfovi4rctBfTM5pmlLhkrqOk1Q50N
VU69xDiWF6GoiJFjsQDuwJ0mVN1Qrv8zx/w4rdd8fT2Bo5HKMB9J5wV5q2ssT3Ea
pqOxEm0T0tT8eeXFDG/ajX+jusdDOKx9UZkSXjPfet23e9GxKzoUNMscqKF/LQgB
CEP3VdVSe6FoxuWmUnFA/sH/2ylTOlhtJL1h8BAT981sOqbeJlk48PcYzA1xhQgY
gpjkRBT4m/f1nlCmtN3Kbjtzvb/yb9MNWZvDAAHnsbhKskiOnXDDucSYzu19P+7A
PQDc3dBx/aImfUXQ0aj45hAE1Bzeik88khHbC3RArxypjqDjpYujL3QBGsttpZBe
DNEwZE35miEQ5Z9TAbgwxkvD7G/Y1QGLXapP8m8wb/hyVM60e01eEdL54lHC9m4Z
OauI3BeRFXguFE5A/9zB
=cUWJ
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jul_2012_14_08_27_+1000_p=79pxaS4wx=iRaE--
