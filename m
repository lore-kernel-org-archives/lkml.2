Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756103Ab0KXWqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 17:46:17 -0500
Received: from ozlabs.org ([203.10.76.45]:34517 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755295Ab0KXWqQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 17:46:16 -0500
Subject: Re: How do I choose an arbitrary minor number for my tty device?
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Scott Wood <scottwood@freescale.com>
Cc: Timur Tabi <timur@freescale.com>, Greg KH <gregkh@suse.de>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stuart Yoder <stuart.yoder@freescale.com>,
        devicetree-discuss@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>
In-Reply-To: <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
References: <4CE44B1B.9040709@freescale.com>
	 <20101117215147.GA26792@suse.de> <4CE452CD.3050001@freescale.com>
	 <20101117221903.GA4066@suse.de> <4CE45A4E.70308@freescale.com>
	 <20101118022434.GA9833@suse.de> <4CE546C5.8060401@freescale.com>
	 <20101118153912.GA1443@suse.de> <4CE54E40.9040503@freescale.com>
	 <20101118112146.3275eb08@udp111988uds.am.freescale.net>
	 <4CE5657D.8060105@freescale.com>
	 <20101118121356.3491da72@udp111988uds.am.freescale.net>
	 <1290594227.4446.12.camel@concordia>
	 <20101124120818.7951bcb4@udp111988uds.am.freescale.net>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-F/QU5Wdh/j0Wk+AYf+h0"
Date: Thu, 25 Nov 2010 09:46:13 +1100
Message-ID: <1290638773.14502.12.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-F/QU5Wdh/j0Wk+AYf+h0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2010-11-24 at 12:08 -0600, Scott Wood wrote:
> On Wed, 24 Nov 2010 21:23:47 +1100
> Michael Ellerman <michael@ellerman.id.au> wrote:

> > > It would be nice if platform devices that are created from device tre=
e
> > > nodes included a link to the corresponding /proc/device-tree node in
> > > their sysfs node.
> >=20
> > It's not a link, but the OF path is in devspec, so you can work it out
> > fairly easily.
>=20
> Hmm, I see a "devspec" in PCI devices, but not in devtree-probed
> platform devices.  of_bus_type_init isn't being called from anywhere
> but the ibmebus code.  It looks like this was a casualty of merging
> of_platform with platform (commit eca3930163ba8884060ce9d9ff5ef0d9b7c7b00=
f).

Ah crud, yeah I was looking at an old kernel.

That seems like a regression, but seemingly no one has complained so
perhaps it doesn't matter in practice. It was certainly a nice feature
though.

cheers


--=-F/QU5Wdh/j0Wk+AYf+h0
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkztlbUACgkQdSjSd0sB4dIPFQCePdZlTe1UowSvKb8hNWGw+WNc
FpwAnjylpwtR+LzVM9ZJJKh5mZKI/WfB
=cFgI
-----END PGP SIGNATURE-----

--=-F/QU5Wdh/j0Wk+AYf+h0--

