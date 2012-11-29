Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab2K2GTp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:19:45 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:49580 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751392Ab2K2GTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:19:43 -0500
Date: Thu, 29 Nov 2012 17:19:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Philipp Reisner <philipp.reisner@linbit.com>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Jens Axboe <axboe@kernel.dk>, Lukas Czerner <lczerner@redhat.com>
Subject: linux-next: build warnings after merge of the akpm tree
Message-Id: <20121129171939.8539a56adf1f0f7ae518f4ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_17_19_39_+1100_vMvHEMfJNPi4yXY2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_17_19_39_+1100_vMvHEMfJNPi4yXY2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

After merging the akpm tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

In file included from drivers/block/drbd/drbd_bitmap.c:32:0:
drivers/block/drbd/drbd_int.h:2339:0: warning: "__wait_event_lock_irq" rede=
fined [enabled by default]
include/linux/wait.h:554:0: note: this is the location of the previous defi=
nition
drivers/block/drbd/drbd_int.h:2358:0: warning: "wait_event_lock_irq" redefi=
ned [enabled by default]
include/linux/wait.h:621:0: note: this is the location of the previous defi=
nition
In file included from drivers/block/drbd/drbd_receiver.c:46:0:
drivers/block/drbd/drbd_int.h:2339:0: warning: "__wait_event_lock_irq" rede=
fined [enabled by default]
include/linux/wait.h:554:0: note: this is the location of the previous defi=
nition
drivers/block/drbd/drbd_int.h:2358:0: warning: "wait_event_lock_irq" redefi=
ned [enabled by default]
include/linux/wait.h:621:0: note: this is the location of the previous defi=
nition
In file included from drivers/block/drbd/drbd_proc.c:34:0:
drivers/block/drbd/drbd_int.h:2339:0: warning: "__wait_event_lock_irq" rede=
fined [enabled by default]
include/linux/wait.h:554:0: note: this is the location of the previous defi=
nition
drivers/block/drbd/drbd_int.h:2358:0: warning: "wait_event_lock_irq" redefi=
ned [enabled by default]
include/linux/wait.h:621:0: note: this is the location of the previous defi=
nition
In file included from drivers/block/drbd/drbd_worker.c:38:0:
drivers/block/drbd/drbd_int.h:2339:0: warning: "__wait_event_lock_irq" rede=
fined [enabled by default]
include/linux/wait.h:554:0: note: this is the location of the previous defi=
nition
drivers/block/drbd/drbd_int.h:2358:0: warning: "wait_event_lock_irq" redefi=
ned [enabled by default]
include/linux/wait.h:621:0: note: this is the location of the previous defi=
nition
In file included from drivers/block/drbd/drbd_actlog.c:31:0:
drivers/block/drbd/drbd_int.h:2339:0: warning: "__wait_event_lock_irq" rede=
fined [enabled by default]
include/linux/wait.h:554:0: note: this is the location of the previous defi=
nition
drivers/block/drbd/drbd_int.h:2358:0: warning: "wait_event_lock_irq" redefi=
ned [enabled by default]
include/linux/wait.h:621:0: note: this is the location of the previous defi=
nition
In file included from drivers/block/drbd/drbd_req.c:30:0:
drivers/block/drbd/drbd_int.h:2339:0: warning: "__wait_event_lock_irq" rede=
fined [enabled by default]
include/linux/wait.h:554:0: note: this is the location of the previous defi=
nition
drivers/block/drbd/drbd_int.h:2358:0: warning: "wait_event_lock_irq" redefi=
ned [enabled by default]
include/linux/wait.h:621:0: note: this is the location of the previous defi=
nition

Introduced by the interaction of commit c1fd29a11f43 ("drbd: Fix a race
condition that can lead to a BUG()") from the block tree and commit
"wait: add wait_event_lock_irq() interface" from the akpm tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Nov_2012_17_19_39_+1100_vMvHEMfJNPi4yXY2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtv57AAoJEECxmPOUX5FEw38QAJ+FcJys6W9LPpQQQYWiWOvb
QEHYyFSlsddhc1cjPSo8AFtBpeM94H71vj+nOgNut9lw8DX0zYe2E+Hj2YLTYZ+v
09uaEKnqfOaelEYhzOEhdLJ2uBupqk9lgjATpynoNiUUzPCl814H1LAEze0V8gxG
orOASo7JEVxPby+KtqsVpaaJRRaxOVglrvPZQF3Vc4xT/DRbhOW9el5GZX/Jro5w
1KvqBzk2a/Qzmaw+tlEj0VJUQEAaKk03S1EB9bC5VUqFfRwjeJwxgVH/uyZWKEC6
wB+Sny1JwE1P+yhSlBz459s3FWqAKW33y3j12NSYDeHV3AVQ/DERs8ZEtKBtZ9jQ
3HC9drvhKwpewVma3abZy/QpF0XudZ7AQuvd1dDrwVl8eWc0Wtm7a7YJkPktOheD
GfixAf9vqvOMQE/IXHibUnxosg5jDHqaQo7V82PsZ9eNZFfe6TsvCdKRwnFA+Gu3
Lt3hNpAhXvd5Qb/wyJN6kyaBs5PvnJ+CC5KLqReRIRKd0lO6ZbIEGrEbsoQB2Csl
SGtmQBIT0WHZic2lMLdT/f33OFVut5l4qeyCJd6dfAtCDUuWyLTfXXXcjJZ4GLqs
+8hglZzZnAjWqsgZeuPsD4ZZAomdDNhq1R0+huVhKJApNWQgeA8UH3O8u/0HLRk9
63PN53seWBkZvNk8Cnos
=ivIK
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_17_19_39_+1100_vMvHEMfJNPi4yXY2--
