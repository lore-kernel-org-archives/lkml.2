Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0IYBhv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 21:37:51 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52112 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752802Ab0IYBht (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 21:37:49 -0400
Date: Sat, 25 Sep 2010 11:37:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <gregkh@suse.de>
Cc: Pavan Savoy <pavan_savoy@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: drivers:staging:ti-st: merge issues.
Message-Id: <20100925113743.f1e31a0a.sfr@canb.auug.org.au>
In-Reply-To: <20100924193027.GA17728@suse.de>
References: <AANLkTinbEH0Z61z69ThcM9-GoHW4s5nRZig8b6v8uC8r@mail.gmail.com>
	<20100924193027.GA17728@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sat__25_Sep_2010_11_37_43_+1000_mw23Iizs6DVciPTF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sat__25_Sep_2010_11_37_43_+1000_mw23Iizs6DVciPTF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

On Fri, 24 Sep 2010 12:30:27 -0700 Greg KH <gregkh@suse.de> wrote:
>
> On Fri, Sep 24, 2010 at 02:11:50PM -0500, Pavan Savoy wrote:
> >=20
> > The merges bbf96b3cb54a237f1a66883390637e30bb4407ba and the merge on
> > 759b9f0fe0c5be0d9fa1b92e14e093961312f6ac has caused the
> > drivers/staging/ti-st to get corrupted, I had submitted few patches
> > and it was all merged.
> >=20
> > basically the merge for bbf96b3cb54a237f1a66883390637e30bb4407ba for
> > drivers/staging/ti-st/ shouldn't have happened.
> > The head for the drivers/staging/ti-st/ should have been @
> > 83ef41f0858b48cce4f8ca23f674ec55d50bf47d
>=20
> I have no idea what this all means, sorry.

I was with you, here (until I looked hard :-().

> Are these linux-next merges?

bbf96b3cb54a237f1a66883390637e30bb4407ba is the merge of the staging-next
tree into linux-next. 759b9f0fe0c5be0d9fa1b92e14e093961312f6ac is the
patch "Staging: ti-st: remove st_get_plat_device" that is in
staging.current (and also in staging-next as commmit
dbd3a8709560365ff9b1e5eca263f608877a8a89).
83ef41f0858b48cce4f8ca23f674ec55d50bf47d is the commit "staging: ti-st:
mv headers to ti_wilink_st" that is in the staging-next tree.

> If I need to apply a patch to the staging-next, or Linus's tree, please
> let me know.
>=20
> confused,

I was as well.  All I could guess was that my merge resolution when merging
the staging-next tree was not correct?  The resolution I did was to remove
drivers/staging/ti-st/st.h and drivers/staging/ti-st/st_core.h (since
that had been done in commit 83ef41f0 ("staging: ti-st: mv headers to
ti_wilink_st") in staging-next) and ...

(I see it now) I used the wrong version of
drivers/staging/ti-st/st_kim.c ... Sorry about that.  I will correct that
merge in the next release of linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sat__25_Sep_2010_11_37_43_+1000_mw23Iizs6DVciPTF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMnVJnAAoJEDMEi1NhKgbseUMH/RKOU6cfIR9iPTCGIa0Ief+c
fBgNhveldAJddXkIM6QsJXaQXtQzHzlwAqhiJDK7Nn3h/dEc2xtD0Cz+j1rLX1pL
oqD43OV4RkeKtQMQPw91mACsvx+CgmtOKCUqnMKnegD73g6/10/2t0Zn1qWM3XN/
5kZiO9lpHoIQ9k434vpQ2D3Br+fNhdbsWMIEy/mVfof15hGR4ySSKSmKrv5CmTr2
oVfBdoQj5yhAvmp2qoR3soo6MV3NTiqt1+CEw2z29AU1wGPJiLzG7bi/boyJIp4S
zpkonLLckmY12luLpF15YutxTHtNEdRCRX0tT2rKPnZvMA85SZhsxhaSxVYv2yU=
=uIPw
-----END PGP SIGNATURE-----

--Signature=_Sat__25_Sep_2010_11_37_43_+1000_mw23Iizs6DVciPTF--
