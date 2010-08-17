Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754556Ab0HQCVM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 22:21:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52312 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752509Ab0HQCVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 22:21:11 -0400
Date: Tue, 17 Aug 2010 12:21:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the sound-asoc tree
Message-Id: <20100817122103.5e14eaeb.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__17_Aug_2010_12_21_03_+1000_8ehT7ECfRuh2Mh__"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Aug_2010_12_21_03_+1000_8ehT7ECfRuh2Mh__
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi ,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

sound/soc/soc-core.c: In function 'snd_soc_register_dais':
sound/soc/soc-core.c:2919: warning: format '%d' expects type 'int', but arg=
ument 5 has type 'size_t'

Caused by commit f0fba2ad1b6b53d5360125c41953b7afcd6deff0 ("ASoC:
multi-component - ASoC Multi-Component Support").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Aug_2010_12_21_03_+1000_8ehT7ECfRuh2Mh__
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMafIPAAoJEDMEi1NhKgbsNtwH/2xY1JHw43btPUMZLZdTQF41
1U/juhxJTz68nHQorpmvO+5Tce83f13byFjh0BdiJYNBWuQ35BAouPRd5P4an+zp
WwLVV3ED88GYr0d9pbJemR75KA2VLzfRaXfCkvJb/QnsufxVMJcyKV1StVxrmmb3
P+idjkzN8v1g8SgVeQBdNKTtpqTiWzYPn1oHAQVIE3XCJoAjd0wSLcK5JlT/Nmze
X5BBYnYHDWoioc4mUZwVg8gCa4+mFsmXsgnFbb9txaj7QEeNBjO7meUHG4qrta3F
RiIaIg56rLLN+hhV/yLCUe/lB12HZMl9xFDJKdv8IJQgM6KC2sT36BGR3aPeFVU=
=UdSn
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Aug_2010_12_21_03_+1000_8ehT7ECfRuh2Mh__--
