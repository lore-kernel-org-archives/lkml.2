Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751506Ab1JMARn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 20:17:43 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:46408 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab1JMARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 20:17:41 -0400
Date: Thu, 13 Oct 2011 11:17:21 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: linux-next: manual merge of the arm-soc tree with the arm tree
Message-Id: <20111013111721.9ae17934f07b50cf207f9c28@canb.auug.org.au>
In-Reply-To: <20111013111137.4abf421857ff0ec7ac1edb41@canb.auug.org.au>
References: <20111013111137.4abf421857ff0ec7ac1edb41@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Oct_2011_11_17_21_+1100_/cVYI9gV/JeuAKD0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Oct_2011_11_17_21_+1100_/cVYI9gV/JeuAKD0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Arnd,

On Thu, 13 Oct 2011 11:11:37 +1100 Stephen Rothwell <sfr@canb.auug.org.au> =
wrote:
>
> Today's linux-next merge of the arm-soc tree got a conflict in
> arch/arm/Kconfig between commit d0ee9f404f42 ("ARM: limit CONFIG_HAVE_IDE
> to platforms that do") from the arm tree and commit 06a4eada6a73 ("ARM:
> switch from NO_MACH_MEMORY_H to NEED_MACH_MEMORY_H") from the arm-soc
> tree.
>=20
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.

This also affected arch/arm/plat-omap/Kconfig

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/plat-omap/Kconfig
index 5b605a9,6d49d2f1d..0000000
--- a/arch/arm/plat-omap/Kconfig
+++ b/arch/arm/plat-omap/Kconfig
@@@ -14,7 -14,7 +14,8 @@@ config ARCH_OMAP
  	select CLKDEV_LOOKUP
  	select CLKSRC_MMIO
  	select GENERIC_IRQ_CHIP
 +	select HAVE_IDE
+ 	select HAVE_MACH_MEMORY_H
  	help
  	  "Systems based on omap7xx, omap15xx or omap16xx"
 =20

--Signature=_Thu__13_Oct_2011_11_17_21_+1100_/cVYI9gV/JeuAKD0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOli4RAAoJEECxmPOUX5FEYrUP/0xFQozukFBWCkiZl88nFF+m
GgF5J31QH0olMWQYMWJUqujSNyazb8CZ+tUL+6Mz9l5YtTgWr4GsCEtZaTgCLjcB
iPEsJdbyaAYTCca9pneBqaZqpmWgZPpjx8XUzrcOKYv1w5pPbk1DmqGyjNIVNRp3
NeRJNIgX/8HbCLlRveqQyyjY6cnLOPzASkDAcMILlrhzYH27VtKsEvtVWN/wxbSD
ICEq34VF/yYW5JCLz6sy0R3PLzMrNCBE3+6WgfFEU9XARHPqdrUosCFF6zrGkAdu
vSMA01togw1vU4zDHywmjEaTi3mdg+IkyPp6pab36nD5oivaTvIlTFR9M0ewPoCP
vDP7rod6GNElaI4P6I4/Qlljd6RGYWEob2k5i5yhbVBpF7jGjLfLsv0HBeeCyVUW
MrGyqACzCsR8K74PWHYFC2sY55Ipq5+3O6w+ZV3hqh0C+nUC9gNdv5JfH6+5byeC
08Yviqoa/4cFPG/ea+lXPAbVl0P4EW9NWYTCSIm/nIrSbyd8pnndNJWn7M4LyRiZ
mG2aLYdG4l15dbp5IG162pIG/ZnxLFrMw5sK61u2EvtyiCxXiPVdn7EREfsiL8dz
X6R1dagbxr9WI1cv51rZ6EHDuV/JtcPN9/PNTz7uEplgLSKpCqO+m7Je6xLzW1Gz
ilfs5/ucA2KRGf99S58f
=D67/
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Oct_2011_11_17_21_+1100_/cVYI9gV/JeuAKD0--
