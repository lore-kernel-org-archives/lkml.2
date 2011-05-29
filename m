Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860Ab1E2RSN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 13:18:13 -0400
Received: from lennier.cc.vt.edu ([198.82.162.213]:41735 "EHLO
	lennier.cc.vt.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841Ab1E2RSM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 13:18:12 -0400
X-Mailer: exmh version 2.7.2 01/07/2005 with nmh-1.3-dev
To: Toralf =?utf-8?q?F=C3=B6rster?= <toralf.foerster@gmx.de>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>
Cc: user-mode-linux-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: 2 small kernel config issues related to UML + RTC
In-Reply-To: Your message of "Sun, 29 May 2011 11:22:01 +0200."
             <201105291122.01602.toralf.foerster@gmx.de>
From: Valdis.Kletnieks@vt.edu
References: <201105291122.01602.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1306689477_27223P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Sun, 29 May 2011 13:17:57 -0400
Message-ID: <103895.1306689477@turing-police.cc.vt.edu>
X-Mirapoint-Received-SPF: 198.82.161.152 auth3.smtp.vt.edu Valdis.Kletnieks@vt.edu 2 pass
X-Mirapoint-IP-Reputation: reputation=neutral-1,
	source=Fixed,
	refid=n/a,
	actions=MAILHURDLE SPF TAG
X-Junkmail-Status: score=10/50, host=dagger.cc.vt.edu
X-Junkmail-Signature-Raw: score=unknown,
	refid=str=0001.0A020209.4DE27FC9.006A,ss=1,fgs=0,
	ip=0.0.0.0,
	so=2010-07-22 22:03:31,
	dmn=2009-09-10 00:05:08,
	mode=single engine
X-Junkmail-IWF: false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--==_Exmh_1306689477_27223P
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable

On Sun, 29 May 2011 11:22:01 +0200, Toralf F=F6rster said:
>   │ Symbol: STMMAC_RTC_TIMER =5B=3Dn=5D                       =20
>   │ Type  : boolean
>   │ Prompt: Real time clock
>   │   Defined at drivers/net/stmmac/Kconfig:50
>   │   Depends on: <choice> && RTC_CLASS
>   │   Location:
>   │     -> Network device support (NETDEVICES =5B=3Dy=5D)
>   │       -> Ethernet (1000 Mbit) (NETDEV_1000 =5B=3Dn=5D)
>   │         -> STMicroelectronics 10/100/1000 Ethernet driver (STMMAC_E=
TH =5B=3Dn=5D)
>   │           -> STMMAC Timer optimisation (STMMAC_TIMER =5B=3Dn=5D)
>   │             -> Select Timer device (<choice> =5B=3Dn=5D)

Ouch. That has to be the strangest place one could *possibly* put an RTC =
driver. ;)

Giuseppe - is that RTC driver *really* an integral part of the chipset an=
d
won't work without the Ethernet parts, or should the driver code for the =
RTC
live elsewhere in the tree?


--==_Exmh_1306689477_27223P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Exmh version 2.5 07/13/2001

iD4DBQFN4n/FcC3lWbTT17ARAulNAJ9BhXhUUV0WBKViuZNErEpOMYQJpACUCkx1
JzlXXFc+TtSPi10Dl9TpLQ==
=Cqc3
-----END PGP SIGNATURE-----

--==_Exmh_1306689477_27223P--

