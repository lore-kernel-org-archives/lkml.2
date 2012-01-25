Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab2AYAUf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 19:20:35 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:45095 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754969Ab2AYAUd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 19:20:33 -0500
Date: Wed, 25 Jan 2012 11:20:23 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Fabio Estevam <festevam@gmail.com>
Subject: linux-next: build warning after merge of the usb.current tree
Message-Id: <20120125112023.9cd8b4b1eedd717960e4c0a0@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__25_Jan_2012_11_20_23_+1100_1g13FRMaTJG4PqD+"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__25_Jan_2012_11_20_23_+1100_1g13FRMaTJG4PqD+
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the usb.current tree, today's linux-next build (x86_64_allmod=
config)
produced this warning:

drivers/usb/host/Kconfig:559:error: recursive dependency detected!
drivers/usb/host/Kconfig:559:	symbol USB_HWA_HCD depends on UWB
drivers/uwb/Kconfig:5:	symbol UWB is selected by USB_WUSB
drivers/usb/wusbcore/Kconfig:4:	symbol USB_WUSB is selected by USB_HWA_HCD

Introduced by commit 0dd2b62ada6f ("drivers: usb: Fix dependency for
USB_HWA_HCD").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__25_Jan_2012_11_20_23_+1100_1g13FRMaTJG4PqD+
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPH0rHAAoJEECxmPOUX5FEGyYP/jowAbVH4M4Zl9DF1JzotCcK
YuVG9JLuM/TM02lIsy4jH5H6OsXrS07ixqVyhK/YOluLnOwu00x4mB5AOqBSGbFw
9XeCyEgC+oBoTKKn+HTNgEX8ZDHNEPIAaFJ8DsL9yhxUhcZDUr1uXZhLB9Ml8Fgh
QSCXmMAd4ZOL42BhSPKPcv0k/ThAoiJaYuP+caCAR65rzZsoDf++GJwTiXl53NNq
gyEj6uAWwJKskzbEsyiXCQJlACzRj49xg6giWRNOmXbTFpNrgCXkBosOkD1WfCRC
vxP5btVm8rW8K/y25SKGPGgSzh8dUExmIE7quCmKnsJ96ygioTMkpnC8HMy3M2OV
ZeQxJvl4QNsjY2OBx01zcj31pnu1o0m4cO9rcIgz8Gj0grv5FOkHeU0spy5oF48Q
5QaUzLfyTBSiK9SvUo7vn+urpxYPhCvAhUnJM4+a6B8cNHRH1E63i0AbHx+b9uKI
3Ybf/gO3FlDZMq4aE4iEqq5g1T/yz4ASaSeV1J85YsOrk0TaU1VwjGkndTSnRxyO
AumxbxVCdYa/YjGaH24VR7TAriH1vMF1jBAvO+HIUUoPJkt6eiPIz4365xFCIWan
R1v3A4GXX1NSX4No8hLpz6MIoQGYfc0OT7irGLY11ZS46l6dBGyLVSxPh+sKixSC
nw9PGpm2rTDSEezL5wQb
=AiFH
-----END PGP SIGNATURE-----

--Signature=_Wed__25_Jan_2012_11_20_23_+1100_1g13FRMaTJG4PqD+--
