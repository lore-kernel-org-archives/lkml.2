Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756543Ab1KWWno (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 17:43:44 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:46597 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753926Ab1KWWnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 17:43:42 -0500
Date: Wed, 23 Nov 2011 14:45:10 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Joerg Roedel <joerg.roedel@amd.com>
Cc: Alex Williamson <alex.williamson@redhat.com>, <linux-pci@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <bhelgaas@google.com>
Subject: Re: [PATCH 0/2] PCI: PRI/PASSID cleanup and fix
Message-ID: <20111123144510.56ff6d1d@jbarnes-desktop>
In-Reply-To: <20111123104705.GC11876@amd.com>
References: <20111111170319.32668.48479.stgit@bling.home>
	<20111123104705.GC11876@amd.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Y3FjEVf1w=WCINjDE.lVzy0"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Y3FjEVf1w=WCINjDE.lVzy0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 23 Nov 2011 11:47:05 +0100
Joerg Roedel <joerg.roedel@amd.com> wrote:

> On Fri, Nov 11, 2011 at 10:06:23AM -0700, Alex Williamson wrote:
> > Alex Williamson (2):
> >       PCI: More PRI/PASID cleanup
> >       PCI: Enable is not exposed as a PASID capability
>=20
> For both:
>=20
> Reviewed-by: Joerg Roedel <joerg.roedel@amd.com>
> Tested-by: Joerg Roedel <joerg.roedel@amd.com>

Ok, thanks guys.  I'll queue these up after Thanksgiving.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Y3FjEVf1w=WCINjDE.lVzy0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOzXd2AAoJEIEoDkX4Qk9h6N0QALQ0D+PkshQ7x/2dBdSbAOv3
Y4/cCrd5g1I+Z1t7NMVWtj6RUCSVNhCtFYKCRx9phPzhqe8HjxQ0L+OWrkJssHB8
tq9DcZC+cjfh0rIJdxj9yhYNZPyyQkjsUAAf7C5jHyJsBZ3U6CjCCqwdtHkXwGHH
iG1f3QZCiS8W5dw8OinxPgkITNFLjiJbemRXs8ZJcvy5oUsIqZ9TdExBiJLoPUqX
59QKskaNCCd7hBqGrL7c7GpKpYLsGOwBxi5FJgutv6rztIrpMOzm6H9kcdwTDEXg
eH/Kwsx1wn5PjgA0gJkDUyFQR+xkEFBc5C2FoHk/ogP5YSHn4KkmgIeFn2q3sDXi
ZpOAOHpy20gFHQ7vKg46UG33E+ZqDzqKc87msS+eL2jwS82COshGVWW0HUeMcWc8
jrXZpv12FcG4/T14U62jLu7y9kl956f3zZk90Bow32hpIJmkRH4+wywSr+MHhJkf
RYSxcJQU/qd9bV53hLrwFF47K4V41a8sU6PcqqXTFcPLgZGb8OzZpixdiIT48pv+
CFia1zLvFUsuABzB/l/gxu2gURZ1sdKty9DaaFdUNoGOv7/1lYSY9v6+L7vdJM2j
lvP55zN7t/4SkMF4urFphwFmGq9T0VIaD+44ApRB0EVknIlhxOs9syuEjaw1K87d
tp3qS8RS3QKP2MkAkdUE
=pVz3
-----END PGP SIGNATURE-----

--Sig_/Y3FjEVf1w=WCINjDE.lVzy0--
