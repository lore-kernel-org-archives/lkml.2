Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753594Ab2ISEfK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 00:35:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42757 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751399Ab2ISEfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 00:35:07 -0400
Date: Wed, 19 Sep 2012 14:35:05 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Devendra Naga <devendra.aaru@gmail.com>
Subject: linux-next: manual merge of the staging tree with the usb tree
Message-Id: <20120919143505.76e9d77d320ed278f7ce4798@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Sep_2012_14_35_05_+1000_m2e_oT7qMrt_lL0O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Sep_2012_14_35_05_+1000_m2e_oT7qMrt_lL0O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/serqt_usb2/serqt_usb2.c between commit e8656b02ef35
("USB: serial: serqt_usb2: remove dbg() usage") from the usb tree and
commit 623c2bb2c59a ("staging: serqt_usb2: fix dbg print when kzalloc
failed to allocate qt_port") from the staging tree.

The former removes the line changed by the latter, so I just did that (no
action is required).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Sep_2012_14_35_05_+1000_m2e_oT7qMrt_lL0O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWUt5AAoJEECxmPOUX5FE40AQAI1Zo5wnKWiHv3C8JRf1xFtc
ejOekieAnb61N8+NbIV6oGIPF1UihLaaiJqqV1y7tP0PFjkfWOOnyJt9+nZO3q2c
C4H94XrniS7qPuAZ/i2AlDXl+NgGuxjRX2+kh1zFtJnYKG3xy0S/coMVbESBDIHD
9kXv053upMaowMYN4xaD9YbSrr98/smF24PlkUEjojlQNR6WBTNpADiB5M01tfR3
fGpVXGHDsxiUDuCqFNAwrAKq4RnRbq9C26QxRKljOXlaDmRO4BbYALH3K/o6LUvO
ikL6PcPSgbKeQlT7d01QFnOWe3X6zXXyvVSdFF8ShDuVoU3a4H4XwxF2M33qlhiQ
fcXNXnaOcGQfpor2JqSCjU9/WG1DhxD+2Pci2P6K3edNSZKTAfLRcd0aiXWuZIpN
Z/fp0Sq4NhJfiiDy/5BkGEQEdaV8YqYlgtqKTWZtxFV66/RAFQb8MYiUFU0lI9UR
RrGa46K+6Y6S7GXhXrY4Zss+teTL620FqYBdQnLwEc63Z3OSir58kOSB0axgq9+T
W08JHd+9cWcIKTEW0n1hvcAfPms+sI56K4AztcM8UXJPPgZpSzuUToxrdORHx1IQ
IJVevzPLAc5bf9GyumrvUXnlyqPfJFft0RwqjcBL1VB8JkRLhkG7rF96na8ud4Nj
+NN/u9C57LHSN79svxuX
=snvO
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Sep_2012_14_35_05_+1000_m2e_oT7qMrt_lL0O--
