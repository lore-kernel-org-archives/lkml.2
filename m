Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754684Ab0EaV4d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 17:56:33 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:35742 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab0EaV4c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 17:56:32 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Jerome Glisse <glisse@freedesktop.org>
Subject: Re: [stable]  please consider drm radeon kms agp release
Date: Mon, 31 May 2010 23:56:26 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.33.2-tp42-toi-3.1-lowmem-free-991-992-04964-gf00c7ec-dirty; KDE/4.4.3; i686; ; )
Cc: Greg KH <greg@kroah.com>, stable@kernel.org,
       Alex Deucher <alexdeucher@gmail.com>, linux-kernel@vger.kernel.org
References: <201005311642.49843.Martin@lichtvoll.de> <20100531170234.GA14235@kroah.com> <20100531193815.GD2413@barney.localdomain> (sfid-20100531_234701_618602_70447610)
In-Reply-To: <20100531193815.GD2413@barney.localdomain>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1628120.qDnFc0Bigu";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201005312356.27299.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1628120.qDnFc0Bigu
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Montag 31 Mai 2010 schrieb Jerome Glisse:
> On Mon, May 31, 2010 at 10:02:34AM -0700, Greg KH wrote:
> > On Mon, May 31, 2010 at 04:42:41PM +0200, Martin Steigerwald wrote:
> > > Hi Greg, hi stable kernel team,
> > >=20
> > > Please consider the attached patch from J=E9r=F4me Glisse. It fixes d=
rm
> > > radeon KMS after coming out from a snapshot cycle [1] - no matter
> > > whether I use userspace software suspend or TuxOnIce.
> > >=20
> > > Verified on my notebook ThinkPad T42 and by cedric, the reporter of
> > > above bug.
> >=20
> > Which stable kernel release do you want to see this patch in?  .27,
> > .32, .33, or .34?  Yeah, there's a lot active at the moment :(
> >=20
> > thanks,
> >=20
> > greg k-h
>=20
> 2.6.34 sorry if i wasn't clear when ccing stable while sending patch
> for 2.6.35.

Yeah forgot to mention it also, in 2.6.33 it works. In 2.6.35 its fixed. So=
=20
it applies for 2.6.34.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart1628120.qDnFc0Bigu
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkwEMIsACgkQmRvqrKWZhMcFNgCgqVDIJhoVgGaQ36G5MreruC8F
CpwAoKuj5WSi6brxhRnHYhDj+bZyt+GB
=FgOb
-----END PGP SIGNATURE-----

--nextPart1628120.qDnFc0Bigu--
