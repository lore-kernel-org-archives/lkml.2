Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752085Ab1IVGpi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 02:45:38 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:44331 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751294Ab1IVGpe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 02:45:34 -0400
Date: Thu, 22 Sep 2011 16:45:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Justin P. Mattock" <justinmattock@gmail.com>
Subject: linux-next: manual merge of the trivial tree with the arm-soc tree
Message-Id: <20110922164513.084ba0366628d756f0499669@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__22_Sep_2011_16_45_13_+1000_F4Gydq87FT8AE32X"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__22_Sep_2011_16_45_13_+1000_F4Gydq87FT8AE32X
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/mach-nuc93x/time.c between commit 6adc1e7ff19d ("ARM:
mach-nuc93x: delete") from the arm-soc tree and commit 699324871fcc
("treewide: remove extra semicolons from various parts of the kernel")
from the trivial tree.

The former removed the file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__22_Sep_2011_16_45_13_+1000_F4Gydq87FT8AE32X
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOetl5AAoJEDMEi1NhKgbsQ/UIAI6VxxCE+WBgfHMXbzCCJoLG
2pA5aDeDLJkwaVQcv6RLxsMF3OdBmoihhHQUBx8uYy3gdso6T6BriKIh9t/qhwh8
weg0DmYihfrj8nVwdiIsWse9sbVWPJJhA6itWZ09rZYz8NTwOgwJs0ONI6XjgQDq
bxwzf/BTfq5CBUBVpMxMKuY+1s6xb77zgRKrymMQBboq5Zn5wLteUUazRpJW+lya
zU7+h4y6yRWnuLAwlcrEV03DOX097JDHOyjaM//IKISW8+PMxsnNUhrBvsBT68yG
QtObfmsZh1CUnecsXmzV5fCiAsgUzUsgCIp0gE0Qc45k2mPqlJgYrx9OyDRMvLA=
=ZEwL
-----END PGP SIGNATURE-----

--Signature=_Thu__22_Sep_2011_16_45_13_+1000_F4Gydq87FT8AE32X--
