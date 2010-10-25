Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab0JYBMu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Oct 2010 21:12:50 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37786 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751479Ab0JYBMs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Oct 2010 21:12:48 -0400
Date: Mon, 25 Oct 2010 12:12:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the mmc tree
Message-Id: <20101025121238.db983f90.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__25_Oct_2010_12_12_38_+1100_kaIWNxW5l+iXcrK6"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Oct_2010_12_12_38_+1100_kaIWNxW5l+iXcrK6
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mmc/card/block.c:57: error: 'CONFIG_MMC_BLOCK_MINORS' undeclared he=
re (not in a function)

Caused by commit d8714fbfc66e16fc64a4525c02eebc34bac8385c ("mmc: make
number of mmcblk minors configurable").  Forget to include a Kconfig
update?

I have used the mmc tree from next-20101022 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Oct_2010_12_12_38_+1100_kaIWNxW5l+iXcrK6
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMxNmGAAoJEDMEi1NhKgbsn/QIAJ8Frolbjy/66XzmfpBt+bU0
Yae3oPqHVxQZKovkhOwb0SeK5cMS/7yizoAfgmgUpaWXgBiC65hdTj9/9TnIMb2d
r5P5dofGKPtiW/4vY4xL02k6Qyo6iamI20Vf7NgnQF3uj3xHUhsmb14MTlGYcY9L
Xtc23dDiUqGHCPYYuWcBpmIsvyMPaFtr2pYlthmCYIHcPsdN7m0m5B2j027dUz7G
F39hzd7gWovI7vFXTRCqaOYwzU9H3jU8rZm/ib/npBPnsD9kwT+TJK2iR38N9zns
zX6IJkPP1jFszuvAJI4EahjsPFRgCudZ952aMY3saPDdeHNgcMhrT76Ai6VFd6w=
=Z6v1
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Oct_2010_12_12_38_+1100_kaIWNxW5l+iXcrK6--
