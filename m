Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754207Ab1KMQub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 11:50:31 -0500
Received: from smtp.gentoo.org ([140.211.166.183]:53223 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752891Ab1KMQua (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 11:50:30 -0500
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Bob Liu <lliubbo@gmail.com>
Subject: Re: Blackfin.git tree change
Date: Sun, 13 Nov 2011 11:50:27 -0500
User-Agent: KMail/1.13.7 (Linux/3.1.0; KDE/4.6.5; x86_64; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        "Linux-Kernel" <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org, sonic.zhang@analog.com
References: <CAA_GA1f8+6bqXGXo33GDbJmXvaqdD-qMUh=ejx0+Ag-shmc0uw@mail.gmail.com> <20111113231944.4677bd7a2154975c989663ab@canb.auug.org.au> <CAA_GA1fFspdayjpLNpm1C-kPug6n7LXyJ0dqiX=3d_gHt2U9xg@mail.gmail.com>
In-Reply-To: <CAA_GA1fFspdayjpLNpm1C-kPug6n7LXyJ0dqiX=3d_gHt2U9xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart660606697.167xMpUnOm";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201111131150.28881.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart660606697.167xMpUnOm
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Sunday 13 November 2011 09:50:41 Bob Liu wrote:
> On Sun, Nov 13, 2011 at 8:19 PM, Stephen Rothwell wrote:
> > The only thing I did notice, is that this commit was in Mike's tree but
> > is not in yours:
> >=20
> > Author: Sonic Zhang <sonic.zhang@analog.com>
> > Date:   Mon Aug 1 17:53:21 2011 +0800
> >=20
> >    Blackfin: add serial TX IRQ in individual platform resource
> >=20
> >    The serial TX IRQ is not simply (RX IRQ + 1) on some Blackfin chips,
> >    so move the values to the platform resources.
> >=20
> >    Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> >    Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> >=20
> > Just in case it was forgotten.
>=20
> Sorry for that, I thought that patch has been merged to mainline.
> I'll update it soon. Thanks.

i figured this would be a good test for you merging things ;).  this patch=
=20
needs to be merged into mainline before 3.2 is released ... and the sooner,=
=20
the better.

it was waiting on the tty/serial layers to be merged, and now that they hav=
e,=20
that patch can now be merged.
=2Dmike

--nextPart660606697.167xMpUnOm
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJOv/VUAAoJEEFjO5/oN/WB4FgP/jYQbn53ktAvdzBXwb4a2gCw
JVwinG+Gt6EIyfbufXjE120fASGF9ym4yObt732vVOI5u8fOHPJl+leXWu7fW3hn
uk/r9yt0lh0momw42rRcK5xmScDC3q3ge2XDtHyn06EO4/Q4TGLFuJEksilDjx1Y
jEi9ZHCuxapJo4Ed5Fg0m2zhpAPcrbPemerQgjNR3rdlr8xloHkHgCZA1D29z0ul
Oo4e2RcMnbbSE44xhNxr31/BlKhQ/1fqS5dRWZcHTBU6Kev4BETRL2rc5F4RTPQd
bNsmiqmRmWioebrDj4orTmzQPT/Ub6w4SCogGduIPsWQvkLIuDeqo74A0ENthL25
SjJAOCJddYNuXXuKkkCiVppjynGtFczdAdncxMUh87Iaz6KQ+dLBjdcQwqyfPc6Q
5wt/JquHg4weEkYk8OTzyaQg6oMNCpgs3I26lmt2Vgija/eV33Hgus6VkpSKFdEs
nxYWACDScVzCKTAmLPpEvPIf2jC6Yx72y/3AFX5YYLDHdU1ohkku27Bt789kZfPv
THcvHnLm1fnBdgdM0WtDzK3jW3IhSawJ3nXPT+fnL2Q1t7BiAqfjb8zXFhNrk7qu
2U+8zknD92Kbwy9IAUngPz66smPmwf6No19l7DpIljtFqcxuSLHcL5iz9yvOy6Yc
inpxsl4K0I1G8SOF+uau
=t4CQ
-----END PGP SIGNATURE-----

--nextPart660606697.167xMpUnOm--
