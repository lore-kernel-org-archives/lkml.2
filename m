Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab1LMHiB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 02:38:01 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:53573 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751036Ab1LMHh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 02:37:59 -0500
Date: Tue, 13 Dec 2011 18:37:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, linux-next@vger.kernel.org
Subject: Re: [PATCH] rpmsg: rename virtqueue_add_buf_gfp to
 virtqueue_add_buf
Message-Id: <20111213183751.502abede7b5c3382d153ce51@canb.auug.org.au>
In-Reply-To: <CAK=WgbY2Kw0G7OkkN6f7=rExFpBzHVy_7r1xCrHe02nSuOUC3Q@mail.gmail.com>
References: <1323760467.11759.2.camel@phoenix>
	<CAK=WgbY2Kw0G7OkkN6f7=rExFpBzHVy_7r1xCrHe02nSuOUC3Q@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__13_Dec_2011_18_37_51_+1100_ydEDxFWdrOIXBlTW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__13_Dec_2011_18_37_51_+1100_ydEDxFWdrOIXBlTW
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 13 Dec 2011 09:20:57 +0200 Ohad Ben-Cohen <ohad@wizery.com> wrote:
>
> On Tue, Dec 13, 2011 at 9:14 AM, Axel Lin <axel.lin@gmail.com> wrote:
> > Since commit 7bb7aef2 "virtio: rename virtqueue_add_buf_gfp to virtqueu=
e_add_buf",
> > virtqueue_add_buf_gfp is renamed to virtqueue_add_buf now.
> >
> > This patch fixes below build error:
> > =C2=A0CC [M] =C2=A0drivers/rpmsg/virtio_rpmsg_bus.o
> > drivers/rpmsg/virtio_rpmsg_bus.c: In function 'rpmsg_send_offchannel_ra=
w':
> > drivers/rpmsg/virtio_rpmsg_bus.c:723: error: implicit declaration of fu=
nction 'virtqueue_add_buf_gfp'
> > make[2]: *** [drivers/rpmsg/virtio_rpmsg_bus.o] Error 1
> > make[1]: *** [drivers/rpmsg] Error 2
> > make: *** [drivers] Error 2
> >
> > Signed-off-by: Axel Lin <axel.lin@gmail.com>
> > ---
> > I got the build error on linux-next 20111212.
> > So this patch is against linux-next.
>=20
> Thanks a lot for the heads up, Axel !
>=20
> Stephen, can you please carry this patch in linux-next ?

I seem to have mislaid my copy :-(

If Axel could send to to me again, I will put it in as a merge fix tomorrow.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__13_Dec_2011_18_37_51_+1100_ydEDxFWdrOIXBlTW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO5wDPAAoJEECxmPOUX5FEVXMP/2hbLK2ek6Dh24vKAjIt6pVN
0POaaadmvlCksuXgSssaAr0do6iWybX1t77xEWXATp3n2hR5etVPVioeWR1DYSq+
BU4FNZAcXIzmKSMvP4HcnD2uInejuAvFa31mPkvbNe8MeXM63qhqqqxi7vUBVvAD
deLxBHJVLZpXiN+gZieq/Vk4C0qTCWnns0uGt2xyi1ONXF6eLAEeiUI83xrh6Wz4
UQc3G0kXKWiAjWuticmfjAu2ZgqUaYFnz+TpPpOhl91Ha8i/0U10u496phTVZzOV
+ao8XNa/0zjxhYvuvFKYmqM22zeJLcP0zyk/uzRS5xbAJUt1ptnyD9TCJekvNfAm
EqhZJePoAmdRvBKbNPUivd/snI2POkbxDFft7EJZeGZdCs075VVwwR3ms528EbKO
P/1tP52pmzC2ZYXPYR/AOyz0zvYVoLMIEjuJzR1hzX3JN5L6sVGhkESQBsci9rF2
TcBgzKEtA9oN22n2BO9QPvQ9uAiTdEO1+Ro/e6HzMSv4hQX6JA15/3OLABi+VTy+
VaYavpU3W8dZHPbpX5oZtgxCIF1i/br5XnEDuFC0oS2RifXV3EkQdJDxb/vl2yli
BLiX8pwMB5L+8fKxHtObLW30iT2jfFpk2hvzdQAGodwPKXdmug3qJnArKyUSmxFr
t08binZkHFInkZ5sosHG
=gNkf
-----END PGP SIGNATURE-----

--Signature=_Tue__13_Dec_2011_18_37_51_+1100_ydEDxFWdrOIXBlTW--
