Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752316Ab1JIWgr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Oct 2011 18:36:47 -0400
Received: from na3sys009aog114.obsmtp.com ([74.125.149.211]:35143 "EHLO
	na3sys009aog114.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750851Ab1JIWgp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Oct 2011 18:36:45 -0400
Date: Mon, 10 Oct 2011 01:36:40 +0300
From: Felipe Balbi <balbi@ti.com>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: balbi@ti.com, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH -next] usb gadget: fix langwell_udc.c build error
Message-ID: <20111009223638.GA29776@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <20111007174230.702f4a0bf1fe71dab5e10961@canb.auug.org.au>
 <4E8F67C6.5020603@xenotime.net>
 <20111008100326.GA24633@legolas.emea.dhcp.ti.com>
 <4E91DF00.8060107@xenotime.net>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="CE+1k2dSO48ffgeK"
Content-Disposition: inline
In-Reply-To: <4E91DF00.8060107@xenotime.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--CE+1k2dSO48ffgeK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sun, Oct 09, 2011 at 10:50:56AM -0700, Randy Dunlap wrote:
> On 10/08/11 03:03, Felipe Balbi wrote:
> > Hi,
> >=20
> > On Fri, Oct 07, 2011 at 01:57:42PM -0700, Randy Dunlap wrote:
> >> From: Randy Dunlap <rdunlap@xenotime.net>
> >>
> >> Move function to fix langwell_udc.c build error:
> >>
> >> drivers/usb/gadget/langwell_udc.c: In function 'show_langwell_udc':
> >> drivers/usb/gadget/langwell_udc.c:1693:3: error: implicit declaration =
of function 'lpm_device_speed'
> >> drivers/usb/gadget/langwell_udc.c: At top level:
> >> drivers/usb/gadget/langwell_udc.c:2637:37: error: conflicting types fo=
r 'lpm_device_speed'
> >> drivers/usb/gadget/langwell_udc.c:1693:20: note: previous implicit dec=
laration of 'lpm_device_speed' was here
> >=20
> > I don't have this compile error on my branch, did something go in
> > without me noticing ?
>=20
> probably not.  What version of gcc are you using?

I believe it did, I don't have lpm_device_speed() at all.

> I'm using 4.5.1.

4.6.1

> > Can you blame a comit which introduced this ?
>=20
> I don't see such a commit.

$ git log --pretty=3Doneline -S'lpm_device_speed' HEAD --	\
	drivers/usb/gadget/langwell_udc.c

what's the output ?

> > btw, all I have is a warning.
>=20
> What warning?

drivers/usb/gadget/langwell_udc.c: In function =E2=80=98langwell_ep_dequeue=
=E2=80=99:
drivers/usb/gadget/langwell_udc.c:919:11: warning: cast from pointer to int=
eger of different size [-Wpointer-to-int-cast]

--=20
balbi

--CE+1k2dSO48ffgeK
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOkiH2AAoJEAv8Txj19kN1Ww0H/1eTSD4kAkXiR4JssU6pudnv
qBfHjpLDin9FrrxJkJclsVOqnCxxAdH8hN/pA74gCElXKzpl5+dwJBi7ufs4ukPW
khKwKCUT7TC/4PJCEU8yTXHMVK8EDFrkoxvmGdRQrROM+PDHYBnZUsIx2m1vhPxI
J62BS0zT8ACtp7CEiL5WsjNPa/2hIaR4FLN2xZDtHbMKbXfD8jHC4OnC3t5bB2hI
CwaoAKOdVkBmJxrYPSjzplen8Vw9xLYwcZFdwvQE3QgnMnL1wV95xW09ztYx4syr
22dHSHkpWZaRWrHZrZW4EK1iX9pXACxhsWLVEjCNk7W7PPHBsst/GvHQiSQOiWc=
=h0Nm
-----END PGP SIGNATURE-----

--CE+1k2dSO48ffgeK--
