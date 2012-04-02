Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754009Ab2DBBeg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Apr 2012 21:34:36 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42152 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753772Ab2DBBef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Apr 2012 21:34:35 -0400
Date: Mon, 2 Apr 2012 11:34:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120402113424.3e5981bd914d68a2fb8fcead@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__2_Apr_2012_11_34_24_+1000_fcHXUu6tMFhh1vqq"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Apr_2012_11_34_24_+1000_fcHXUu6tMFhh1vqq
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64_allmodc=
onfig)
failed like this:

sound/soc/codecs/max98095.c: In function 'max98095_jack_detect_enable':
sound/soc/codecs/max98095.c:2229:14: error: 'struct max98095_priv' has no m=
ember named 'jack_detect_delay'
sound/soc/codecs/max98095.c:2230:18: error: 'struct max98095_priv' has no m=
ember named 'jack_detect_delay'

Caused by commit 9dd90c5db040 ("ASoC: max98095: add jack detection").
At least build test, please.

I have used the sound-asoc tree from next-20120330 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Apr_2012_11_34_24_+1000_fcHXUu6tMFhh1vqq
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPeQIgAAoJEECxmPOUX5FECKUP/0+UIJ3W+hvRfJ2v3+ChLyaB
0Xt4kvYMn3JrTxpkcCUwHX/izkZ6gaahd8zz5kIE6iwoQ77CiHelL1yiZgWHxwE5
Bzg4nAZYo4Ra6X5e+dSGO65/fh1WR4a+tEgCwnrAMlQ3g3kY4Y6/t8LMBECQ2xEE
JAt44QNo82FwEbmI01wjjThc2WUztDon2mnpRjL/1uvlp0RBlPRpRD/o+9jMPKHQ
aYH+JQnqmThzDPK/n7TddIlHsfR3wSUSVnx/9Jp/VbAPeuknUw+KknUN+AVCl//V
3QF3UkxF+PR3SHG9iMMSI78Y+u7Ts7QXEFHUKYuu/BfXVEnYnLqEeHBTthN5GoWp
Wd4QUoSrBcKaTcArLDgChLvr1HGt+3Uzr8VGodhf9wxu6g6bFpFe13Mk6RHrQLCH
vKmSx1WlgaalthmsnxgCBMLNtCnkUC99KDXZ3yDDrk5sepbsk9p4lhiIJo5bV8WA
Llzf0RevPow9rMZLvNbZD7A7RE2Meb6XkS0sTFuwqjK83zMFjeu1LSJSJ5gLczYP
yTPm0FK4RQJNQ3+7DUhv7YnDSQxSQD0FR4UIWtVNFtRWSXIXGUkUvQbsWhRFbljg
dFpLYmqyxr54KKveswCtkom0L/DS3RUKkdn37bu/5nCEtBK5UT3ku5+JiYwa3dFt
97Xnih90O+Lna4EIat9Z
=kWyg
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Apr_2012_11_34_24_+1000_fcHXUu6tMFhh1vqq--
