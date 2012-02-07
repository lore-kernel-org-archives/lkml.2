Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756583Ab2BGG7M (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 01:59:12 -0500
Received: from ozlabs.org ([203.10.76.45]:38746 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754622Ab2BGG7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 01:59:11 -0500
Message-ID: <1328597934.6802.6.camel@concordia>
Subject: Re: [Qemu-devel] [RFC] Next gen kvm api
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Scott Wood <scottwood@freescale.com>
Cc: Anthony Liguori <anthony@codemonkey.ws>,
        Eric Northup <digitaleric@google.com>, Avi Kivity <avi@redhat.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>, qemu-devel <qemu-devel@nongnu.org>
Date: Tue, 07 Feb 2012 17:58:54 +1100
In-Reply-To: <4F302E0D.20302@freescale.com>
References: <4F2AB552.2070909@redhat.com>
	 <CAG7+5M0s_F93G3dPrRQaFMVv_hPzpd-wYEPApJUDGhh3vJuy-A@mail.gmail.com>
	 <4F2C6517.3040203@codemonkey.ws> <4F302E0D.20302@freescale.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
	protocol="application/pgp-signature"; boundary="=-NPSjDqGcvI+C4OAzKwu4"
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-NPSjDqGcvI+C4OAzKwu4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2012-02-06 at 13:46 -0600, Scott Wood wrote:
> On 02/03/2012 04:52 PM, Anthony Liguori wrote:
> > On 02/03/2012 12:07 PM, Eric Northup wrote:
> >> On Thu, Feb 2, 2012 at 8:09 AM, Avi Kivity<avi@redhat.com>  wrote:
> >> [...]
> >>>
> >>> Moving to syscalls avoids these problems, but introduces new ones:
> >>>
> >>> - adding new syscalls is generally frowned upon, and kvm will need
> >>> several
> >>> - syscalls into modules are harder and rarer than into core kernel co=
de
> >>> - will need to add a vcpu pointer to task_struct, and a kvm pointer t=
o
> >>> mm_struct
> >> - Lost a good place to put access control (permissions on /dev/kvm)
> >> for which user-mode processes can use KVM.
> >>
> >> How would the ability to use sys_kvm_* be regulated?
> >=20
> > Why should it be regulated?
> >=20
> > It's not a finite or privileged resource.
>=20
> You're exposing a large, complex kernel subsystem that does very
> low-level things with the hardware.  It's a potential source of exploits
> (from bugs in KVM or in hardware).  I can see people wanting to be
> selective with access because of that.

Exactly.

In a perfect world I'd agree with Anthony, but in reality I think
sysadmins are quite happy that they can prevent some users from using
KVM.

You could presumably achieve something similar with capabilities or
whatever, but a node in /dev is much simpler.

cheers

--=-NPSjDqGcvI+C4OAzKwu4
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAABCAAGBQJPMMuuAAoJEFHr6jzI4aWAy20P/jq4i3CvLydEUAPNIVqCS6Ll
G/xdvq/p0NWNpIQWYLntc+8hvjaJUjDboa2uXsAZCdOc5X5r2oazdxotDz7ywjx4
rP5/eJWZnLmfMRnsLrSEWEDqxVGtj1tMY6ae5cgKTglM+gk3OBoeM6hfiBnp+4Jd
A6h8Z/XFUSNq9m3koakRIme9qQ5leC/6mTI2M+tbQOCaWIkUFjhBx09tTub56m3m
eCfizOJFczJdXVb58KyN4DYx0vYF51xsHwGaoRImzAz7l+4tSMMptBnC8rADsPYN
c/Fx0fijDR+yAF3R1SogbH/BnInA1KvfHw2Vv0uwDdbYJpV6QaCq8TQGhANKC1fm
aNaDvr0IWwhQ0uuzW0qX6lwjqiqp4Hw9cOlOzv0kyVVetKQWA2xl4m0vnqF3/d4q
mmw2DJMz6xc45tSmtS1tpyBZtHE1gSwMmEGcE9VKUpeEN3z8Fg+w0w4qG7xmTsUK
3xxMDnTOPFaaslFEK2nyi6xiOQPO7K06ViEnsxyxuTLPSeLB5tul5XMtyqQDMoNN
EdWPgdmv5rItDXtzES6ihs3ChWbox2ok0IvrXGUItAwRPuRIr8gp8na1lgn/NufG
GvsOGb8E/cyoFUzls0NzKiiphkwiYmfSxeD6QdorRoSBRdcTghcDbr+T8/W7jzbg
iARgii4fM/2QhLFwDIK3
=3BUR
-----END PGP SIGNATURE-----

--=-NPSjDqGcvI+C4OAzKwu4--

