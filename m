Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753393Ab1L1HQt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 02:16:49 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:37728 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab1L1HQr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 02:16:47 -0500
Date: Wed, 28 Dec 2011 18:16:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the rr tree
Message-Id: <20111228181640.d299620c8e66237509fbba37@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_18_16_40_+1100_QEizd7v/yjjGQuel"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_18_16_40_+1100_QEizd7v/yjjGQuel
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr tree, today's linux-next build (x86_64 allmodconfig)
produced this warning:

drivers/net/virtio_net.c: In function 'virtnet_open':
drivers/net/virtio_net.c:732:3: warning: passing argument 1 of 'queue_delay=
ed_work' from incompatible pointer type [enabled by default]
include/linux/workqueue.h:352:12: note: expected 'struct workqueue_struct *=
' but argument is of type 'struct workqueue_struct **'

Introduced by commit c49a776ffe1b ("virtio_net: use non-reentrant workqueue=
").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_18_16_40_+1100_QEizd7v/yjjGQuel
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+sJYAAoJEECxmPOUX5FEp2EP/juvr9AbIKe2cgJxQlSmiN5Z
b0SRVm9dUkRzobZvLmeGDz3eU3yiCiThb733IgKiGBqnenhRYssG6vw99LXduSvV
2LaFKiWteQqvEaYvOGlXEqtyuepyJ/wScnh5zcgrtEHq2aPJubVje3fxvK2PrC9u
t/Th6YrJeGy6nvqFwjHGX11G3zpDwXamBLK513YXRWbWCv5WX7yHLUur3lyJ+KL3
HUpupda70X6AFjXxMVg9uvwsQ7//tERo/qgo/mMnHcIzD8KB0EpwdzOxWNcrZtPL
/oSF0am/xD5F0NQjGmcDM2e54KJmJhAWpUFWnpdk4d1sCNJd9MIZRoRoTwq2VFuZ
dpGHp0Q7CmbCuA+0tBpEuVE5wT/t57cAGkTXtlgIfjnTaOHHlbS956MEGRPzuz5S
cbldx66EURAxE8iIaRLZB8JJEvHcIXKLOBxyW2KeKTXEebpSWPLIRtjmt1w7tUOJ
8tDW4N3rSCpQVl9B8tddJZRQgn2aPRwt4UzIBbhmuydUp3i+oQ6fiQ2SLXHhYZGX
yTxoYDKPc+GTdn39xqzQqjD6cSRlkVz1S9BGSnLxD0EI/Uz7L07gO95psKdU7fHp
Y/YIzwS3PY+ccEXhxO2AL8vu0YaOcaPvWFGF1HqLMsb2c9Ce4K2WUXO7ZWMsbpmp
MPymseuocN26AjW9Ggcu
=OZgO
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_18_16_40_+1100_QEizd7v/yjjGQuel--
