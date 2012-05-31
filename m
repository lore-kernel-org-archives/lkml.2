Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932322Ab2EaIfX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 04:35:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46450 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758111Ab2EaIfT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 04:35:19 -0400
Date: Thu, 31 May 2012 18:35:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Amit Shah <amit.shah@redhat.com>,
        kvm@vger.kernel.org
Subject: Re: [PATCH RFC] virtio-net: remove useless disable on freeze
Message-Id: <20120531183508.f426eb25fe1b94139c637348@canb.auug.org.au>
In-Reply-To: <87r4u2dllo.fsf@rustcorp.com.au>
References: <20120404091954.GA3776@redhat.com>
	<20120528125325.GA22576@redhat.com>
	<87r4u2dllo.fsf@rustcorp.com.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__31_May_2012_18_35_08_+1000_mGGj9zYT=zxyfc/k"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__31_May_2012_18_35_08_+1000_mGGj9zYT=zxyfc/k
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Wed, 30 May 2012 19:41:47 +0930 Rusty Russell <rusty@rustcorp.com.au> wr=
ote:
>
> On Mon, 28 May 2012 15:53:25 +0300, "Michael S. Tsirkin" <mst@redhat.com>=
 wrote:
> > On Wed, Apr 04, 2012 at 12:19:54PM +0300, Michael S. Tsirkin wrote:
> > > disable_cb is just an optimization: it
> > > can not guarantee that there are no callbacks.
> > >=20
> > > I didn't yet figure out whether a callback
> > > in freeze will trigger a bug, but disable_cb
> > > won't address it in any case. So let's remove
> > > the useless calls as a first step.
> > >=20
> > > Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> >=20
> > Looks like this isn't in the 3.5 pull request -
> > just lost in the shuffle?
> > disable_cb is advisory so can't be relied upon.
>=20
> I always (try to?) reply as I accept patches.
>=20
> This one did slip by, but it's harmless so no need to push AFAICT.
>=20
> Applied.

This patch exists in two trees in linux-next already ... Davem's net tree
(so presumably he will send it to Linus shortly) and Michael's vhost tree
(is that tree needed any more?).  Presumably it is now also in the rr
tree?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__31_May_2012_18_35_08_+1000_mGGj9zYT=zxyfc/k
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPxy08AAoJEECxmPOUX5FE5/sP/RWjfggpLyTmSrN4+KiLppww
0/frDP2sJjKeQSCpxYsuc5mi8SuhgXUVxIAK1mpBL/5+51Cki32kzb2sOutZrPMc
Z3jMYkOMyP1R0VLFScJtls9D0Wth3SrnG8EXDF6ozlKi4SZ6LQQfaoT15HWp21TD
ZWPLbiiPTQmTd0CVRseinmi9CLHM15fRBQ+ST/m5nZX+hTpPbCdyHwHVfGMl8rwI
4KOtPihw6VbKFcAIGtW/3VczZmeVIi1LMDHpnJ/n1+dbLFlg6BDCx999JsccH47/
Nbqnsn0OKWFXt2DPwratdJtuBIkGHGhPolZzHtpg0PYX7tALkPR0DxbPG/6WRSvj
ySkk19xRcIsXg7qHrjhYtLUsIaZOfbl9Ov9IzlN7u/qais1Cst4cHmoNkPkwZheE
7ifcpa78SLG4kTqSA2rsoxvUcUui8YM4Z8Ytozo7UcHFxrwsK4/Osz9OTinRkeB0
0+SpQLiGbjJcNQVOP8kQUAQasiEk15SqqfvXOogkfIurgleOS3zhRq12+Ko8wnuZ
7hkv3Up4GegsTH93lIl61cdAfhYzYueTEQvwBaMYRKFyIDsBR29/7tH1Gmu5rBj2
ErcrsEa//H7sN3mVVXqdC+Mxkuyc5ekXTUa86sDdFmgZBObyEY+7FJluDwDiIhZ8
iRwCHw6P+rw5Hc8DZtgE
=0znk
-----END PGP SIGNATURE-----

--Signature=_Thu__31_May_2012_18_35_08_+1000_mGGj9zYT=zxyfc/k--
