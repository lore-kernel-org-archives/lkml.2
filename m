Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753716Ab1KGKTt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 05:19:49 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:43422 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753240Ab1KGKTr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 05:19:47 -0500
Date: Mon, 7 Nov 2011 21:19:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Len Brown <lenb@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: failing to fetch the acpi tree
Message-Id: <20111107211938.5a1ddb93f1f15fdf34e50042@canb.auug.org.au>
In-Reply-To: <CAJvTdK=tcFaqmDdtW6zCaddBixVE9Ee2SGAv39fjJtbTp-iDZw@mail.gmail.com>
References: <20111107095429.28cb33a8ec512a2bd7690dba@canb.auug.org.au>
	<CAJvTdK=tcFaqmDdtW6zCaddBixVE9Ee2SGAv39fjJtbTp-iDZw@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__7_Nov_2011_21_19_38_+1100_5COBqC=zmjHDeENz"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__7_Nov_2011_21_19_38_+1100_5COBqC=zmjHDeENz
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Len,

On Sun, 6 Nov 2011 18:26:26 -0500 Len Brown <lenb@kernel.org> wrote:
>
> Please delete my github tree from your linux-next script
> and start using this one:
>=20
> git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux.git next

Done.

> This "next" branch will be the consolidation of what used to be
> acpi-test
> idle-test
> tools

OK, I removed the idle-test and powertools trees.

> and whatever other power management trees I used to have for linux-next.

The only other tree I have associated with you is the sfi tree whose
contact is listed as <sfi-devel@simplefirmware.org> which I am fetching
from (the nonexistent)
git://git.kernel.org/pub/scm/linux/kernel/git/lenb/linux-sfi-2.6.git.
Should I drop that as well?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__7_Nov_2011_21_19_38_+1100_5COBqC=zmjHDeENz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOt7C6AAoJEECxmPOUX5FEEwMP/22sczfQU7JaOUViVi2wEVNc
NeAZVjiXuI3/G037rx0m3kFW8WlcIinwiCHPFgpA0fWfBd+JbtMnq2vqw1hgaoJV
zb4nV7iF2yuZEeosQv4T9lMOsxy/AwpVIagAy2fojICkCiEKbOwMlbJWTHQuVYxh
J6+NeT8W/Wkk1ZVsgJMuASo/HJGtadAUEMkEfLNMgEStph9KcYXPTyUnf8MSRXXL
7OddE0jV3U0EOznNpD4ulYtm/Koa8G26ZQxeMcf2+y0+yWkuyUrAFw1QQWS0i3uD
azXOPjUs4H2bYpeMtE1+qQ9pOW2Xvi/lrsjIFobsbzwk56zvtxhg1Vt87q2QBfSn
7PaKl8s84A/TFGsPx2ezXDP1iRio0graONE6CnL2xvAhX0CK4hg3Vj8elMSW5jzR
d6zRaKf6OZvrYJYEt+KPryEHilsW1sDK/h2x+Okox7+4wR5r0rfjJgte1Trb1pYA
BwxiTH+oPswEYcDX+xyK97aQTb+OK8rFS2XVHxgLNtR47bH6SdMDDsVElcxGoZJY
O7YA0ba2mFRlRFshq1vWMu2PXnhkOWbSNnPV2Cz9VN5x7e2tqeUYxwJCzXMQzhuq
a194bGRroNEIsKZ7rv8DQmhyIHh1xwQaWDQ5stZ/xPwmGj+cEYSiuB3z9kXjdTcH
K4pMcB/04TOmJc8tVJke
=NWiJ
-----END PGP SIGNATURE-----

--Signature=_Mon__7_Nov_2011_21_19_38_+1100_5COBqC=zmjHDeENz--
