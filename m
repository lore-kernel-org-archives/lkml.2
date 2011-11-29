Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754210Ab1K2DqU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 22:46:20 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:40893 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752251Ab1K2DqS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 22:46:18 -0500
Date: Tue, 29 Nov 2011 14:46:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: linux-next: manual merge of the akpm tree with the vhost tree
Message-Id: <20111129144610.896c4efc877512776823ffaf@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__29_Nov_2011_14_46_10_+1100_PjDkuFiX+Y67v_hL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__29_Nov_2011_14_46_10_+1100_PjDkuFiX+Y67v_hL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

Today's linux-next merge of the akpn tree got a conflict in
arch/x86/Kconfig between commit 4673ca8eb369 ("lib: move GENERIC_IOMAP to
lib/Kconfig") from the vhost tree and commit c7b45fe332ee ("mm,slub,x86:
decouple size of struct page from CONFIG_CMPXCHG_LOCAL") from the akpm
tree.

Just overlapping additions.  I fixed it up and can carry the fix as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Tue__29_Nov_2011_14_46_10_+1100_PjDkuFiX+Y67v_hL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO1FWCAAoJEECxmPOUX5FEWz8P/jpZASvddOFJs8G6pR8nwtoR
4k5AE2MuD73awHtBE/Usv2kJFDn8ZMDQX6tjGZdIlIgSAS4GRCIrVPTl+oC7hHa1
VSEj4yT64oec6Sh6mnAUo2t4Sz4yQYsPLVsAB1HHyuEi+gZrbLNHbqViCXLIyN88
mXnRTEd+pTcCmdUTPqOLHTrYvjkvHalEEa3FZ16xJMXyDDQd8dBsLpaxZIvtrwHP
BJqSr263ZVeAUAKrOzeaW/de5xbKoBt3BZPSiYikN5HWZxR+60R+hZ1O+PIgdZd3
Q95U+1OFRXd8+U2xN1PhCHrRgw7vOb20H7j5WqWZ4+Ihq66Z+bTKFaZ9LKGDNBSw
rsmxdZhKOx/BQZb6tNtoQEUMHDOtoil7vfykz+qgYZipCrQ+mgj+4rNb65U18lTu
3aX3z/FpuwgaOxL0bt7bmzXqAgrKXtwZyduQri19dwM6B9wENiD5UZ8zURzV8BVB
FymQ7xDHQ8UopyOpnmofo6dFlYXr1mlwLxval1dFLtoY2dvC5sDzZbSih74momFe
P7SqMMp3f48UOPJ/QhAj7oVMo5JWIjfsVZmbKiNW0QlAhyvoBaidi/WkeqrLA6/Q
ip6wVOwcZH3DpGe/YB3T9xG53PgDJ19T6HZx2kvbT7CIKUDCUrhuysdmNi159hdd
RIZqCz55KvoRelwsuuV4
=4Vvy
-----END PGP SIGNATURE-----

--Signature=_Tue__29_Nov_2011_14_46_10_+1100_PjDkuFiX+Y67v_hL--
