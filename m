Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757023Ab2EYJbA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 05:31:00 -0400
Received: from na3sys009aog130.obsmtp.com ([74.125.149.143]:55447 "EHLO
	na3sys009aog130.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756316Ab2EYJa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 05:30:58 -0400
Date: Fri, 25 May 2012 12:29:28 +0300
From: Felipe Balbi <balbi@ti.com>
To: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, arnd@arndb.de, svadivu@ti.com,
        aneesh@ti.com
Subject: Re: [PATCH] misc: emif: fix compilation error
Message-ID: <20120525092927.GI3850@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1337933492-25361-1-git-send-email-balbi@ti.com>
 <CAMQu2gxeB1h9aieJU_WvCK2rPPLYkOVN8gw0i8xBm6yEPRNmHQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xQR6quUbZ63TTuTU"
Content-Disposition: inline
In-Reply-To: <CAMQu2gxeB1h9aieJU_WvCK2rPPLYkOVN8gw0i8xBm6yEPRNmHQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--xQR6quUbZ63TTuTU
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, May 25, 2012 at 02:40:18PM +0530, Shilimkar, Santosh wrote:
> On Fri, May 25, 2012 at 1:41 PM, Felipe Balbi <balbi@ti.com> wrote:
> > commit 99d3eccf (ARM: OMAP4/5: EMIF: Probe
> > Emif driver with initcall) introduced a compile
> > error by not removing module_init() when adding
> > postcore_initcall().
> >
> > This problem would've been caught by just compiling
> > the driver as module.
> >
> > Fix the issue by removing module_init() from the
> > driver.
> >
> > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > ---
> > =A0drivers/misc/emif.c | =A0 =A01 -
> > =A01 file changed, 1 deletion(-)
> >
> > diff --git a/drivers/misc/emif.c b/drivers/misc/emif.c
> > index 36fda8e..8725ea9 100644
> > --- a/drivers/misc/emif.c
> > +++ b/drivers/misc/emif.c
>=20
> This driver is in drivers/memory now and this patch is
> certainly not applicable. Looks like you might have seen
> this issue with the older, internal version of the driver.

could be.. I probably merged something I shouldn't on my master branch
;-)

Weird is that my master is built on top of v3.4... anyway.. forget about
this patch, sorry for the noise.

--=20
balbi

--xQR6quUbZ63TTuTU
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPv1D3AAoJEIaOsuA1yqREOzwQAKV7sWI7YBbvxI/ANXR1/uPw
8bwd7ys64mhcOCGrcAcu0j9j6gSksQd7LBiHh0MCibtMyDJEim1T5A6ue+Zvi/8e
oMejKsH3gJu8zo0PKTJAVVLTA4JYKKKsGCD+zCZ8ttArqjPdDREqKhUNGdIBR8Bi
UHKtydi8fEDSkK1af0f8b6wdStruPr4II8jHpFEHK9PMzXQhsNacPbro71fb7x4N
G19FIRP4NAYq9V2k+8D3AhNJ+eoAy/ySRvTaQpNXV3pmVy+7TlmK0yeCrIyfp966
z2B5tqEjsh/0kS5icpnAbPxyALR5QdOjjCN6jelHNYQcS4Ljp+3bLXC8Ay2MP6U2
yLUJnNDZHadl3JgicPZD7XcElYx7EOnoguMZ/w1ZAy/OlKRyB9fsZwnXa6KgCg8z
nF+d7LG1mPX8YhxS0EKaey5jEJ+Wp+XRlXXyXIfaRoPo46U9JCCok5OJBUsyr0sQ
1ddsXjDvY+IP3ius8m8Dwd9zNkOAjqfh8pVfN5lWYcIb/IF1fLuiLnRnMaHaRVrp
FPxoVJbq7B1h/hWivtlT7+uo10NbJr57FT1riVhJc9X47y2U6gqn9blEjpboZ/v6
tGc56dG3ZwnZdmoTDyjq+UGr1PAGd4EeaxOgvsJFqFoqNYk0+dfKIlV1QupSuLEO
fiZw394eryyzw36zPET/
=v4IQ
-----END PGP SIGNATURE-----

--xQR6quUbZ63TTuTU--
