Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751830Ab2IYGhe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:37:34 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38492 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750854Ab2IYGhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:37:32 -0400
Date: Tue, 25 Sep 2012 16:37:24 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tony Prisk <linux@prisktech.co.nz>, Greg KH <greg@kroah.com>
Subject: linux-next: manual merge of the arm-soc tree with the  tree
Message-Id: <20120925163724.703a41b9438fbaef84b7480e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_16_37_24_+1000_DC1eBlFzb4_aH+lK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_16_37_24_+1000_DC1eBlFzb4_aH+lK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
Documentation/devicetree/bindings/usb/platform-uhci.txt between commit
100d45970327 ("ARM: vt8500: Add support for UHCI companion controller")
from the usb tree and commit 95e9fd10f06c ("arm: vt8500: doc: Add device
tree bindings for arch-vt8500 devices") from the arm-soc tree.

I used the version from the arm-soc tree and can carry the fix as
necessary (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_16_37_24_+1000_DC1eBlFzb4_aH+lK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYVEkAAoJEECxmPOUX5FEcz8P/0AK9b1KWvoYKYvD+H6MY5rm
nYv/W5ocXCAI5H7L0gOIjtUVMg8Ov7jy3JZk9shCCCAWkdufR45AL+5toWEPc8yu
C46CTH5TkQ3KaZQZdekYZ5qyLqdPpGJEWx3wDN7+VfMD6sAZIUuAx0TDfHqHqPFV
MI4NOoIPPxCylTeEBuCBOWNYGTczXXOyw2q5yI3+K9KQPWPYRtziH4IIRdgoGZFs
aczYUqBZd4ZlTejy5zCMH/IsrZ/7WxJ1MKKt8E66QFC3breb19/0qlGe9XKjamA7
GvUJ4irpzzhNqPcmN2xVYa80CXxXZanWKrOF+mxeBGiGcAC/+j8dhxrX84wKMm5W
ekH/KmWBkT/89c7J12BaVFWNUSFXrTQAWW3tOBzgdlozYgvOBdwiQLVuF1aXHgU+
AfiWYboSkxgZD+8n/4cF3a5Mq2DQdPJXo6q6KJaA5tTFW/V0zl0QleC1K5LsD7QA
kvH7Iko6PIsPpBv6UbDz0jXM+1N/O0AzX8Kbdk5nDRJi19jf47o+IU82iMCG7/fi
lAz4ExpK+ECkyFlUU2elXPtVusPF5eR21lvnEyRgQgyX8pw3nuQKf5vau8Ukq++y
4CZ0zB121HnhaHRw/rswYi9inWdQ8gejMacmzdj36FZUQ3uAm1/C5d/RDPV+YjAq
ywPRukQvM2hAO8rLC50A
=vysZ
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_16_37_24_+1000_DC1eBlFzb4_aH+lK--
