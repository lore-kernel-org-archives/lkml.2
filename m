Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab2A0SbT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 13:31:19 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:38088 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753570Ab2A0SbP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 13:31:15 -0500
Date: Fri, 27 Jan 2012 10:31:10 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Seth Heasley <seth.heasley@intel.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        james.d.ralston@intel.com
Subject: Re: [PATCH 6/6] pci: irq and pci_ids patch for Intel Lynx Point
 DeviceIDs
Message-ID: <20120127103110.2a4d667f@jbarnes-desktop>
In-Reply-To: <201201231646.24194.seth.heasley@intel.com>
References: <201201231646.24194.seth.heasley@intel.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/WpPe4ajWb+6sZKoA8.4d8Ds"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/WpPe4ajWb+6sZKoA8.4d8Ds
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 23 Jan 2012 16:46:24 -0800
Seth Heasley <seth.heasley@intel.com> wrote:

> This patch adds the LPC Controller DeviceIDs for the Intel Lynx Point PCH.
>=20
> Signed-off-by: Seth Heasley <seth.heasley@intel.com>
> ---
>  arch/x86/pci/irq.c      |    4 +++-
>  include/linux/pci_ids.h |    2 ++
>  2 files changed, 5 insertions(+), 1 deletions(-)
>=20
> diff --git a/arch/x86/pci/irq.c b/arch/x86/pci/irq.c
> index 372e9b8..22468b6 100644
> --- a/arch/x86/pci/irq.c
> +++ b/arch/x86/pci/irq.c
> @@ -604,7 +604,9 @@ static __init int intel_router_probe(struct irq_route=
r *r, struct pci_dev *route
>  	||  (device >=3D PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MIN &&
>  	     device <=3D PCI_DEVICE_ID_INTEL_DH89XXCC_LPC_MAX)
>  	||  (device >=3D PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MIN &&
> -	     device <=3D PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX)) {
> +	     device <=3D PCI_DEVICE_ID_INTEL_PANTHERPOINT_LPC_MAX)
> +	||  (device >=3D PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MIN &&
> +	     device <=3D PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MAX)) {
>  		r->name =3D "PIIX/ICH";
>  		r->get =3D pirq_piix_get;
>  		r->set =3D pirq_piix_set;
> diff --git a/include/linux/pci_ids.h b/include/linux/pci_ids.h
> index 31d77af..6a0359a 100644
> --- a/include/linux/pci_ids.h
> +++ b/include/linux/pci_ids.h
> @@ -2800,6 +2800,8 @@
>  #define PCI_DEVICE_ID_INTEL_82454NX     0x84cb
>  #define PCI_DEVICE_ID_INTEL_84460GX	0x84ea
>  #define PCI_DEVICE_ID_INTEL_IXP4XX	0x8500
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MIN	0x8c40
> +#define PCI_DEVICE_ID_INTEL_LYNXPOINT_LPC_MAX	0x8c5f
>  #define PCI_DEVICE_ID_INTEL_IXP2800	0x9004
>  #define PCI_DEVICE_ID_INTEL_S21152BB	0xb152
> =20

Seems we add every new GMCH or PCH anyway, why not just use the piix
routines for any unknown (therefore presumably new) Intel PCH device?

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/WpPe4ajWb+6sZKoA8.4d8Ds
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPIu1uAAoJEIEoDkX4Qk9h4tYQAKFpQ8kAUWHl13VVJMl4kyQg
BcR0HcXskOB2zpgCTefxwe92extMDVABopqGCo/pvvrl2dl+3LhB532Evj3n5Pja
E2p8NKEWWlMBbLVzjYQM0YwKBTQNVAHQbKtRsMUsDDrA2WniA/jjiVpjxvUW2LGw
q0Ma+YmxrRFg2wAYoWowIo04gSDu35yCCRIzK30Oodcj9q393b3oU4xsI73S/SEl
hK6eYZX4IPQM1Tw9ovjGQQngSx8peQjdzNcSnArozkVSXoYKlCL6AkY9d2Zs/ql/
59c9Y0r7yWkecrn24wntvOebf3MDWDpImvZVNyB5XYicFgW0wVZMHh9z64IYpFUA
DdGaXdW/5+ogs9MjQjBqSDRIpYhATvu1WTII+JJoQVNNO9OJcR8qNEMU+jVTdgq+
5Xq1b7sFqDDqJgveMkOzL+hIdrOyA2ODBtrlS3/sFDYw+Qpyey7MePIy1g8mbrJB
hNlNYbQ0GcZ7zTcJi3VEfiy99ICL0PGRZpZYZ0ZX+641u/wLDdxOUx948AUefpYW
dqwzff/apAoMdpaef1akR5RXsh2THl4rWUUUKlVQYYYQXmfbJ8btxaYY5RwQsvXv
cuSy71i5bag5dXHol5D1iC5GrUlnJxLcayle3DjSGhrDpVMUWsD+MINlScB2tbf7
hHaCnqcHf5j+T7FhiQJ8
=GtcP
-----END PGP SIGNATURE-----

--Sig_/WpPe4ajWb+6sZKoA8.4d8Ds--
