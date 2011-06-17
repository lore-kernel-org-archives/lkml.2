Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755978Ab1FQDTs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jun 2011 23:19:48 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45343 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755064Ab1FQDTp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jun 2011 23:19:45 -0400
Date: Fri, 17 Jun 2011 13:19:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: davem@davemloft.net, netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        fujita.tomonori@lab.ntt.co.jp, linux-arch@vger.kernel.org
Subject: Re: [PATCH net-next] net: remove mm.h inclusion from netdevice.h
Message-Id: <20110617131937.63c71cb6.sfr@canb.auug.org.au>
In-Reply-To: <20110616210134.GA18026@p183.telecom.by>
References: <20110616210134.GA18026@p183.telecom.by>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__17_Jun_2011_13_19_37_+1000_1v=4LmR4gIeb+V=b"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__17_Jun_2011_13_19_37_+1000_1v=4LmR4gIeb+V=b
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexy,

On Fri, 17 Jun 2011 00:01:34 +0300 Alexey Dobriyan <adobriyan@gmail.com> wr=
ote:
>
> Remove linux/mm.h inclusion from netdevice.h -- it's unused (I've checked=
 manually).

Have you tried building this with STAGING enabled?  The fallout for
STAGING from the removal of linux/interrupt.h is still not sorted out.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__17_Jun_2011_13_19_37_+1000_1v=4LmR4gIeb+V=b
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN+sfJAAoJEDMEi1NhKgbs+AgH/jYsT2sY6W6QmlkD8CAleZP5
EM2YDrgZHNG8sePYbubGvJsIsnRihoWiL+eK97fud7ED2CBHysYu4Dn3du0amj6o
33MAT8WiKW211OvhAV1TthlPiRhwDRmi6eXMWh5fzYdhbIWE/8N0+VUYFyoqyEDc
1cvKjSckXY+iIYKnpTyBvpPf/f6YCuE/7RdYRGaNhCyC77VlJ1izgbE9TI+Eo91K
0uGxKOM+6WPrDlEmZpGxqPnPlRWFwuVRxCeksRJM2oYNjS+vkeZO5SywnDJi8e0l
acn5GfS97TQfbJ8H6XnVvG5LDt51+ilAYaK6bDOr1bHZrVZmVTbxatq3DMrTq0c=
=09qq
-----END PGP SIGNATURE-----

--Signature=_Fri__17_Jun_2011_13_19_37_+1000_1v=4LmR4gIeb+V=b--
