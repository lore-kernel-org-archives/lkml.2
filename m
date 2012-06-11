Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755193Ab2FKQgu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 12:36:50 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:38474 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754108Ab2FKQgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 12:36:48 -0400
Date: Mon, 11 Jun 2012 18:36:44 +0200
From: Wolfram Sang <w.sang@pengutronix.de>
To: Shubhrajyoti Datta <omaplinuxkernel@gmail.com>
Cc: "Zhang, Sonic" <Sonic.Zhang@analog.com>, Ben Dooks <ben-linux@fluff.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "uclinux-dist-devel@blackfin.uclinux.org" 
	<uclinux-dist-devel@blackfin.uclinux.org>
Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register access
 Macro to head file.
Message-ID: <20120611163644.GH3887@pengutronix.de>
References: <1337152826-9850-1-git-send-email-sonic.zhang@analog.com>
 <1337152826-9850-8-git-send-email-sonic.zhang@analog.com>
 <CAM=Q2csSuQ3R9U=XKwj9F0xijTxx_ULperAiQYD_X3a5GKVjFg@mail.gmail.com>
 <DB904C5425BA6F4E8424B3B51A1414D170230E5ADF@NWD2CMBX1.ad.analog.com>
 <CAM=Q2cveBrYUiNYEbUgXyTnK2JhVD8UyhGgYJ=Zr86YnMMJ6Dg@mail.gmail.com>
 <DB904C5425BA6F4E8424B3B51A1414D170230E5AF6@NWD2CMBX1.ad.analog.com>
 <CAM=Q2cvUVuOMQ+Q=uLUkHN+ioqVtQ=bhPgrcnbyuUavAjES1-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZPDwMsyfds7q4mrK"
Content-Disposition: inline
In-Reply-To: <CAM=Q2cvUVuOMQ+Q=uLUkHN+ioqVtQ=bhPgrcnbyuUavAjES1-g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:21e:67ff:fe11:9c5c
X-SA-Exim-Mail-From: wsa@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZPDwMsyfds7q4mrK
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 25, 2012 at 03:46:06PM +0530, Shubhrajyoti Datta wrote:
> On Fri, May 25, 2012 at 3:42 PM, Zhang, Sonic <Sonic.Zhang@analog.com> wr=
ote:
> >
> >
> >>-----Original Message-----
> >>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
> >>Sent: Friday, May 25, 2012 6:10 PM
> >>To: Zhang, Sonic
> >>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux-d=
ist-
> >>devel@blackfin.uclinux.org
> >>Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI register =
access
> >>Macro to head file.
> >>
> >>Hi ,
> >>On Fri, May 25, 2012 at 3:24 PM, Zhang, Sonic <Sonic.Zhang@analog.com>
> >>wrote:
> >>>
> >>>
> >>>>-----Original Message-----
> >>>>From: Shubhrajyoti Datta [mailto:omaplinuxkernel@gmail.com]
> >>>>Sent: Friday, May 25, 2012 5:48 PM
> >>>>To: Zhang, Sonic
> >>>>Cc: Ben Dooks; Wolfram Sang; linux-i2c@vger.kernel.org; LKML; uclinux=
-dist-
> >>>>devel@blackfin.uclinux.org
> >>>>Subject: Re: [PATCH 8/8] i2c: i2c-bfin-twi: Move blackfin TWI registe=
r access
> >>>>Macro to head file.
> >>>>
> >>>>Hi ,
> >>>>Some minor comments/ doubts.
> >>>>On Wed, May 16, 2012 at 12:50 PM, =A0<sonic.zhang@analog.com> wrote:
> >>>>> From: Sonic Zhang <sonic.zhang@analog.com>
> >>>>>
> >>>>
> >>>>A small description may be helpful.
> >>>>Also the $SUBJECT says move the patch looks more like the remove.
> >>>>Am I missing something.
> >>>
> >>> The subject says these definitions are moved to a head file by the ot=
her patch
> >>for Blackfin architecture.
> >>
> >>Got it thanks.
> >>
> >>You may want to add a dependency otherwise it might lead to a compilati=
on break?
> >>
> >
> > That patch for Blackfin architecture has already been merged into mainl=
ine.
> Great,
>=20
> Apologies for the noise.

I don't think this is noise, I agree with you. I'd like to see the
commit which added that and the reasoning. Usually, encapsulating the
accesses in the driver is good, because no one else should bother.

Thanks,

   Wolfram

--=20
Pengutronix e.K.                           | Wolfram Sang                |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |

--ZPDwMsyfds7q4mrK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk/WHpwACgkQD27XaX1/VRuaSQCdGS8EjVlcxO0rSKq21suhuBeX
y8YAoKMuNQtI/7vHgZ1NhHOzLmLM1dKb
=ALKQ
-----END PGP SIGNATURE-----

--ZPDwMsyfds7q4mrK--
