Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753955Ab2DSCzQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 22:55:16 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:52885 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab2DSCzO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 22:55:14 -0400
Date: Thu, 19 Apr 2012 12:55:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Neil Brown <neilb@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the md tree
Message-Id: <20120419125502.bd9b7dcbe9497c8319035793@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_12_55_02_+1000_0wwqVnHmEFZIXi=j"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_12_55_02_+1000_0wwqVnHmEFZIXi=j
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Neil,

After merging the md tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".bitmap_resize" [drivers/md/raid456.ko] undefined!
ERROR: ".bitmap_resize" [drivers/md/raid10.ko] undefined!

Caused by commit 89efe2ab3a8c ("md/bitmap: add bitmap_resize function to
allow bitmap resizing") and followups.

I have used the md tree form next-20120418 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Apr_2012_12_55_02_+1000_0wwqVnHmEFZIXi=j
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj36GAAoJEECxmPOUX5FEgL4P/02w25JF4R8lA/tld7O7Y1Ot
q3xHuaSUMw2fY1Z42Ke25Fqxj6hwfDbsFIo3RLLDJrV0Yd5XodMxoGEGbqIbtrWX
v0UkcrYR1B5MGhP3CjzsD8E+Wt8n11Iejcb8eSQ2jchTgfzw5UPoq0LQ99K4QUXi
NVBBlXNGbeoBRzNXPtsbwJLwN7PlxZq0A9eU+49ExXrQSrC2wc1ZXTIV5D2J7Wa5
LciFmRKDZhOgs62wJBO6n7vg532ZbZO0iXkos5KkjDnh+9BJh8q6/lUROIZE92yQ
oSf9ZGIEpTDC6l8NiexzL3lb8tqmP33vsX4z+3hA65TRdxAz3+Bwa7BRPcd94nT1
WX8idg/Sp936I7GPMzzgzsdcDTeYOjAOyenU8Yk1bnC1mn9aMBzsaO7A4gThhjbt
XCWXwf8KE0pKW5bt+FEhrdanEfAbVyLvv+LAjyFFh/wSIucIvaxAJHaDGl823rv2
zp4C/BcbE+cUDdiW12kdw4dxrOToSTgM/EcyuJtAT85NHQQ7Fp65qXIWj6BR+EAU
d7l5WF+A5LP3AnfnsLetn0u6RrbWyLtxE+OIDKoE23I3sR8bRi8gtO2wDp2tVZSm
TLctuQz47VBglZwJHk3I/AUqdcXP2kmN+/rZSYSKmXSA30RKpDEFQIaRQP8O0AjZ
Vpj0K3TG+Km37yXsNFNw
=MSbR
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_12_55_02_+1000_0wwqVnHmEFZIXi=j--
