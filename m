Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966421Ab2EPI61 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 04:58:27 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:33134 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966046Ab2EPI6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 04:58:24 -0400
Date: Wed, 16 May 2012 18:58:12 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Greg KH <greg@kroah.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Subject: linux-next: manual merge of the arm-soc tree with the staging tree
Message-Id: <20120516185812.ce1ab57c3ec72445135a35fc@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_18_58_12_+1000_VygyPGwvvPTGw9tu"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_18_58_12_+1000_VygyPGwvvPTGw9tu
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
arch/arm/boot/dts/at91sam9g20.dtsi between commit 7cb2e629a240 ("ARM:
AT91: Add ADC driver to the at91sam9g20 dtsi") from the staging tree and
commit 5b6089cb6f28 ("ARM: at91: add at91sam9260 DT support") from the
arm-soc tree.

So, I didn't know what to do with this, so I used the arm-soc version of
this file (effectively throwing away the staging tree change).  Hints,
anyone?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_May_2012_18_58_12_+1000_VygyPGwvvPTGw9tu
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs2wkAAoJEECxmPOUX5FExaUQAIUBAnzgDIv04GqUNFyQDgpa
vXmGp1PfgpEJuFnWlYqSRsidNEXuakkgg8EIHq9yLLL0EpEwylBxfSSueNd/aamf
eGBiQTZj0jX7tdv/cxwrIu33lVw8wtl45QaA2vD5uW06CE+5D4MGTx7boZegQK4f
AKx37f0hYWkbId3bRbJj/lXJGX/Apdqw8p9K61T+NvwvxiGxWpeHE3BkOBCjA1v9
gbM9U1N7CgRQSHUp+wovbUEPHElOp7itbLJQgU7bM+jhBmupk3IwmZbU0ocZU0Tj
NVzyCkXslovcU1+o6bnd17omYLtYAz6Sv8WVZvLI5prxgvC+3PHRImJOAYj+ry8s
KtcW9BBCkfBKwzN3USye/iEWg2V8y7mPLhnSYPKp8KQ8Eb43Zr6uWfvKJU74/awV
Ht/DyKASKS8Z+OsNu93a67vl5ZuiVhVZ7e7SlI/VsQ4zoJ7vl4Uzwacj8+N48hzG
Ar3ITqZIU6WGyktLB9W+Mm1tlOiq5tyKTbh87ZWLoBFU1uTcYpv/RfCo7i1IneTq
xxgVX/iyElyNH7WqKe/qZWsXq2anlHr5iLrERiaK0O5Im9fQeIgtq303W0H6IXfH
ksafbe7vv3EjYv5Ulg7MqdpSkDdHOkts8ZpuqgrAdKo/jvCL1REI+1GXrc2nPxM/
vGzgfYWp///Z2dea1AB6
=2IR/
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_18_58_12_+1000_VygyPGwvvPTGw9tu--
