Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756033Ab2FXOor (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Jun 2012 10:44:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39196 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752815Ab2FXOop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Jun 2012 10:44:45 -0400
Date: Mon, 25 Jun 2012 00:44:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        linux-next@vger.kernel.org, Joe Thornber <dm-devel@redhat.com>,
        Alasdair G Kergon <agk@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Subject: Re: mmotm 2012-06-21-16-20 uploaded (dm-thin)
Message-Id: <20120625004425.5efce7fbca77b7cfa086922a@canb.auug.org.au>
In-Reply-To: <4FE4AAAE.3090803@xenotime.net>
References: <20120621232149.F0286A026A@akpm.mtv.corp.google.com>
	<4FE4AAAE.3090803@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Jun_2012_00_44_25_+1000_pbz=KyXcAN2ZCXFd"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jun_2012_00_44_25_+1000_pbz=KyXcAN2ZCXFd
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Randy,

On Fri, 22 Jun 2012 10:26:06 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> on i386:
>=20
> Apparently from linux-next.patch:
>=20
> drivers/built-in.o: In function `thin_iterate_devices':
> dm-thin.c:(.text+0x206f07): undefined reference to `__udivdi3'
> drivers/built-in.o: In function `pool_preresume':
> dm-thin.c:(.text+0x207863): undefined reference to `__udivdi3'

I assume that CONFIG_LDBAF is not set and I think this is caused by
commit ebf5d9e0425c ("Non power of 2 blocksize support is needed to
properly align thinp IO") from the device-mapper tree.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__25_Jun_2012_00_44_25_+1000_pbz=KyXcAN2ZCXFd
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP5yfKAAoJEECxmPOUX5FE3I4P/ibmOEopwo/Rfu15KGPxhnhN
T38Umi3Fl19Ess4NlrBRUddVB20uKoBg4GZwnFKaKjzDqgHHIDOiCLcN8VbCYnZn
Gfav6e0EePIk0qQ8ygAClx3131vPCAcYRbYEj5V7pNc3lt8sLpWgXZ7d+XhXmdfs
T9zI3ngTyxXs0T1podXVCvlm5lUyJLn9prTS3R/doSYUV1hr2Ah5wxWBQGtb/t2M
F8EnwkTbr62behU5rhCOJDmyB3e/rTNRJ8X5DfPzb3uMwh9MwUY5Vowj636islEI
ZMoobBSCp4GoWzkSu8PwYkNNyO2qTmRyREmPD+B5pv8l7ZM295vXN2l17w+bao2R
FCHk59XBMMyaTmfd8IHAGQfyW8VLyNmtDCBVh83xyeam0f8By7VQ0ru3w0OeTSoU
D0VapFDlxe2RZSQpUSpp4RSI3ra7LoiPsFHj0ZoohXs6T5oIAqznSVVt2Pt7RS3w
+1hrlZ5m8DclyZ4JhXmlubZA4/sE9Z3zeksaUHs25qZetDg08a+XigGR6NRAVkz3
U1taqIsvZ//6gRPf8wWlLbXTD07BAAdjpEZbrDbEB1EkKXCyE/fSuI6L0V7Dzpj5
SNExZ/DA0/BpbWdrBAvBkmd37dkjEYWgYYRohphNTr1gxFZmZIbMKfBz3DkWelCn
Ys5Vmm/E4b+12wqIOCMq
=63rF
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jun_2012_00_44_25_+1000_pbz=KyXcAN2ZCXFd--
