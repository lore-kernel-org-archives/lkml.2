Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756334Ab1LETCu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:02:50 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:46782 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756136Ab1LETCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:02:48 -0500
Date: Mon, 5 Dec 2011 11:05:22 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alex Williamson <alex.williamson@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PCI: Fix PCI_EXP_TYPE_RC_EC value
Message-ID: <20111205110522.223ff7d2@jbarnes-desktop>
In-Reply-To: <20111116162350.7705.28083.stgit@bling.home>
References: <20111116162350.7705.28083.stgit@bling.home>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RsAavryYXOb0CVGpCuytDEM"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/RsAavryYXOb0CVGpCuytDEM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 16 Nov 2011 09:24:16 -0700
Alex Williamson <alex.williamson@redhat.com> wrote:

> Spec shows this as 1010b =3D 0xa
>=20
> Signed-off-by: Alex Williamson <alex.williamson@redhat.com>
> ---
>=20
>  include/linux/pci_regs.h |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>=20
> diff --git a/include/linux/pci_regs.h b/include/linux/pci_regs.h
> index 090d3a9..9e37250 100644
> --- a/include/linux/pci_regs.h
> +++ b/include/linux/pci_regs.h
> @@ -392,7 +392,7 @@
>  #define  PCI_EXP_TYPE_DOWNSTREAM 0x6	/* Downstream Port */
>  #define  PCI_EXP_TYPE_PCI_BRIDGE 0x7	/* PCI/PCI-X Bridge */
>  #define  PCI_EXP_TYPE_RC_END	0x9	/* Root Complex Integrated Endpoint */
> -#define  PCI_EXP_TYPE_RC_EC	0x10	/* Root Complex Event Collector */
> +#define  PCI_EXP_TYPE_RC_EC	0xa	/* Root Complex Event Collector */
>  #define PCI_EXP_FLAGS_SLOT	0x0100	/* Slot implemented */
>  #define PCI_EXP_FLAGS_IRQ	0x3e00	/* Interrupt message number */
>  #define PCI_EXP_DEVCAP		4	/* Device capabilities */
>=20
>=20

Applied to linux-next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/RsAavryYXOb0CVGpCuytDEM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RXyAAoJEIEoDkX4Qk9hAMwQAJylBqNpmgM9yy7cAWdnFyg5
QNVPlJtvzjLZnjYKJbvKaMnzI4eIo+CldnNGHudO6dwatEN2iQzbb8Xv3vNsQHoo
tfDb4SGTlJYzWlV319Y5pYXV4u875Ogdt2K5X+nPrnC5FK7stHNZDmpmgAcwd/Ol
P+VDfbBYJ5yhO329PUbM8RSoHbf6wZnMA+ivEXCA/mky4GmSJ6Yvto4M5OSPaEKQ
nARAKmApt6hUJpjd+ccMlC6EMn71UHCDTB4K+xm2zUNme4zGcZ6vgPomwrSI1d/j
k5ZO2YMk8oSPabv32PsfJ/X2cJ796U2qoIuS/vLS5BBiV2Nd8RJcEbBUxGDnX+r7
4dTbPunOm9NgGmPSwCGIlVOXPtTXlNK04WI/FQhGxC6BHBToCmoOBi16ao5RVz+P
wv8xt+Ab0ArHCHgLy3ESAH/Fn6lH6LR0mmGPDd50/DLGiAWYOy9CLTt4fGR2163Q
dQ6uLgI3pY9V9Q4QgpIIKS2PxfaCulRv+eIXz0Aq313cO/dbRMbm7DD0XkVXQIJ7
CJveZKnhHAXTmg2nf+JdPP2hH7+pKKSR5+NnDokAj8/pQUjwSpZj9Qf5hIv7F2Kr
7dmRCr4w91cqghBYajRcOc/mELsLQIQibgN0uALY+HqxuRxBdPNUXJP5Cgn56JtU
dMWJioVDkWE+OW+PWNWE
=fnut
-----END PGP SIGNATURE-----

--Sig_/RsAavryYXOb0CVGpCuytDEM--
