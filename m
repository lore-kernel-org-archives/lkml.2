Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1KAHiZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 03:38:25 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:43786 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1KAHiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 03:38:24 -0400
Date: Tue, 1 Nov 2011 18:38:14 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>
Subject: linux-next: build failure after merge of the moduleh tree
Message-Id: <20111101183814.15c0f8af2b8e3664466a1307@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__1_Nov_2011_18_38_14_+1100_==3S8pWm4kYW6NiS"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__1_Nov_2011_18_38_14_+1100_==3S8pWm4kYW6NiS
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Paul,

After merging the moduleh tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/md/dm-bufio.c:988:1: warning: data definition has no type or storag=
e class [enabled by default]
drivers/md/dm-bufio.c:988:1: warning: type defaults to 'int' in declaration=
 of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:988:1: warning: parameter names (without types) in fu=
nction declaration [enabled by default]
drivers/md/dm-bufio.c:997:1: warning: data definition has no type or storag=
e class [enabled by default]
drivers/md/dm-bufio.c:997:1: warning: type defaults to 'int' in declaration=
 of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:997:1: warning: parameter names (without types) in fu=
nction declaration [enabled by default]
drivers/md/dm-bufio.c:1006:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1006:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1006:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1036:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1036:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1036:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1049:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1049:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1049:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1059:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1059:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1059:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1135:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1135:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1135:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1158:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1158:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1158:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1232:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1232:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1232:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1238:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1238:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1238:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1245:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1245:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1245:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1251:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1251:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1251:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1257:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1257:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1257:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1263:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1263:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1263:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1269:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1269:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1269:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1489:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1489:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1489:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1534:1: warning: data definition has no type or stora=
ge class [enabled by default]
drivers/md/dm-bufio.c:1534:1: warning: type defaults to 'int' in declaratio=
n of 'EXPORT_SYMBOL_GPL' [-Wimplicit-int]
drivers/md/dm-bufio.c:1534:1: warning: parameter names (without types) in f=
unction declaration [enabled by default]
drivers/md/dm-bufio.c:1676:63: error: expected ')' before 'ulong'
drivers/md/dm-bufio.c:1677:40: error: expected ')' before string constant
drivers/md/dm-bufio.c:1679:55: error: expected ')' before 'uint'
drivers/md/dm-bufio.c:1680:35: error: expected ')' before string constant
drivers/md/dm-bufio.c:1682:67: error: expected ')' before 'ulong'
drivers/md/dm-bufio.c:1683:40: error: expected ')' before string constant
drivers/md/dm-bufio.c:1685:79: error: expected ')' before 'ulong'
drivers/md/dm-bufio.c:1686:46: error: expected ')' before string constant
drivers/md/dm-bufio.c:1688:87: error: expected ')' before 'ulong'
drivers/md/dm-bufio.c:1689:50: error: expected ')' before string constant
drivers/md/dm-bufio.c:1691:73: error: expected ')' before 'ulong'
drivers/md/dm-bufio.c:1692:43: error: expected ')' before string constant
drivers/md/dm-bufio.c:1694:73: error: expected ')' before 'ulong'
drivers/md/dm-bufio.c:1695:43: error: expected ')' before string constant
drivers/md/dm-bufio.c:1697:15: error: expected declaration specifiers or '.=
..' before string constant
drivers/md/dm-bufio.c:1698:20: error: expected declaration specifiers or '.=
..' before string constant
drivers/md/dm-bufio.c:1699:16: error: expected declaration specifiers or '.=
..' before string constant

Caused by commit 0b068238c5ef ("The dm-bufio interface allows you to do
cached I/O on devices") interacting with the modul.h split up.  This file
should have included module.h in any case.

I have added this merg fix patch (Alasdair, this could be added to the
device-mapper tree):

From: Stephen Rothwell <sfr@canb.auug.org.au>
Date: Tue, 1 Nov 2011 18:30:49 +1100
Subject: [PATCH] device-mapper: dm-bufio.c needs to include module.h

since it uses the module facilities.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 drivers/md/dm-bufio.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index cb24666..3a94ef4 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -14,6 +14,7 @@
 #include <linux/vmalloc.h>
 #include <linux/version.h>
 #include <linux/shrinker.h>
+#include <linux/module.h>
=20
 #define DM_MSG_PREFIX "bufio"
=20
--=20
1.7.7

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__1_Nov_2011_18_38_14_+1100_==3S8pWm4kYW6NiS
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOr6HmAAoJEECxmPOUX5FEeOMP/iHhYtxnS7qUfTgo/fhk18gP
ybticRwq8mF887+e8LU9r/vGNEGHOp3ZgZfnSwWPoIaioDkswi4Ub9q450hkumsz
a0sWU2qnxvybqxXFB2h99fNOV29I841cyq/cdPCaoUzEh8cDxBZ+9yMFMkXOntov
1qYYQWAgNSmcdGoAVMAvoWqe3Dt5J5/JY6vnazUYFGaOUSiTayKaEE+JQ9DnY/9/
K6nJw2Cp56W73FzO5TjRvHRrjIfKhpBVc7+7Pdanzxo20WpYy6DLj6c9Wy1dORdK
5SYfzRHIObIWtT05hbIGtMMjXP0nFtwknBI+TGsCo5NhHyKfFhdZyYm8NDQWUWHa
p2ltgv+438O27qJDWj37ix83S5WBslHDgOY9umiI9a5vNv3GHYDFwd9pjNb1ZSKF
mugom41xJybemaIsM/Vkva/S7up9wBNxk3MMkkf6cqDpfCQa7hMkRw6dNgiBKEB3
lfZOuCFtcEkcMZTXzQ6JJqZVThRxn/11tuF8ZZZdjY6zr0TWvvvY3NUVsnwZavi6
opLMMtbyloZQX3tZPigg2C1MukLXS2nB/QWUs1fCJaeBCFgPZ4JMHmwjKK/nwFMm
JzwUtO2IZ59P3E0M/AMsruMRH4z+O9E7YVV+dxTnV+0b90xfv8IT3WhlxnMamtjr
P7bUOLYw2ZXP0kVQHDLl
=HYGi
-----END PGP SIGNATURE-----

--Signature=_Tue__1_Nov_2011_18_38_14_+1100_==3S8pWm4kYW6NiS--
