Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753378Ab2CIJf6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 04:35:58 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:49364 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751420Ab2CIJfz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 04:35:55 -0500
Subject: Re: linux-next: manual merge of the arm-soc tree with the
 omap_dss2 tree
From: Tomi Valkeinen <tomi.valkeinen@ti.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tony Lindgren <tony@atomide.com>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
In-Reply-To: <201203081616.12510.arnd@arndb.de>
References: <20120308170048.f1a992bca2ca2d93fa9747bf@canb.auug.org.au>
	 <201203081616.12510.arnd@arndb.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-KXNJ+UUi1kqhm09Jig4v"
Date: Fri, 09 Mar 2012 11:35:51 +0200
Message-ID: <1331285751.1927.20.camel@deskari>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-KXNJ+UUi1kqhm09Jig4v
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu, 2012-03-08 at 16:16 +0000, Arnd Bergmann wrote:
> On Thursday 08 March 2012, Stephen Rothwell wrote:
> > Hi all,
> >=20
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-omap1/board-palmtt.c between commit ddba6c7f7ec6 ("OMAP1:
> > pass LCD config with omapfb_set_lcd_config()") from the omap_dss2 tree
> > and commit 2e3ee9f45b3c ("ARM: OMAP1: Move most of plat/io.h into local
> > iomap.h") from the arm-soc tree.
> >=20
> > I fixed it up (see below) and can carry the fix as necessary.
>=20
> Hi Stephen,
>=20
> Thanks for fixing up all the conflicts between arm-soc and omap_dss2.
> I think we should make sure they are resolved in one of the trees before
> the merge window.

Do we need to? The conflicts seemed to be trivial ones, like arm-soc
adds/removes something that just happens to be next to something else
that I add/remove.

My understanding is that it's better to leave those conflicts than to do
"trickery" to avoid them.

> Tomi, what are your plans for the omap_dss2 branch to get merged?

Normally my tree goes via fbdev-tree (Florian's tree) to mainline.

> Do you think you should send it to Linus first and we merge it into
> arm-soc to resolve the conflicts?
> Or do you want to merge it through the arm-soc tree?
> Or should we go first and you fix up the conflicts by pulling in the
> necessary topic branches from arm-soc into your tree?

If we want to resolve the conflicts, perhaps it's simplest if the dss
tree is merged to arm-soc.

 Tomi


--=-KXNJ+UUi1kqhm09Jig4v
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABAgAGBQJPWc73AAoJEPo9qoy8lh71We4P/119Va7GDm09S1ocK861kNdn
OhpSdW4MxJzSIiJ5I0aufw0Kg5FqAsOt/iknxZoXzANrl5x+kO9r2n2WMDDb3qjt
GIbTac+2J9gShVuo/5dPsXY+vWR8PonBlJtiL4yun8l4dEfIvzoa3GyXGdFGWmwd
2EdWgU6HRNBjRsgLHna8j+z6ZYXJViC9BumPIbXOGXi1nvIh1AZEbN8PcuVjzxu1
osfKCXBaG88xnOx3VjXIabaNFOvz7UkBFhvKhnJp0jerD9vuKV5fHImDC5tvS6Vm
OXF13r/G8eDqck8quuNTqunk2DbJuy3uXskw+blaLwZ9uQTP0Lt3eCljt3Hp0jy2
w7XlnkAUpWFsSht7FCPHKfZnyQJ25a9HO/qXXMalWYS0J4f0idp0Xc40r2Vy+l6U
rkVWtW4Er4C18wvYYqJ8g9fz3uiU5+0eBPoucmFVMFKEG9tnBTCwQRJctCpc2pp7
cuve+id8Vorw2Bs1pyK6aIrlfRoqr5at5a3QycAZc2Wqn1898F1PG1kyfo0aR6Ei
W9G4SAD03ZF5smvjCTRBY7CMA4ycwSDjkS7SIFWalv0YYTTt9BXf6NLMFd0uP14m
KyyuPEoAJBDI4HyCP69l6QMieywECalD1IMi6FZGA816eAs+kRn0ZHZeRat1WOdi
cwCsyAxE3f+nWYP1SEzG
=Hyu4
-----END PGP SIGNATURE-----

--=-KXNJ+UUi1kqhm09Jig4v--

