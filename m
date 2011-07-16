Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1GPMhf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jul 2011 08:37:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:49610 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754246Ab1GPMhI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jul 2011 08:37:08 -0400
Date: Sat, 16 Jul 2011 19:30:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Per Forlin <per.forlin@linaro.org>
Subject: linux-next: build failure after merge of the mmc tree
Message-Id: <20110716193000.dcf43d072610fbaa873e28d1@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__16_Jul_2011_19_30_00_+1000_=FLtUogb8iN5/hQP"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__16_Jul_2011_19_30_00_+1000_=FLtUogb8iN5/hQP
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

After merging the mmc tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mmc/core/core.c:2141:1: error: redefinition of '__inittest'
drivers/mmc/core/core.c:125:1: note: previous definition of '__inittest' wa=
s here
drivers/mmc/core/core.c:2141:1: error: redefinition of 'init_module'
drivers/mmc/core/core.c:125:1: note: previous definition of 'init_module' w=
as here

Seems to be caused by commit 65cae3d20446 ("mmc: core: add random fault
injection").

I have used the mmc tree from next-20110707 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__16_Jul_2011_19_30_00_+1000_=FLtUogb8iN5/hQP
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOIVoYAAoJEDMEi1NhKgbsUoAH/1cDWo3silqKFMqMAkktxw41
kiAJ0nv0qhYf7KzzJYNGexsaWWXcHWBiHczSR+sAcnxuSy5YAwdeXzoNa/srebhv
TL0mdz28RA/qnTZ6rWNU/gg2RrXKL8kfS6k8SQCQp9NMFEmNlciiJG9INnHEZoZJ
Xq0/kE0+F52VNichPgY768hhXE36RqLGMjcsAgNy1ZDjqHcOI0CVibl4HTXL1A+R
EZEy6Ae0ETXWhFqPi8aiUcwD83CpWXGQ6ng/eBz0+K0ELZtHmVRKtob+yOtHgQQJ
qMGDPTBltxok5Uh72D5Wjp3uziWPM2D4tknLWZESut7KBtlV6FV3ImZOWRU8Wwc=
=W3NO
-----END PGP SIGNATURE-----

--Signature=_Sat__16_Jul_2011_19_30_00_+1000_=FLtUogb8iN5/hQP--
