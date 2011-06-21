Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755339Ab1FUDDn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 23:03:43 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:47583 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753773Ab1FUDDm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 23:03:42 -0400
Date: Tue, 21 Jun 2011 13:03:31 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20110621130331.368aaf74.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__21_Jun_2011_13_03_31_+1000_vreZH9ggnfM3zE.S"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__21_Jun_2011_13_03_31_+1000_vreZH9ggnfM3zE.S
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

drivers/mfd/wm831x-core.c: In function 'wm831x_device_init':
drivers/mfd/wm831x-core.c:1507:12: error: 'WM831X_XTAL_ENA' undeclared (fir=
st use in this function)

Caused by commit e1af6eaa2160 ("mfd: Only register wm831x RTC device if
the 32.768kHz crystal is enabled").

I have used the mfd tree from next-20110620 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__21_Jun_2011_13_03_31_+1000_vreZH9ggnfM3zE.S
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOAAoDAAoJEDMEi1NhKgbs4h4H/2Shpg6Qrpy+UQ90BujiXaEa
5HOI0fZfh41w9BwILT/duZEcDGaKcMdpAOVJOHrdI4M1nR5p7DIi1CEv5VJtgoHE
zRiY/4uRpNQtYbvy5woIIOxo44jkVQIJXLAKVMcWFyverQ8C1w+LF9/cvvgBtUhS
ZON7LCVHXbiQYnnaVmfeNfp/VmRcbr18+xZLxV1jwFqoGBSFBXHX8GSaRx3tZiHN
3Wf0Y3eIdUo7ab/UQdWcVUJG1wjuwJmMh6S0+CMZRh1QSDRnH7oz2T1AjXvxZzIH
XaoZQIIzzNT0k9vBLgHH5ZtO66xbzGOvguFgt6h9sShMCiKNEIARKIHxseKehA4=
=8VGB
-----END PGP SIGNATURE-----

--Signature=_Tue__21_Jun_2011_13_03_31_+1000_vreZH9ggnfM3zE.S--
