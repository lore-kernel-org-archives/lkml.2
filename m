Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751475Ab2EJEdj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 00:33:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38556 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750899Ab2EJEdh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 00:33:37 -0400
Date: Thu, 10 May 2012 14:33:29 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ola Lilja <ola.o.lilja@stericsson.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120510143329.4cef3cd78ce5ea55416b1d93@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__10_May_2012_14_33_29_+1000_bUBnHGrz8OGXHH3I"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__10_May_2012_14_33_29_+1000_bUBnHGrz8OGXHH3I
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

In file included from sound/soc/ux500/ux500_msp_dai.c:21:0:
include/linux/mfd/dbx500-prcmu.h:614:19: error: redefinition of 'prcmu_abb_=
read'
include/linux/mfd/db8500-prcmu.h:673:19: note: previous definition of 'prcm=
u_abb_read' was here
include/linux/mfd/dbx500-prcmu.h:619:19: error: redefinition of 'prcmu_abb_=
write'
include/linux/mfd/db8500-prcmu.h:678:19: note: previous definition of 'prcm=
u_abb_write' was here
include/linux/mfd/dbx500-prcmu.h:630:19: error: redefinition of 'prcmu_conf=
ig_clkout'
include/linux/mfd/db8500-prcmu.h:643:19: note: previous definition of 'prcm=
u_config_clkout' was here
include/linux/mfd/dbx500-prcmu.h:692:20: error: redefinition of 'prcmu_ac_w=
ake_req'
include/linux/mfd/db8500-prcmu.h:683:20: note: previous definition of 'prcm=
u_ac_wake_req' was here
include/linux/mfd/dbx500-prcmu.h:694:20: error: redefinition of 'prcmu_ac_s=
leep_req'
include/linux/mfd/db8500-prcmu.h:685:20: note: previous definition of 'prcm=
u_ac_sleep_req' was here
sound/soc/ux500/ux500_msp_dai.c:23:27: fatal error: mach/hardware.h: No suc=
h file or directory
sound/soc/ux500/ux500_msp_i2s.c:21:27: fatal error: mach/hardware.h: No suc=
h file or directory

Possibly caused by commit 3592b7f69a54 ("ASoC: Ux500: Add MSP I2S-driver").

I have used the version of the sound-asoc tree from next-20120508 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__10_May_2012_14_33_29_+1000_bUBnHGrz8OGXHH3I
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPq0UZAAoJEECxmPOUX5FE+rYP/1Osxlem2GbPXObr7ZaUN5mE
Xzu4r764bBa1Zj3V3z/4970SKZR9OytZNsK12c9dMGcOWxQKZ1dWkc46wOFkWiPz
oDtUFYvYLXgJyEQNyW8dhgxF4ufguKk9eiCdaZ2fyBu154Xl0dF1aV2wgXDJ6+Sl
Ckwe59K+a5lZpTd04yBD0oeCkPUDFKgUvGzVz2JrgqBgqg2mfaCs7bEkIKnwrwCb
yccqndIsM88k1IY95flsxdSvBculR38Q4CKuV4/chN/XTlBmBT6lHm4ohj6oq25o
jzCJ2BYyXKS6i/Y77mLRLs7CmVECRi235sVlJ/xIiWTT390aZidHU1C5zMUH9pvb
MdoWdjgR2ETl/zjq2ygbneIWrmOb+2bjjYlxr5VgblDLndB45nab4/P9ryPw6hG0
hhQ0yHLArsyfRZOvpOfFG9RQpF4Jhf0aYd/8FUiBgAG2G0JtalRoT8Mv2I5hNw43
FABCdSsCLb94yzz0KTuVi2yzu9D3zL+MbjZN9KTJ+jxBtrrrRMGhw0QIgMIOfi/2
nFwtHkbh/LIsYPeb5arro5ih7whnuFCNxqQpU/0+HG1UEhAeJOaAFdAkossyJSwH
0wdF9122oD6C3zPUlWbKGD0Qq6TjpUgveO+q2fFnS5KWmBu+gZiQ+WrwySoVL315
l3dffq598slT57ildI8w
=EL9j
-----END PGP SIGNATURE-----

--Signature=_Thu__10_May_2012_14_33_29_+1000_bUBnHGrz8OGXHH3I--
