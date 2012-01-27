Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752335Ab2A0RhD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:37:03 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:55321 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751798Ab2A0RhB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:37:01 -0500
Date: Fri, 27 Jan 2012 09:36:58 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: linux-pci@vger.kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: Probing unconfigured PCI bridge resouces
Message-ID: <20120127093658.27dc258b@jbarnes-desktop>
In-Reply-To: <1327380633.19850.33.camel@pasglop>
References: <1327379147.19850.29.camel@pasglop>
	<1327380633.19850.33.camel@pasglop>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/0C_LC6pRRQm5+i5lV0X9G.3"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/0C_LC6pRRQm5+i5lV0X9G.3
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 24 Jan 2012 15:50:33 +1100
Benjamin Herrenschmidt <benh@kernel.crashing.org> wrote:

> On Tue, 2012-01-24 at 15:25 +1100, Benjamin Herrenschmidt wrote:
>  .../...
>=20
> > Or am I missing some important fact here ?
>=20
> Ok, I think I was missing pci_bridge_check_ranges(), gotta figure now
> why this didn't kick in properly for me, probably some arch code
> crackpot.
>=20
> One thing I noticed is that we do clear IORESOURCE_UNSET in setup-res.c
> when setting up a device resource but we don't clear it for bridges in
> generic code ever, so it leaks all the way through from my early arch
> code. Not a big deal but annoying.

Maybe you can fix that when you unify your arch resource handling code
with the core one day. :)

There have been a lot of changes to handle re-allocation and such, and
I'm sure there's more duplication now...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/0C_LC6pRRQm5+i5lV0X9G.3
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIuC7AAoJEIEoDkX4Qk9h4S0QAL8t4l+FI69paZz8x9eQBemo
o2D6aI+mgA+hOA8NE/11+1PuETJdut0HYwniYeKTmwtCmgg5LtexmmpWvbSEnke1
oM4kazeuKjdheT1t7B6mjSqshzWS+t4f0PtCHMWhPfnM1Ia+eKuwIV7N6t6IsvfE
7s/dD4jBoDgwpEVHmO+23zVT7oxQ2BEpEH265pd2DKdZfoEW6VJSnyDheBqMHuC/
6hCCt+ItE8suVndFp+4+4cryo1KVfCbdJITK66sBeh0QQYQ1fuCJzNZS3wFyiOjG
VHt8V+s5J9k6zn/B4C8lQEOniX2U8nmHujpsh0rosU8DTQZop2l7fEe1qgbnRjOK
p7KF7biN88JvL+LXX0Zi7jUa1RluAAAIN/WF3hxNLLyCYNP6DHXobVEyQ++ZlTqa
iSfnvPyHQeOFNOGMFOy9VOCRwXAnGJL5vCqs/HoAAeUcW4Ue1BRz29tGnniO+Ce8
B7192+fVMfhIOAZBbvsaphuwIC2UYXOxiq3ZT6cGfTV29oct7Jc1D77o/Z5mS23i
yrdwXRtulB7q6EPaxSGDFBWOp/AARyLBcrUG0hNmQFXbi0pXCP+nIC+2QZwi5ERH
zyWwlbywpxsCLX9WD9CEH8iz9JoY1DJpwsI1kW+T9LMI/HDV0jnrSKyDJlPTp5ro
PIqir2rYEcyAbIcIAjGw
=8vZJ
-----END PGP SIGNATURE-----

--Sig_/0C_LC6pRRQm5+i5lV0X9G.3--
