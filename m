Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752054Ab2A0RPl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 12:15:41 -0500
Received: from oproxy9.bluehost.com ([69.89.24.6]:60756 "HELO
	oproxy9.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751281Ab2A0RPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 12:15:40 -0500
Date: Fri, 27 Jan 2012 09:15:33 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, bhelgaas@google.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 1/3] PCI: Fix starting basis for resource requests
Message-ID: <20120127091533.52ada529@jbarnes-desktop>
In-Reply-To: <20111121185407.9603.70264.stgit@amt.stowe>
References: <20111121185401.9603.34587.stgit@amt.stowe>
	<20111121185407.9603.70264.stgit@amt.stowe>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/c12rSxJftZ/=.VPcsQv+d7/"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/c12rSxJftZ/=.VPcsQv+d7/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2011 11:54:07 -0700
Myron Stowe <myron.stowe@redhat.com> wrote:

> From: Myron Stowe <mstowe@redhat.com>
>=20
> pci_revert_fw_address() is used to reinstate a PCI device's original
> FW-assigned BIOS BAR value(s) if normal resource assignment fails.
>=20
> When attempting to reinstate an address, the point within the resource
> tree from which to attempt the new resource request should be the parent
> resource corresponding to the device, not the base of the resource tree
> (ioport_resource or iomem_resource).  For PCI devices this would
> typically be the resource corresponding to the upstream PCI host bridge
> or P2P bridge aperture.
>=20
> This patch sets the point within the resource tree to attempt a new
> resource assignment request to the PCI device's parent resource and only
> if that fails does it fall back to the base ioport_resource or
> iomem_resource.
>=20
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---

Applied these 3 to my -next branch, thanks for your patience Myron.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/c12rSxJftZ/=.VPcsQv+d7/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPItu1AAoJEIEoDkX4Qk9hsZUP/3ITxSNnBIyvUBls2OC+QhLc
0wdTSkdEAnBElCubfDEXBDg3vMONTcDZYjigNidlbNhk+e6fj16eZlXKoHdITEdS
h3X4d3FWiS/04umAlOFkFTEtiZ27E9fJGJv4Uwi6s5PEPme2Lw94VELXBmAHHxWU
gSlFp8sJHsu/R5HO1qh4mbvrpYpfW9MIOBO4Q8COPvL19Y+RPz8Ly8SVgAp9ZdaC
MjKVDCd9dqu9neWGCbpmFfMCND+kNY80PmFyEMrQ6wsJt9UiOyGqDoxI82fGeeOC
wUDF+6lChrd09S1Nj7Kx7mcEhbaZ/QAw6KRZnLshMU/cDi2g1yeiht+TBJi4zjAS
L5bCa0tqFMNGKrhJBmJDpxlow332AfQ0XTH0jPae6GUxUtV3hCO+tLMfVOWC52hz
UY+RTfPLvynFg3e7yGnEnYnno13NhUHRx9j1+wlxbaBBp2oyfwNjh4axb1QqkRuW
U0N5wgox76LVqiIYxI0dTToQ+DdRsHXqOlRkY3QYnwbRcr8jNT863aR9i2qVMwVQ
9PC3ubPF7Kvx2hMjDvRIccxfOJho7uuVbqq/YimT9xHu1sCSN6Ugb/dJ0PgA2tEP
c0j7FB4kCwoR5RrdVfa6qnwaVW/uOG3Sf52dZxSZmFjfRJurPyNGVH2vY9U8/Tyj
C/3iZoPO8Np4yI6XRyTd
=3tDm
-----END PGP SIGNATURE-----

--Sig_/c12rSxJftZ/=.VPcsQv+d7/--
