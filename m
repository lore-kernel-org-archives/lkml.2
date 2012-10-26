Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755997Ab2JZD1M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 23:27:12 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59551 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755817Ab2JZD1K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 23:27:10 -0400
Date: Fri, 26 Oct 2012 14:27:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: manual merge of the arm-soc tree with the pinctrl tree
Message-Id: <20121026142708.394d5ef1e6e3b9ad19243cc6@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__26_Oct_2012_14_27_08_+1100_tkVrAEZ6n_dkreV2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__26_Oct_2012_14_27_08_+1100_tkVrAEZ6n_dkreV2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mach-ux500/cpu-db8500.c between commit 63c53906312f
("pinctrl/nomadik: move the platform data header") from the pinctrl tree
and commit 4040d10a3d44 ("ARM: ux500: add DB serial number to entropy
pool") from the arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-ux500/cpu-db8500.c
index 87a8f9f,50202a1..0000000
--- a/arch/arm/mach-ux500/cpu-db8500.c
+++ b/arch/arm/mach-ux500/cpu-db8500.c
@@@ -18,7 -18,7 +18,8 @@@
  #include <linux/io.h>
  #include <linux/mfd/abx500/ab8500.h>
  #include <linux/platform_data/usb-musb-ux500.h>
 +#include <linux/platform_data/pinctrl-nomadik.h>
+ #include <linux/random.h>
 =20
  #include <asm/pmu.h>
  #include <asm/mach/map.h>

--Signature=_Fri__26_Oct_2012_14_27_08_+1100_tkVrAEZ6n_dkreV2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQigMMAAoJEECxmPOUX5FEe50QAIJtMZQiI4/3R4tAtC49tgjX
CdzySCZg0gNcA7IZRDy/IuzlEOdYby7xedHq0EKc3+uPyTQZT0PqIHv3829024ac
3srlgeNo2RR57ANKzCgIWA0pemVf9FC+fl0pKR+9WCIm+GSidcBxOABI7EfygSq6
cgK/gWtyCO8y2qPCj8hxwopFWVu5JEOx1NGgfjaeT174GMUFlUKfXLnWlSSqLoUB
BtkiDbpVZEVcyeVFmWBA3P4j8C0iGwJljjLD6hNr5+rD4id2kEon33hGWANd6RQc
LoXKaxIt71bSzCYOAMi0xjXGEJd3O/FDRZxowF02GPtuSp8HAo7optK5N7s01r+n
B+E5P6dLoOLIjN4NUxQbj1W40HDlhownhAS09f6HEGT10zQJHvSGVhCptwMwgVWi
Zhp3mAN9c2eEdNpqO2MrbvN+OlMe/Fr0QFfKn4f26FO8gXR2CezjKzh6Xo8VHb6U
4gIEzsVdw6NSJQhUgVPlw5uGj3onyWT1ULEm0nO95Nc36TFMO+fjVVJwI9QhxZM3
6+op5dDU3D0zNhlEciUTLtTkNH6Ieibk/L6cyJ6sy3VmLm6zEPssXkFqtOUh4Ve7
hOt4avJPaJCsYp/MA2U0gUDAJyItALloR7dBJdCygtb5fCcOSoIc1EgLIy0Ugp9E
qXWq0aEfSeCSbl0NvlRQ
=ABmp
-----END PGP SIGNATURE-----

--Signature=_Fri__26_Oct_2012_14_27_08_+1100_tkVrAEZ6n_dkreV2--
