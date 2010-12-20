Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab0LTEbl (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 23:31:41 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:47208 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752103Ab0LTEbj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 23:31:39 -0500
Date: Mon, 20 Dec 2010 15:31:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?Ik1pY2hhxYIgTWlyb3PFgmF3Ig==?= <mirq-linux@rere.qmqm.pl>
Subject: linux-next: build warning after merge of the block tree
Message-Id: <20101220153127.ad8213b2.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__20_Dec_2010_15_31_27_+1100_1Kv+TIk0.51LJh/V"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__20_Dec_2010_15_31_27_+1100_1Kv+TIk0.51LJh/V
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (powerpc
ppc64_defconfig) produced this warning:

drivers/block/loop.c: In function 'lo_splice_actor':
drivers/block/loop.c:398: warning: unused variable 'ret'

Introduced by commit a8adbe378b56acd5945df70753c7e8f6fe223304
("fs/splice: Pull buf->ops->confirm() from splice_from_pipe actors").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__20_Dec_2010_15_31_27_+1100_1Kv+TIk0.51LJh/V
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNDtwfAAoJEDMEi1NhKgbsOG0H/3xIR08Dhw4UFTFm03rqvA/l
JyM09csakxENfa5OiwAlma1k6yUOoZ/dPOcqklMpWQNOEPdlmmDYrhiAZkc5TCOS
jhbmgoQ04RZe6UcJOc1pAp0RYAVQ83WUPt9yiFkEEjNLUqiiKfvK6yMjGFmcbVH0
9oMMhpWiedZa5dTdzspBHCim3Y2C31siHL9uLP3+wG4e1k+1rYdjCsrp9WL5B+Lt
YjIZ3k3r77I/zQ2SVAzPzGauKF0k0qFLSnZN8xLfY32M5hn+PE960DgorpcHpoo/
IkP+qGhzJ3cRrWITR3Lg4sfhc4f/FXmCbYfe7MrI054y+6vqmnkjaUEpAWqttCE=
=6orb
-----END PGP SIGNATURE-----

--Signature=_Mon__20_Dec_2010_15_31_27_+1100_1Kv+TIk0.51LJh/V--
