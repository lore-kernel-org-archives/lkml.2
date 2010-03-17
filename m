Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752058Ab0CQBwM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 21:52:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44986 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751826Ab0CQBwK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 21:52:10 -0400
Date: Wed, 17 Mar 2010 12:52:00 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ben Blum <bblum@andrew.cmu.edu>, Li Zefan <lizf@cn.fujitsu.com>
Subject: linux-next: manual merge of the block tree with Linus' tree
Message-Id: <20100317125200.5deb72ba.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.0 (GTK+ 2.18.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Mar_2010_12_52_00_+1100_SjcB.D_1NLNbX_WS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Mar_2010_12_52_00_+1100_SjcB.D_1NLNbX_WS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

Today's linux-next merge of the block tree got a conflict in
block/Kconfig between commit 67523c48aa74d5637848edeccf285af1c60bf14a
("cgroups: blkio subsystem as module") from Linus' tree and commit
910ac735bad53ce54741a72a5b19ab69794ae069 ("block: make CONFIG_BLK_CGROUP
visible") from the block tree.

I used the block tree version.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Mar_2010_12_52_00_+1100_SjcB.D_1NLNbX_WS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkugNcAACgkQjjKRsyhoI8zSLACfRqN1d1f2PUc7isufoIGmqPbY
bkQAoIhn41pEb2L1/U7R8WNHF3M/D5um
=D0z9
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Mar_2010_12_52_00_+1100_SjcB.D_1NLNbX_WS--
