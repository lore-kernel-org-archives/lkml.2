Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030787Ab2B2HLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 02:11:15 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:53133 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030462Ab2B2HLN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 02:11:13 -0500
Date: Wed, 29 Feb 2012 18:11:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Haojian Zhuang <hzhuang1@marvell.com>
Cc: Yong Zhang <yong.zhang0@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: linux-next: manual merge of the akpm tree with the arm-soc tree
Message-Id: <20120229181103.e05c55bafd959f739d6a336b@canb.auug.org.au>
In-Reply-To: <25B60CDC2F704E4E9D88FFD52780CB4C060A87D777@SC-VEXCH1.marvell.com>
References: <20120229172127.7b430cecc7ab2350d4e4a1b8@canb.auug.org.au>
	<20120229063217.GA13386@zhy>
	<25B60CDC2F704E4E9D88FFD52780CB4C060A87D777@SC-VEXCH1.marvell.com>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__29_Feb_2012_18_11_03_+1100_uawUsS+VYPcxO7v."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__29_Feb_2012_18_11_03_+1100_uawUsS+VYPcxO7v.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 28 Feb 2012 22:54:06 -0800 Haojian Zhuang <hzhuang1@marvell.com> wr=
ote:
>
> Since there's the conflict on code. Does it mean that I need to re-submit
> those patches in arm-soc that should be based on commit "drivers/rtc:
> remove IRQF_DISABLED" from the akpm tree?

No, that conflict can be resolved by Linus during the next merge window
(unless someone else wants to do something about it).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__29_Feb_2012_18_11_03_+1100_uawUsS+VYPcxO7v.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPTc+HAAoJEECxmPOUX5FE+ssP/3EN5OjJzfNGj4QuUXd26Kuk
ESTvGORCj8Rabt3xPFfpFCiCh49XhgHCBFkI+j3QWn4/n9pLw+y5DchuhgbRfXGO
7KH9IZ167ixTB1HiMbrQj0CbxM2atWKe7tK6CG/Pv7+OLBnIQmZH/J/OM7xts6aP
9A3vInoSA/hoqiwfpNrjlEOW5EVhf63AWg9BVqRr82fkP/7XiZdc5betDkrErEmg
HPG2raIjqh8eI21Y1K73JJ0Ty0oajYwUAeQljocSBem/3ctb7BEaw/BfE0OkEKJh
0r+osif061SQ/uwbZXab53ZOiyDTQx7Di3ELPfrSgmIQisxr8+8CxN0IWvaBVK7F
YcoFxRnYj1Wrktq9g9lYLq/Jzc6duNZ7QHSX9Tg+hS4y5Uh8Sx4wbC5mLNY0YHvT
fuojoQ3ODr/DLxU0typYZ/z6ebBsvr48RkxuhLiFMDMIHzxtDb1c7TykEUd+7+Rq
0ETCP9FzFeG9cAOEQBB/znKZmIl0fbAxZA/zdgGDI65mFosuVCxYZJlyabv04mYD
Sv5HE52Jk4RSfc628bUVEP0Ws5W1TmCUTw4d97mF8zLr2KqdNUjCKZnESnrZ5gyC
aOMvJ8m3jZnlQT7ZenKiXWHYrvJm6KPrAgy3g38lVtkg9YbrYSWzsJlhxBfED0rS
EFeJWRIKDaY7HIoDj+cC
=O+fv
-----END PGP SIGNATURE-----

--Signature=_Wed__29_Feb_2012_18_11_03_+1100_uawUsS+VYPcxO7v.--
