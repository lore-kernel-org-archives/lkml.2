Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab2I0D1O (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 23:27:14 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41750 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab2I0D1M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 23:27:12 -0400
Date: Thu, 27 Sep 2012 13:27:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20120927132700.7e6ef4b714fb4a8251e68775@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_13_27_00_+1000_SCroD2VAo/P.GRyr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_13_27_00_+1000_SCroD2VAo/P.GRyr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86
64_allmodconfig) failed like this:

usr/include/linux/fs.h:13: included file 'linux/percpu-rwsem.h' is not expo=
rted

Caused by commit 62ac665ff9fc ("blockdev: turn a rw semaphore into a
percpu rw semaphore").

I have used the block tree from next-20120926 for today.  This will also
affect the device-mapper tree which is based on the block tree (of which I
will also use the next-20120926 version).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Sep_2012_13_27_00_+1000_SCroD2VAo/P.GRyr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY8eEAAoJEECxmPOUX5FEBWsP/0tfVlPWPrKJklc9ZZVtL0Y7
U3RFAgXtXGyMP85NdolzkNyP5SRNUbIMQwtWuUmChgyd/kZ9wcaOLq0CKMjX/htD
jtHSWzVJyoCmad66ZGYOzfq4UyUiPxO1y4YADAvrWivBihQkJWqrJ/Osy8HQW1Va
Mz93UYaeRTLfKuHpzRuV8ecZIgRpGiJwqiodRV4JL7eN4Opf16P8rdysJpE2fPCJ
vLBU+YoApHbKvSXeKPeUadP8oInyj0iwKef75pXPSPEqLRoOJrACj1OyJl0kazU9
veMYOQW6U40fRz0X5olh2xgy3unH9HjUY8tIwE5/1c+yz6TsqRPukjZOYdcNEbXZ
T5nx0BsSCXYTU3FzcSgUxwaop3V+N5kMxcSUaN20oqUKSv1P/5UREs6bN58n3PQX
1darjBZryZEPaRE34ilJtQZ4ZwPsiGKn05Soeh/k/4M+SUc04wC2EZn/WMPrDhm/
aQN+efF3k+9eNjmNbQapfetZq3SyR/VHLg2kt3jPNqkJ3hFWggvFRV8d6/XDhJmo
FKxfoJe4GlnHtuOIWNQngNztd8t86dl76EQ42HrivpodMt1bNvuGLsb+Luvex6T6
h0gzDVUWhUSsHHghycsRX206CI8OIj7ovTsoXoJm8HVA81IE/wBNMMqVbS9mht20
4ukPXOobosnE9qBLEDwS
=SVVZ
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_13_27_00_+1000_SCroD2VAo/P.GRyr--
