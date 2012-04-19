Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751365Ab2DSEsb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 00:48:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41467 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750850Ab2DSEs2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 00:48:28 -0400
Date: Thu, 19 Apr 2012 14:48:15 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Subject: linux-next: build failure after merge of the driver-core tree
Message-Id: <20120419144815.50f7c3d30d88e6259665313d@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_14_48_15_+1000_2kCm4KdWNc+vYxBB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_14_48_15_+1000_2kCm4KdWNc+vYxBB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the driver-core tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

lib/klist.c: In function 'klist_iter_init_node':
lib/klist.c:287:4: error: too few arguments to function 'kref_put'
include/linux/kref.h:92:19: note: declared here

Caused by commit a15d49fd3094 ("driver core: check start node in
klist_iter_init_node").  That really hasn't been build tested, has it?

I have used the driver-core tree from next-20120418 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__19_Apr_2012_14_48_15_+1000_2kCm4KdWNc+vYxBB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj5kPAAoJEECxmPOUX5FEJT8P/iUuTU8eGDpBxh1DoRIPYSiL
wC8c0Md/PwSVzPmvgsx/FIa35FJsV79vRvYbfGRBNQ/XTsbq8X3f7ys+gjeQjZlm
VlxazM497woK3U1HRi94E/g/M3pAp1dJK15+kftPgBRXimgmUyqZR5WGoVW50YVt
1KSzUzW6SJb0aLDqkECcLb1o0GoWVjt2EY+uAPITH79v6saYA4+3JyhoPHJn93pE
o0M4tKezkpwP0SzcCJ8vSiSqz6c+oqMplOZNmhT69AEtrGiU9LZTZX4bimmhyoX/
Z7DtlPLz2AmashyAIjRNBB/evJR37rXcPb6KCu8EzkriY8Ocmj6bCITYMI/PUbCI
T/NtAdbytXw4Hmb7JvUOGpvHsMTubLWzWoyXSN5pI/JN9mM+ZLCsDjnlGOuZ4Uma
uZiVzkmI/UZOJS5scrNmCthtMTv6GPhP7IZmeXBHqSZPW43+rYzXOupeI2pVtMea
swiwiLh0g6LjNgYKqbogkZSlB+Ff8MMQexDdO+iFmkZ8kj1tBeuc7XlOUuWd1E8C
U5a4wjakJasSkw5eMb0RHA1tOA6PRM4hDPmMIkgM+8R+pj2wkpSsbAZMZoWUAs0+
2xKLAv7T685WUPG2F2Ozg9m6FGhhNzpbhcOjNyNiyi7O5IQRHDSeB/x4h18uhJmw
F5y9DAYiKLKuv3+xG8xw
=BGht
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_14_48_15_+1000_2kCm4KdWNc+vYxBB--
