Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754747Ab1HWBAt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 21:00:49 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45332 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754605Ab1HWBAr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 21:00:47 -0400
Date: Tue, 23 Aug 2011 11:00:28 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        Jonathan McDowell <noodles@earth.li>,
        Kristoffer Ericson <kristoffer.ericson@gmail.com>,
        Magnus Damm <damm@opensource.se>, Richard Purdie <rpurdie@rpsys.net>
Subject: Re: [PATCH] leds: add missing include of linux/module.h
Message-Id: <20110823110028.daf4b7bea8143cf8c042d6ef@canb.auug.org.au>
In-Reply-To: <20110822151200.1d6e03f7.akpm@linux-foundation.org>
References: <1313936407.13671.1.camel@phoenix>
	<20110822151200.1d6e03f7.akpm@linux-foundation.org>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__23_Aug_2011_11_00_28_+1000_P_5Vd3ifMaTpsGD/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__23_Aug_2011_11_00_28_+1000_P_5Vd3ifMaTpsGD/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Andrew,

On Mon, 22 Aug 2011 15:12:00 -0700 Andrew Morton <akpm@linux-foundation.org=
> wrote:
>
> On Sun, 21 Aug 2011 22:20:07 +0800
> Axel Lin <axel.lin@gmail.com> wrote:
>=20
> > Add missing include of linux/module.h for drivers that
> > use interfaces from linux/module.h.  This patch fixes build errors.
> >=20
> > ...
> >
> >  drivers/leds/leds-ams-delta.c   |    1 +
> >  drivers/leds/leds-hp6xx.c       |    1 +
> >  drivers/leds/leds-renesas-tpu.c |    1 +
>=20
> I'm seeing no leds-renesas-tpu.c in my tree, so whatever tree holds
> that file will remain unfixed.

The only place that files exists in linux-next is in the akpm tree in
leds-renesas-tpu-led-driver-v2.patch,

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__23_Aug_2011_11_00_28_+1000_P_5Vd3ifMaTpsGD/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUvusAAoJEDMEi1NhKgbsJhAH/1xnjwkYv6+trYpZ7+rCAVGN
DsVXGASI3nw+iZLsilweW3US2TYfvfk3BT17KulzKJMfQWfdgxbkk7tHqakKfq1C
aHQEftepd3d4frhQDqX/Ggh4ociXD5xe99TLNEj503YzC/TsSLgyVetmIst/Gbj5
jwy7nsJtLiGaSOFaITw2eRbxQQmzya3C9ZJDWXDKUOZaJae/Ovj68CmJ4ZGYYZwH
eeSbCk6TWxo1LBQ+j+412T47TXybbaGjcXFxvH5DGpAGt5j/VUBbnJmmCcYPm52y
DPuM06BK0Fuan3USTd3Y27Si24rc1kHM11v9yIR/2naz6vNvPleIwrskl3a1xMc=
=GSit
-----END PGP SIGNATURE-----

--Signature=_Tue__23_Aug_2011_11_00_28_+1000_P_5Vd3ifMaTpsGD/--
