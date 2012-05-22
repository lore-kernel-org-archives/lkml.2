Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab2EVEyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 00:54:35 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:37751 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752751Ab2EVEye (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 00:54:34 -0400
Date: Tue, 22 May 2012 14:54:32 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Masanari Iida <standby24x7@gmail.com>,
        John Crispin <blogic@openwrt.org>, Ralf Baechle <ralf@linux-mips.org>
Subject: linux-next: manual merge of the trivial tree with the  tree
Message-Id: <20120522145432.aa4d97df7f08af54229f1338@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__22_May_2012_14_54_32_+1000_sHWA3yZ0CEa4WPiA"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_May_2012_14_54_32_+1000_sHWA3yZ0CEa4WPiA
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/mips/lantiq/xway/gpio_ebu.c arch/mips/lantiq/xway/gpio_stp.c between
commit 5238f7bc3566 ("GPIO: MIPS: lantiq: move gpio-stp and gpio-ebu to
the subsystem folder") from the  tree and commit 6997991ab0db ("mips: Fix
printk typos in arc/mips") from the trivial tree.

The typos fixed in the latter probably need to be applied to the renamed
files drivers/gpio/gpio-mm-lantiq.c and drivers/gpio/gpio-stp-xway.c
(resp).

I have removed the old versions.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_May_2012_14_54_32_+1000_sHWA3yZ0CEa4WPiA
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPuxwIAAoJEECxmPOUX5FEsW8P/2WoT/HAOrjeX2n3NX9cHsyp
+nSlwsMh8jgxgKMXMoF4WM75Cb5APWuLg22oihUDpHBb/HNtwqkcqifV3k9z3CRy
iNlJKk0h9Ug2VbZwd8NwhcX6OIRKNX++zQ1zyrIcYkOYfYmolRa51t+mPWOZiobH
y0awv9MziYyBFlWQWRjaAmfpBZr/OxF+1Iclij1TdqEQx0P4hQO+VVuee7WlOpIT
pcYvEULKNzRHzct+cCnQo3yTPa8JRCDJymKpwoqRR9Nq5iari9HpWgTqRwXDMnX8
1UVLi99FBIVaIINU1xHoPWc7R8MptaVr/6eU7Ilmnk2S2idAYMCW/9qQ6gdxQgqj
mrAWjtI/6a42GiNmGugQZwlJyvvV/s6GY8+H+i+qXTcwhqc1UtLP05F0AhDtu3Xs
8InU9DtSRwHFYsHnMJvgOKDg37Iy7doCU2tnriE06/lk2Md9ZQ4JKM6wZ92P50Na
l6iJzbb0ueC3DXDMS9nBDgUqk0i0SVZxJV3fNn6OObjyXPL6qC5NRsXahslVp5WL
ISqXDQGmEgAwgGL0fTcD6PsgH9I4IhrIrhrogor4k2lJ2+4F1PdEIvBmIw9S1qzm
U+XWHBRnywFnFyoOWMct+PVRCI6cNuPleDrHEDdB3TZhscSV0eRZP4ie76tlVRGY
RdpKOlgw8g9X8LwiYLdf
=3NVE
-----END PGP SIGNATURE-----

--Signature=_Tue__22_May_2012_14_54_32_+1000_sHWA3yZ0CEa4WPiA--
