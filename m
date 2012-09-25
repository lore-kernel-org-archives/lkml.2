Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661Ab2IYDrq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 23:47:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40645 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752518Ab2IYDrp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 23:47:45 -0400
Date: Tue, 25 Sep 2012 13:47:35 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthias Kaehlcke <matthias@kaehlcke.net>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20120925134735.067e4f119bd71099df30724f@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_13_47_35_+1000_rR0FVyPzKtNn5Z_O"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_13_47_35_+1000_rR0FVyPzKtNn5Z_O
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

FATAL: modpost: GPL-incompatible module tps65217_bl.ko uses GPL-only symbol=
 'platform_driver_unregister'

Caused by commit dbc14ec43af2 ("backlight: Add TPS65217 WLED driver").

I have used the mfd tree from next-20120924 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__25_Sep_2012_13_47_35_+1000_rR0FVyPzKtNn5Z_O
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYSlXAAoJEECxmPOUX5FE8YAP+wQ5DXuDH9R6uNvsy4yVxnEY
bHMcDp+zV45rSJiG91UFn2HbHEQHqAU/ZSuGTNV+LMoaUPXOY7c8mE3eUYUNpuie
NdUL6MIXqC2VzY2+xquOGerZCW4wUGE/tNAtrKMwH1bZ9FjcMOsl8seMProDzREs
2flTxjLxf/3yGSwjXyOAy+GPG+cbqmD1JxW/7po3DhqW5bjGwDSwN8BWfzdBull2
TyjH/txWkSY3ehFOVESjNn+KSjv1gTAdMTZwZAXDxbibAjjQbdjftlP6+sagftct
i/Ni5tu2D27uFDGnn4fcieqOy0PQ2ivAb7JGIDheJc6yQZnQhcJmTcfKkLiM5UCW
CkP12DHVgogMp+JDmQ34+BF+SC5nfZdaumySDJ8DvDck35/jMdXnXTGz50u6Il3j
Po6dBEs9QlQpRdyRMQOeKV1nYL1Lpe84T7y0uA4QwJ7bfV0x6jntgYtcknsW1rfE
HuiXPogDvxV40jVGDojK6Iqa0SNdYA95NZ+ORd5q9O+UzLhf5uxsh3eX/yJwoNzr
KfXX3noJs+dNKNV63AkHcG9J67QoLC07KssxNMJXkL4V5AWL3Br1uE679jGk8YCS
AexMH8rv0C3gIKEaFMSRpqOBP60PWNfgeM/5LBGPABu074SVVSHmTjlCJPVU0pf7
Le7YugGibX7Q5ejFJbji
=Ld+F
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_13_47_35_+1000_rR0FVyPzKtNn5Z_O--
