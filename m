Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab1FIA7m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 20:59:42 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58891 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751215Ab1FIA7l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 20:59:41 -0400
Date: Thu, 9 Jun 2011 10:59:30 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, kyungmin.park@samsung.com,
        stevie.trujillo@gmail.com, xiyou.wangcong@gmail.com
Subject: Re: [PATCH 1/2 v3] ramoops: use module parameters instead of
 platform data if not available
Message-Id: <20110609105930.8bef6aaa.sfr@canb.auug.org.au>
In-Reply-To: <4DEFD2F4.5000403@gmail.com>
References: <4DE0B9D8.3020405@gmail.com>
	<4DE10B4D.50501@gmail.com>
	<4DEE56AF.1040601@gmail.com>
	<4DEFD2F4.5000403@gmail.com>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__9_Jun_2011_10_59_30_+1000_AU971_05ARJbc2Xh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__9_Jun_2011_10_59_30_+1000_AU971_05ARJbc2Xh
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Marco,

On Wed, 08 Jun 2011 21:52:21 +0200 Marco Stornelli <marco.stornelli@gmail.c=
om> wrote:
>
> Il 07/06/2011 18:49, Marco Stornelli ha scritto:
> > From: Marco Stornelli<marco.stornelli@gmail.com>
> >
> > Use generic module parameters instead of platform data, if platform
> > data are not available. This limitation has been introduced with
> > commit c3b92ce9e75f6353104fc7f8e32fb9fdb2550ad0.
> >
> > Signed-off-by: Marco Stornelli<marco.stornelli@gmail.com>
> > CC: Kyungmin Park<kyungmin.park@samsung.com>
> > CC: Am=C3=A9rico Wang<xiyou.wangcong@gmail.com>
> > Reported-by: Stevie Trujillo<stevie.trujillo@gmail.com>
> > ---
>=20
> can you add this patch and "[PATCH 2/2 v3] ramoops: add a new line for=20
> each print" to the linux-next? Thanks.

I don't know what "this patch" is.  Also, I don't add patches to
linux-next normally, they should all come through some tree that has been
included in linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__9_Jun_2011_10_59_30_+1000_AU971_05ARJbc2Xh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN8BryAAoJEDMEi1NhKgbs3IIH/jQLy2Gocezsc7jyw5/DGFKz
ES8IMfS44HdOm9Gl+9xIw2woQyJ4SMIyP/XYuFVJ4y04Wzh9jQd4TAIYCD3eFos9
ZRlYBFGMmXZiWCWPdFEOnxFe6ExEqaSOP/Vfb99UAzCTdXnhCyB0Xa7QUYPpl8s4
CFaUqDzIevj6NHblfVG3WXTNShysf9EaiBSvGfyXG0HNigt0hYMbSSpY1F9Tm//m
b/14VfUl9HE/s8nC7IbRWMxzHpSyfHkuqlXKGzGilUQIPhNjbIZua2xYIm3xQhDo
48p6KwObEkjaRZAI4fxDCNl1ypd5aPAq72q77ek346QRzr+k+lpYxGzrd4sgBwU=
=H1V9
-----END PGP SIGNATURE-----

--Signature=_Thu__9_Jun_2011_10_59_30_+1000_AU971_05ARJbc2Xh--
