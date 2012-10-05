Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756224Ab2JEBr1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 21:47:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51121 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756122Ab2JEBrZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 21:47:25 -0400
Date: Fri, 5 Oct 2012 11:47:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jason Gerecke <killertofu@gmail.com>,
        Lan Tianyu <tianyu.lan@intel.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: linux-next: build failure after merge of the input tree
Message-Id: <20121005114712.02361628ba297ef695d54876@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__5_Oct_2012_11_47_12_+1000_+ESDHWxO/.EMJ6F."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__5_Oct_2012_11_47_12_+1000_+ESDHWxO/.EMJ6F.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dmitry,

After merging the input tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/input/tablet/wacom_sys.c: In function 'wacom_get_sibling':
drivers/input/tablet/wacom_sys.c:643:23: error: 'struct usb_device' has no =
member named 'children'

Caused by commit 316f18bba311 ("Input: wacom - handle split-sensor
devices with internal hubs") interacting with commit ff823c79a5c3 ("usb:
move children to struct usb_port") that is now in Linus' tree.

I have used the input tree from next-20121004 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__5_Oct_2012_11_47_12_+1000_+ESDHWxO/.EMJ6F.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQbjwgAAoJEECxmPOUX5FE2FsP/1rjXj/ovGwjfKjyDfnXudKR
/cMj8xhPh5KNSIOMEn7gRVMYA2qL6u9odiq9M13/Bx5Uhr4n89F10wA9SUJDihyc
Gx0EEma2Y35b96lrbU/1KE3YfZ846jCM/JV4El/5oRLUd8HoBYUBfbaI6O6ZQ+Cd
o8MGtf1ExunSCJLYlV7zYJPR70O1phSwHgTHGbai4/+0aYL/XUe9rkBP6c1srEa3
Jkq0kuYqhTKOI7Ay7yEcakU0TRLp3xvZ/PVzq1Ydc75+dN4k6lgLhXE/80f2NhxS
i4G7tgml8bb2iyNIWMSpyFWlq7qmzcXmjxpdSxrjopQAxIRcX49WjXIXbt9g95eg
8WeG5NHMh6SyultX/m8p0+GOn5Xuisf8x4L4eeMubk9Z1XH3WYSRoobEotEPwdUl
4iYT9KYe0gLsydhetzlKio3T610N2IHwXdw9Q19lxunxtZw7EKlhSXOejh43TsIn
JikNR79DrWuee/YE9yunNP9oASC1AFNXWh5sWgfPYyEOUNPQWqST4iDSKj1kFswX
gXKGF3arMBU/6qNs4zHVm+c6i07ZUFhbJoXKqNyUIjhBtocVFE5WZwsulnPKKtEn
mllv2jx6JzkLzkeib3LLk0yZiH5FoSA6r0PV6e0YcgEapIa4bEPey8TmaDOVKP6S
nVYTemcWZWr4KpvSL/7H
=oN0q
-----END PGP SIGNATURE-----

--Signature=_Fri__5_Oct_2012_11_47_12_+1000_+ESDHWxO/.EMJ6F.--
