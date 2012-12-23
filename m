Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752329Ab2LWVMJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Dec 2012 16:12:09 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:37818 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab2LWVMH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Dec 2012 16:12:07 -0500
Message-ID: <1356297096.21837.27.camel@deadeye.wl.decadent.org.uk>
Subject: Re: [2.6.32.y, 2.6.34.y] Re: [PATCH] x86: Don't use the EFI reboot
 method by default
From: Ben Hutchings <ben@decadent.org.uk>
To: Willy Tarreau <w@1wt.eu>
Cc: Jonathan Nieder <jrnieder@gmail.com>, stable@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, x86@kernel.org, hpa@zytor.com,
        linux-kernel@vger.kernel.org, Keith Ward <keith@chaos-realm.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Date: Sun, 23 Dec 2012 21:11:36 +0000
In-Reply-To: <20121223210348.GG3263@1wt.eu>
References: <1309985557-15350-1-git-send-email-mjg@redhat.com>
	 <20121223205950.GA16511@elie.Belkin> <20121223210348.GG3263@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-fUFBMKE+1IfnTd6XJk2n"
X-Mailer: Evolution 3.4.4-1 
Mime-Version: 1.0
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-fUFBMKE+1IfnTd6XJk2n
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, 2012-12-23 at 22:03 +0100, Willy Tarreau wrote:
> Hi Jonathan,
>=20
> [ccing Paul for 2.6.34]
>=20
> On Sun, Dec 23, 2012 at 12:59:50PM -0800, Jonathan Nieder wrote:
> > Hi Willy et al,
> >=20
> > Please consider
> >=20
> >   f70e957cda22 x86: Don't use the EFI reboot method by default,
> >                2011-07-06
> >=20
> > for application to the 2.6.32.y and 2.6.34.y trees.  The patch was
> > applied upstream late in the 3.0 cycle, so newer kernels don't need
> > it.
> >=20
> > In 2011, Keith Ward wrote[1]:
> >=20
> > > When attempting to reboot my my UEFI enabled system, the system hangs=
 when
> > > calling reboot requiring me to manually reset the system via the rese=
t switch.
> > >
> > > Screenshot: http://twitgoo.com/29bq1c
> >=20
> > Ben Hutchings writes[1]:
> >=20
> > > Version: 3.0.0-1
> > >
> > > I also had this problem on my own system, but it is fixed now.
> > > I bisected the fix to:
> > >
> > > commit f70e957cda22d309c769805cbb932407a5232219
> > > Author: Matthew Garrett <mjg@redhat.com>
> > > Date:   Wed Jul 6 16:52:37 2011 -0400
> > >
> > >     x86: Don't use the EFI reboot method by default
> > >
> > > which is basically equivalent to the workaround!
> > >
> > > I'll also apply this fix to squeeze as it's so simple.
> >=20
> > Keith Ward also wrote[1]:
> >=20
> > > It seems as if this has recently been reported at Ubuntu's Launchpad =
as well:
> > > https://bugs.launchpad.net/ubuntu/+source/linux/+bug/721576
> >=20
> > There are a variety of reports of the same panic at that bug on
> > 2.6.32.y-, 2.6.38.y-, and 2.6.39-based kernels.  Passing "reboot=3Da,w"
> > on the kernel command line avoids trouble for reporters.
> >=20
> > Regards,
> > Jonathan
> >=20
> > [1] http://bugs.debian.org/626022
>=20
> Thanks for the detailed report. I'm queuing it now.

In 2.6.32 the relevant code is in arch/x86/kernel/efi.c.  With the
filename changed, the patch applies cleanly and works for me.

Ben.

--=20
Ben Hutchings
One of the nice things about standards is that there are so many of them.

--=-fUFBMKE+1IfnTd6XJk2n
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIVAwUAUNdziOe/yOyVhhEJAQrvKhAAs7jxdNAxSIVOMwpMWRW3tNOcC+7Rb4Yz
EQEkatKJ8bP/R/bqMmwLPXeZpnlB5xDlHcn6QlQjnMyPdqGFEaCDJTwX3YfB0c3p
NjHr5lB6aEy5yFlFnhnTwuOndKyxQ6tjQ11AIDQjI7n8U9LJQGVAipMRl81RxsSx
TD9qa4xe8jWPEcI+ILVGZTdQu6D/V/VTLjPCDqEej9LkF/blUuUzKjrt8anD+dvG
75RHxpa1eysDSkAahMSt7NGDPv3JvLN0dM3CVl6okyCIHPWq/gm6Yy71qxQe7hu+
VkbtBGEq+wul0fwhkxXS5IdPuEyK4w+ahpP4xUI6kLrjYxC5ctUWvJX7CJmgX+02
0iMkIpueRm2Rk6ue9p4MUiQm8L4QvE1qZE25+a6dUiBEYuFc0umh4prMSqLu18Am
CX1zcKm0eXUxtaPPWHioteaf37cS47EhvVHUMcZJqe+tq+/kEiTtfyKJjsgPDVP4
YUKX0Jmezq91zTftBO/zN8ka+Z293IVMyL6OtNWRvb7LPnIhytYP90GsTn0Wztp9
+FMdb3plbIRT/2/kq4tYZOFM6UzuHayd64nC+m69Bo4oUMGB8wb5qpCLcsiyybch
DFC+0ZVlNmg/LVzMX+zMTJPpI+7Ha9fYK0eucyF5eqyBBy6zcqxcuslaCqGjMlmI
ISwJtq2GUIw=
=FQqP
-----END PGP SIGNATURE-----

--=-fUFBMKE+1IfnTd6XJk2n--
