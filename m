Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754540Ab2IDGGj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 02:06:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33225 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751273Ab2IDGGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 02:06:38 -0400
Date: Tue, 4 Sep 2012 16:06:26 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rob Herring <rob.herring@calxeda.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the arm-soc tree with the arm-current
 tree
Message-Id: <20120904160626.f1dcb67ebbb145053c49da8c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__4_Sep_2012_16_06_26_+1000_JnZHPVQh6ww/I3li"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__4_Sep_2012_16_06_26_+1000_JnZHPVQh6ww/I3li
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/mm/mmu.c between commit a849088aa155 ("ARM: Fix ioremap() of
address zero") from the arm-current tree and commit c2794437091a ("ARM:
Add fixed PCI i/o mapping") from the arm-soc tree.

I am not sure how to fix this, so I have used the arm-current version of
the change to pmd_empty_section_gap() since that changed the vm->flags.
It may be that just changing the vm->flags value in vm_reserve_area_early()
would be ok?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__4_Sep_2012_16_06_26_+1000_JnZHPVQh6ww/I3li
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQRZpiAAoJEECxmPOUX5FEY3kQAKIsjCNKpWSNf8ci8RFqL8HK
UgwQ03hfWhQJBE4u6WuUL7pSAIj8tTYMscYEbdU/w3qC50vdh0PH3bWBk2RREjsx
h03Sg2KQHvQBgK028iriJiy0FVZ+wP4x82Li2ViWJ/WW0PYQoC+OMrQDdX0+9Gbs
beWcfwvQBt3X5GXIvZ1mpAFoQE4e7wKH/GyYO8t0v9Z353qHhtoPREwVFjswnGdc
4Hhd8ijEChU+WiXv+RUpT5r42CdOFnNMOdUdF9EWkHxjle+mI0U2v7I5MQEPgXr6
t48nHtDCwq/oNHdbZBV+XLEpOzK9nuZZv4X5RKvar7W2YDxEsTCul8MI7LvlCJ5T
wTlXRqsdC2NQZmJ6sdCZzCxV82sAzip79/HSgZSJj1XR/HRX4zm4gm73tpc4QtHQ
/sYS0sBfoNiSvOcKYTm8M9W93RFljnSdHXxxzb4dzwqNTLj7Vsz069IqEor9tyXe
DnvARZ4IXXbCQLWIpWKe8hBkp51SuBUcclwnKDIWQNf2K0AhQqn43oHHtBIfIocF
FxihKBfLgrqcz5oAlUYGMAXJTJu/7F/q1dEhQoPssLQWboDb1ljWMM1WjB2Tr95m
ZU8MEClb0Ksd64Bo5McZiJaWLL5kqIJ14WuH2d2ImxLNRtzTSSzkFmEf3Q6VguZo
cv1i8XtwzTI24o47ZAsR
=1Izh
-----END PGP SIGNATURE-----

--Signature=_Tue__4_Sep_2012_16_06_26_+1000_JnZHPVQh6ww/I3li--
