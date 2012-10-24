Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161113Ab2JXS65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 14:58:57 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:32938 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934943Ab2JXS6z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 14:58:55 -0400
Date: Wed, 24 Oct 2012 21:53:04 +0300
From: Felipe Balbi <balbi@ti.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: Felipe Balbi <balbi@ti.com>, Tony Lindgren <tony@atomide.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
        <linux@arm.linux.org.uk>, Santosh Shilimkar <santosh.shilimkar@ti.com>
Subject: Re: [PATCH] Revert "serial: omap: fix software flow control"
Message-ID: <20121024185304.GA772@arwen.pp.htv.fi>
Reply-To: <balbi@ti.com>
References: <1350396562-32579-1-git-send-email-balbi@ti.com>
 <20121016151357.GN15569@atomide.com>
 <20121024100254.GG5665@arwen.pp.htv.fi>
 <20121024185742.GA26995@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="EVF5PPMfhYS0aIcm"
Content-Disposition: inline
In-Reply-To: <20121024185742.GA26995@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--EVF5PPMfhYS0aIcm
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Oct 24, 2012 at 11:57:42AM -0700, Greg KH wrote:
> On Wed, Oct 24, 2012 at 01:02:55PM +0300, Felipe Balbi wrote:
> > Hi Greg,
> >=20
> > On Tue, Oct 16, 2012 at 08:13:59AM -0700, Tony Lindgren wrote:
> > > * Felipe Balbi <balbi@ti.com> [121016 07:16]:
> > > > This reverts commit 957ee7270d632245b43f6feb0e70d9a5e9ea6cf6
> > > > (serial: omap: fix software flow control).
> > > >=20
> > > > As Russell has pointed out, that commit isn't fixing
> > > > Software Flow Control at all, and it actually makes
> > > > it even more broken.
> > > >=20
> > > > It was agreed to revert this commit and use Russell's
> > > > latest UART patches instead.
> > > >=20
> > > > Cc: Russell King <linux@arm.linux.org.uk>
> > > > Signed-off-by: Felipe Balbi <balbi@ti.com>
> > >=20
> > > This seems like the best way to go for the -rc series:
> > >=20
> > > Acked-by: Tony Lindgren <tony@atomide.com>
> >=20
> > Any chance you can pick this one up for v3.7-rc3 ?
>=20
> Now queued up, sorry for the delay.

no problems, thanks a lot.

--=20
balbi

--EVF5PPMfhYS0aIcm
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJQiDkPAAoJEIaOsuA1yqREfdkP/jqySj8uLO7QnA46FmvInRuU
DvdL6zyaB+ej5CSCVHNPg+MQmn3/0Rtr4rlYdjKM+YfKyFLpJmBHn2EbrEJQIaH1
jmn0FyYtZs3U+k0daokMNHgfSZoeVrR3rZ/yhYmUeghflU4cPGLztIC+B2L7NJa7
cX904iOk/8glHLYpYGY0Uvy8MNHc1cHATEXAmliECwcZq3GD6I/1ML/No/RfhP4B
WWtU2UNT81k1ZWF/XMys0BaJ4S0PAnNQG0fn3OFWo0KHOyQ/S47JVoP9FznWw0jf
s2Yq+GrynuHA+awMi8/pU8Op0WJzAnJ00135mlFsNxBqby58mNbYrR2Ulhtmo4N2
2GLXnCLe3hn95kJUEEy7lsaDCHZw8nrNi5CHqUrDOd4+ayMgmOLTEagx62ns6MH8
BbkI419kNjTfFAq061MgVlWdbC1MMuOfWTvn//Gp2hZX42bqQzfNxTZUqw0Sc9Zf
MnPU8zOAnU9vLVdt2uJOi2TMVSVCxhUSZWEfOefRHRVJW/hID7Yw045dR4vVr/bf
fVANl7YWUSioVTi6M8kJpt8YKLwniWzOagisZutoLeemSK44jmaDqnR8vz4+48Ni
b+96oZG2KAdCVLXClgIoN6MME1vEtwIKKM8wFJLDfG91IohUpGpqwh/2ZUuiiRVZ
S59PoZvdcZE66pVPxjYg
=L6+l
-----END PGP SIGNATURE-----

--EVF5PPMfhYS0aIcm--
