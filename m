Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758054Ab2BXSSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 13:18:55 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:45662 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758036Ab2BXSSx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 13:18:53 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Yegor Yefremov <yegorslists@googlemail.com>
Subject: Re: [ANNOUNCE] util-linux v2.21
Date: Fri, 24 Feb 2012 13:18:51 -0500
User-Agent: KMail/1.13.7 (Linux/3.2.0; KDE/4.6.5; x86_64; ; )
Cc: Karel Zak <kzak@redhat.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, util-linux@vger.kernel.org
References: <20120224122755.GA2106@x2.net.home> <CAGm1_ktDhLd=YCT+zfAjQPwTKH+NLGTwew4Wc42wnwLm00RVTw@mail.gmail.com>
In-Reply-To: <CAGm1_ktDhLd=YCT+zfAjQPwTKH+NLGTwew4Wc42wnwLm00RVTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart25128220.bMNuJJtDXm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201202241318.53493.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart25128220.bMNuJJtDXm
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Friday 24 February 2012 08:31:37 Yegor Yefremov wrote:
> Hi Karel,
>=20
> On Fri, Feb 24, 2012 at 1:27 PM, Karel Zak <kzak@redhat.com> wrote:
> > The util-linux release v2.21 is available at
> >=20
> >  ftp://ftp.kernel.org/pub/linux/utils/util-linux/v2.21
> >=20
> > Feedback and bug reports, as always, are welcomed.
>=20
> I tried to cross-compile the package under Buildroot and got following
> error:
>=20
> checking whether __progname is defined... yes
> checking whether the target supports thread-local storage... yes
> configure: error: in `buildroot/output/build/util-linux-2.21':
> configure: error: cannot run test program while cross compiling

scanf_cv_alloc_modifier=3Das ./configure ...
=2Dmike

--nextPart25128220.bMNuJJtDXm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJPR9SNAAoJEEFjO5/oN/WBnsEP/2H8/Mjkm8ryNNA1AE/KzqDt
iWcQlyiks2S5FcklN8Qtn5TFXc/O+XgJtcP+SIwBbTEMpH1x9hSvyN6u/++Pr5K/
iZ4S2GAowJDcGOAj6YYJfG3G0A7JXn/JPTTSRhtVpDnKsczEvp0cffYl1pSAO0u0
qozXNhk2nxcopUCl79kDjPlxrS/ID8XEbOx8MznPK1z4/YKACz2UY4ic1ElMnBKB
WqMgfDJkRheyAtDA6KI1cmU5sJmAmvEJ9RfnqFxt1/YmldsV6zfCyu7lsA8SbSwy
DFQ4BVckyH2xn1BnOewiEd7fd4oWkXoQWGJbdU+RedygtCAidwRItUMNQ2IlOBVm
EI/3r03k7HRI8pv01MMwRQ52iDIlJHFAUEs59gG+yBIVTYwMBIIgUvZ/UVrtL/EI
frbo3c02jMvD7RLc+CrfNQ1v/zKC/GntsblLq/T+zmAmAWB18PDaBfPJHWn5kL+f
wmcjaVxh2eW2z0+UXseLmMhB31WDNaL9KboowhdbPkgFwY/SQoXd5B/CaXyC46z0
J6sPGovYf0ShaFXGre3VlGv6VFqY6/Hd1Vstn2HNHzy06FlAOpAmNAo7AxZuM+kL
dHCnwFIA3TRvbXh3NQXtL9OHrAz+B8ShdUJMU2EJnHbyBDXN6qzJZvL2xHwzSR9S
pT5s0XFZ82GjpXJX9Ffj
=bl33
-----END PGP SIGNATURE-----

--nextPart25128220.bMNuJJtDXm--
