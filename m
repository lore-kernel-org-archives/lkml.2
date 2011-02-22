Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab1BVFWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 00:22:14 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:39950 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750836Ab1BVFWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 00:22:13 -0500
Date: Tue, 22 Feb 2011 16:22:06 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mattia Dongili <malattia@linux.it>
Subject: linux-next: build failure after merge of the drivers-x86 tree
Message-Id: <20110222162206.c3fb0636.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Feb_2011_16_22_06_+1100_K.I4kK91o+B1s4/S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Feb_2011_16_22_06_+1100_K.I4kK91o+B1s4/S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Matthew,

After merging the drivers-x86 tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/platform/x86/sony-laptop.c: In function 'sony_nc_handles_setup':
drivers/platform/x86/sony-laptop.c:772: error: invalid type argument of '->=
' (have 'struct device_attribute')
drivers/platform/x86/sony-laptop.c: In function 'sony_nc_kbd_backlight_setu=
p':
drivers/platform/x86/sony-laptop.c:1462: error: invalid type argument of '-=
>' (have 'struct device_attribute')
drivers/platform/x86/sony-laptop.c:1468: error: invalid type argument of '-=
>' (have 'struct device_attribute')

Caused by commit 73dd0f8d0f1f5ac19b56f343cfcf5876b31e699f ("sony-laptop:
cache handles and report them via sysfs").

Please build this stuff *before* putting it into linux-next.

I have used the drivers-x86 tree from next-20110221 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Feb_2011_16_22_06_+1100_K.I4kK91o+B1s4/S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNY0f+AAoJEDMEi1NhKgbsgN0H/iEFwktuhqszAEeZ159cMMPB
LNpKTarUaPkad5CghJ55TtnRcAb3+/k7ksHyBD+EspYDX/92wuD2XJwUOiku0bPC
uJcWsddxi2kZguKgHsV0HAO6CB9A5r88/sS5MDqw5/fBimd5UOc6f1o6k9ms/LMc
r2wQntyUDBNJ1rkB0+HKQ9kO75lQWld86va6o8DeA48+Gmg3388Xs21AiWeeZpFg
D4v/FjXsslba/YqHZDCMGlF7aN9hXB0Wr0qTaMDSjKcC4MVJwL1xkre+UoPn/mrq
2H1ZdMikc/svlsKbqc+seygMpaOf4w2oqzBv4cIjSRNiWNjNS6M7Ls1uLhQ8zYk=
=/89H
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Feb_2011_16_22_06_+1100_K.I4kK91o+B1s4/S--
