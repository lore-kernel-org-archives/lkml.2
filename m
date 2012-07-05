Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754041Ab2GEHfr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 03:35:47 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44334 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab2GEHfq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 03:35:46 -0400
Date: Thu, 5 Jul 2012 17:35:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Will Deacon <will.deacon@arm.com>, Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the signal tree with the arm-current
 tree
Message-Id: <20120705173526.bf8772adb18edfc91adddea8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__5_Jul_2012_17_35_26_+1000_/=+Hn5Nt1x+sjv1d"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__5_Jul_2012_17_35_26_+1000_/=+Hn5Nt1x+sjv1d
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Al,

Today's linux-next merge of the signal tree got a conflict in
arch/arm/kernel/signal.c between commit f73e2ca64281 ("ARM: 7443/1:
Revert "new way of handling ERESTART_RESTARTBLOCK"") from the arm-current
tree and commits 9c802c169f96 ("arm: deal with handlerless restarts
without leaving the kernel") and 76c3f4da3ee4 ("arm: get rid of
TIF_SYSCALL_RESTARTSYS") from the signal tree.

I have no idea how to cope with this.  So I have effectively reverted
commit f73e2ca64281 ("ARM: 7443/1: Revert "new way of handling
ERESTART_RESTARTBLOCK"") for today (though parts of that commit are also
implemented by the above signal tree commits).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__5_Jul_2012_17_35_26_+1000_/=+Hn5Nt1x+sjv1d
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP9UO+AAoJEECxmPOUX5FEuKQP/RAjzQcnV49SDLCaXk3YPne7
lrdJGj1qg/VcjUyfSZCMZo7WUUkhkK/YCSWEUOJM0B8vyA8zFOwhxZYbQDvWgt59
T7Ulac4fftaI5RTqsDmN/A10M8lPUq/UxCxPuhiViIyxvzjgDS4X+f0/u0VMReAn
ETFn3N0E65X453dY4m21ywygF8ukW7TCTd5WNAzOWmD4Rj82Qmn88R1T4x2BmVab
tiYGnahJPa4XiXhOMqETTiJy0KZu7QIFtyJoTeTaWd/YNjzrZjRejpw2KwdIpuYG
QCaQd/yp+VCODvtj5Y9Os5kzXBqt5VtaR2lyBhVq/ikt4WPW5lib2J3J0Qdt7A64
PhK34AestcCVWTkn74+EcpBfwL8f8o8NubnG78ZT3NiMWP+1wbvBTTai+ybho/nV
sJ2FUpVwJruo1U6ORQIctMGIZZ8lCv0FICa6EiYEGKfAtl3L6BgWhDqvXqlifFm0
D7Z5CfLfV8i+cPDQKDj8GS2AGa4GdxNFgFumxXntSjs6opX/14QMBwTmY8dLpSeZ
t1HY1IXF9/U6b+tZ30kycaFVlYdwmaFalxJCbPGl2GbANMkVCq1pcJhRwB8ooA1W
IOGFXsaIZHmhO3QaNqB6A09RX5Zxq/JkxHFBgxXEhP/hVwv7suXt6ldWZcM18rJB
MF9w8+slq6wkpwqJccT3
=dxst
-----END PGP SIGNATURE-----

--Signature=_Thu__5_Jul_2012_17_35_26_+1000_/=+Hn5Nt1x+sjv1d--
