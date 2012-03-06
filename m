Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753153Ab2CFGYy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:24:54 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:43816 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751251Ab2CFGYw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:24:52 -0500
Date: Tue, 6 Mar 2012 17:24:45 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Fabio Estevam <festevam@gmail.com>
Subject: linux-next: manual merge of the arm-soc tree with the sound-asoc
 tree
Message-Id: <20120306172445.81a8461cb8e3b764ce148932@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__6_Mar_2012_17_24_45_+1100_.L8H9bdVMECIsDak"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Mar_2012_17_24_45_+1100_.L8H9bdVMECIsDak
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/plat-mxc/audmux-v1.c between commit 2405fc9728a3 ("ARM: imx:
merge audmux-v1 and audmux-v2") from the sound-asoc tree and commit
48d795616c73 ("ARM: plat-mxc: audmux-v1: Remove unneeded ifdef's") from
the arm-soc tree.

The former removed this file, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__6_Mar_2012_17_24_45_+1100_.L8H9bdVMECIsDak
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPVa2tAAoJEECxmPOUX5FEVDgP/A1ZI+6VO5/LAPQGX2oYIOIC
XBuJnsCTSOgqhFLrjzMTmP3+++dTmWiVdym5LO7J7rEe1+sRX4eKB3qxZIqbqJRd
nKp5/hoXIpI7ZqwtYledwWBFUDzXxk53Ytuc5xoZ2/HPGM0kpY/TyIyXGxiZebSt
00wQlLk20xn1NX8L/WIDOonhw3rgPSOO2Iuw4r+WjPcEOWRTB6O10Tpw32ubesUP
JG8OUQQIhPU/wRbhkyrn3Gl51cHd2zcStEvmfaKVjKDORJdVL3S4Lrla0z6ZRSPw
grjzcbN0duAN3LrbVBZqwR2Ta6YDAGn3HJBzCN3pwq9mpvbNHGHgytG+X1whdcyi
hiANbz0SALyboXNtiIxxupGkSAVJrIayr4cMq1fkIYsRd+J9ZJsd4uGxc/LWuYKC
6l6TWR/qeXqmshoqUpTwAofGqlcAJJ/f9fJ09AFTtlQZQijsYEnt608y9Mv7Hoom
BdUg1pd0TQVXCzlbkghYe3vdFP2nNnal72DKxwXlMT+wkxhxYjtq0qSIY0De1wio
PZEkpPRvZ8K13YlitUjTN7KfJE+MZRV3ggia4l/TnZHs+2wHFFixM6ePfmZm1hCR
W2AyoybMUcUwqts/S/jyoJC1qxoiM6nPvic7W+kjh5lG9Hr5tvipZgKCltTnMRI2
ekj1bmUz2JVllHtbN1e4
=0tHB
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Mar_2012_17_24_45_+1100_.L8H9bdVMECIsDak--
