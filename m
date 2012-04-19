Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753272Ab2DSDPd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:15:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53605 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751388Ab2DSDPc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:15:32 -0400
Date: Thu, 19 Apr 2012 13:15:24 +1000
From: NeilBrown <neilb@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the md tree
Message-ID: <20120419131524.019346fd@notabene.brown>
In-Reply-To: <20120419125502.bd9b7dcbe9497c8319035793@canb.auug.org.au>
References: <20120419125502.bd9b7dcbe9497c8319035793@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/sMwB8IHQ95T=L_m=NAoZoKt"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/sMwB8IHQ95T=L_m=NAoZoKt
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Apr 2012 12:55:02 +1000 Stephen Rothwell <sfr@canb.auug.org.au>
wrote:

> Hi Neil,
>=20
> After merging the md tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
>=20
> ERROR: ".bitmap_resize" [drivers/md/raid456.ko] undefined!
> ERROR: ".bitmap_resize" [drivers/md/raid10.ko] undefined!
>=20
> Caused by commit 89efe2ab3a8c ("md/bitmap: add bitmap_resize function to
> allow bitmap resizing") and followups.
>=20
> I have used the md tree form next-20120418 for today.

Thanks a lot Stephen.

I've add the missing EXPORT_SYMBOL_GPL(), so should be fine for next time
round.

NeilBrown

--Sig_/sMwB8IHQ95T=L_m=NAoZoKt
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT4+DTDnsnt1WYoG5AQJeoA//SmVxOPIlsQafmRM7XVSyrXBziyHlZL/v
fFJAU7voBfD/XfISxaUdNhqRYcYvxVkWgWxPxkO5pHNUAouGnHyhj9XuqvkE59rP
H//lmydalw/WKFIDWghuqiIUM2lb46ZBM6ADwyScfjegLcmvsEGF9kF18qhm7UQL
dZsFTf5lKvSB9KxZT1v93/MUq8HTtYA0SvKFd61bexluooZCCS3ijdEA9sJAOeNZ
BpWTcP0jWi5/KUyOUoR0gmRUuIbaZuIJxp4um/vvz5dXJOAw7teZ3jQDY8/A9L4v
cbumxcPStKLeeYuqtMjZWci8pJlrfCOuDmUo89JPf138SObu34uKx0U0ciPFO56c
hFdC5WpeGYiTrMvTCGGpzpWV1hMAj5JJDIBC/ulN5PcZZKcHI1E8LhwMsa9M+mE2
L+X2V0WNdpflqi/Ya6LaJBCBq/ArWfTWXsVKfx22vA8ZfKDh1u9QDB7PdmjDqRcZ
nu4+zKKk8eCwHXoHX+/4N++Vq1gONmaQyHRCIAMWpaHjZJfFcS5xi9uZ+m1RjvOB
DAICblzFeL9OQMPOS53rbvw7GZKTArFxNu35SKSfwYLktT2trpwS4HIb/1/gcgAP
u70nvZs7dlvPnQHUhd8jVbXOHcHyWefhb9VdVWZgjrHKbVVUJuNiB/Lyp6k8Ks2O
Gp2OzqbHg0I=
=kH0w
-----END PGP SIGNATURE-----

--Sig_/sMwB8IHQ95T=L_m=NAoZoKt--
