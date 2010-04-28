Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab0D1DxG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Apr 2010 23:53:06 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:53113 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753717Ab0D1DxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Apr 2010 23:53:04 -0400
Date: Wed, 28 Apr 2010 13:52:58 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jens Axboe <jens.axboe@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the block tree
Message-Id: <20100428135258.35e3efdb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.0; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__28_Apr_2010_13_52_58_+1000_a/4PJN9/kGiNi/9."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Apr_2010_13_52_58_+1000_a/4PJN9/kGiNi/9.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jens,

After merging the block tree, today's linux-next build (x86_64
allmodconfig) failed like this:

include/linux/coda_psdev.h:4: included file 'linux/backing-dev.h' is not ex=
ported

Caused by commit 5163d90076729413cb882d3dd5c3d3cfb5b9f035 ("coda: add bdi
backing to mount session").

I have used the version of the block tree from next-20100427 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Apr_2010_13_52_58_+1000_a/4PJN9/kGiNi/9.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkvXsRoACgkQjjKRsyhoI8ySfgCfRKL189UiT5DPsCRRjJcHUZid
i5UAn3xDqica4nSkk6cvpGEg1EeKc3w+
=jmKm
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Apr_2010_13_52_58_+1000_a/4PJN9/kGiNi/9.--
