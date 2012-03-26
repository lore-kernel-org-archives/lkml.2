Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751274Ab2CZEMN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 00:12:13 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55346 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057Ab2CZEMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 00:12:10 -0400
Date: Mon, 26 Mar 2012 15:11:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Dan Williams <dan.j.williams@intel.com>
Subject: linux-next: build warning after merge of the final tree
Message-Id: <20120326151147.30727745f5a3410d87f391dc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__26_Mar_2012_15_11_47_+1100_ySqO76+w6Ym==KQo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__26_Mar_2012_15_11_47_+1100_ySqO76+w6Ym==KQo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (sparc32 defconfig)
produced these warnings (and many similar):

In file included from drivers/scsi/hosts.c:41:0:
drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM" is not defin=
ed [-Wundef]
drivers/scsi/scsi_priv.h:166:1: warning: "__enabled_CONFIG_PM_MODULE" is no=
t defined [-Wundef]

Introduced by commit a6a95fad44f1 ("scsi, sd: limit the scope of the
async probe domain").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__26_Mar_2012_15_11_47_+1100_ySqO76+w6Ym==KQo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPb+yDAAoJEECxmPOUX5FEUv8P/0drDHyuUGfH1dBw6BfleHWl
QmxmHJKAMb1lf4VhLArB/00tVqo+TmysuEQNGwXvLaLZrTUoEDuVkaGRqw2ByyWe
y2cSx7upsTwHmfu5kRn9WcKDFtBSjN2LcJEI21mAMM9ijSJWhB9KaJgV9WsCckq7
ioCmk/bNy9PZSDXwpnPHlVLlev7gGHIjOQ7dSzMI5YhuS3gByQkRW/stcde2s3Z+
T/Fn3/q7JggOti3lQZAD9HnO2/8JoNhu8c9hZI8fJiHKZgJst1h6qHKp4y21Jj6L
G3yCqETFdgHg/EDYa8uulw/4bGCDktd29PgM/ktBriVyoDvo4Qx0DIkq1dd5ScMf
BsdviTt4KYzEBsdY+Rw+vVF5kcDjlRTnD9alRxtTzlRVdrsl3ydDC0x/RXeRl5w7
9cJQ5x8YjJJFlzSg5N75fjRGvCO7UENOpBOK7lPyU7zPAgwRdvVDldZVhZFiuG/U
78/tMwz0oWem4UAv6kwzqfhhatMhRH+2bsU1Xj+HgMXgGnBmhEKzUODVZ1ofNP47
+WcXbnqIDnnbx1yO3b3OIqjRURZQTUvoCeZdWH8I+TiRdtyKF6Ynx9Tyo4mbVktV
BvuUzHpr1BSZjUXVYbjzJHtNa515UHWt9fB4w0+Cv2L+c5MOnNTIl/I44gbEw91L
lHRbr3w2+vNAF+MQ9BpA
=dVUm
-----END PGP SIGNATURE-----

--Signature=_Mon__26_Mar_2012_15_11_47_+1100_ySqO76+w6Ym==KQo--
