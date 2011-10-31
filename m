Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933368Ab1JaRSp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 13:18:45 -0400
Received: from oproxy7-pub.bluehost.com ([67.222.55.9]:58569 "HELO
	oproxy7-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932861Ab1JaRSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 13:18:43 -0400
Date: Mon, 31 Oct 2011 10:18:39 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [git pull] PCI changes
Message-ID: <20111031101839.79dce5ba@jbarnes-desktop>
In-Reply-To: <201110290130.45150.rjw@sisk.pl>
References: <20111028132935.6630b575@jbarnes-desktop>
	<201110290130.45150.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/QoTgZGU.=3i8byHs7sfzdri"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/QoTgZGU.=3i8byHs7sfzdri
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 29 Oct 2011 01:30:44 +0200
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> Hi,
>=20
> On Friday, October 28, 2011, Jesse Barnes wrote:
> > Note!  There are two branches available, see below.
> >=20
> > The following changes since commit
> > e9308cfd5ab4ade3d81cf591c7599c3a05a21b04:
> >=20
> >   Merge branch 'gpio/merge' of git://git.secretlab.ca/git/linux-2.6 (20=
11-10-14 17:07:52 +1200)
> >=20
> > are available in the git repository at:
> >=20
> >   git://git.kernel.org/pub/scm/linux/kernel/git/jbarnes/pci next-revert
> >=20
> > Probably the most exciting bits of this series are the MPS fixes and
> > Joerg's PASID stuff.  But I don't think there's anything really risky
> > (i.e. no big resource management changes this time around).
> >=20
> > We found a problem on PPC with the latency setup changes, so this
> > branch includes reverts for those patches.  However, another branch is
> > available with those patches rebased out if you prefer a cleaner
> > changelog.  See below for the changelog and diffstat to expect from
> > that branch.
> >=20
> > Ben Hutchings (2):
> >       PCI: Add Solarflare vendor ID and SFC4000 device IDs
> >       PCI: Add quirk for known incorrect MPSS
> >=20
> > Benjamin Herrenschmidt (2):
> >       PCI: Make pci_setup_bridge() non-static for use by arch code
> >       pci: Clamp pcie_set_readrq() when using "performance" settings
> >=20
> > Jan Beulich (1):
> >       x86: constify PCI raw ops structures
> >=20
> > Jesse Barnes (7):
> >       Revert "PCI: latency timer doesn't apply to PCIe"
> >       Revert "PCI: x86: use generic pcibios_set_master()"
> >       Revert "PCI: sh: use generic pcibios_set_master()"
> >       Revert "PCI: mn10300: use generic pcibios_set_master()"
> >       Revert "PCI: mips: use generic pcibios_set_master()"
> >       Revert "PCI: frv: use generic pcibios_set_master()"
> >       Revert "PCI: Pull PCI 'latency timer' setup up into the core"
> >=20
> > Joerg Roedel (4):
> >       PCI: Move ATS implementation into own file
> >       PCI: Export ATS functions to modules
> >       PCI: Add implementation for PRI capability
> >       PCI: Add support for PASID capability
> >=20
> > Jon Mason (3):
> >       PCI: Workaround for Intel MPS errata
> >       PCI: enable MPS "performance" setting to properly handle bridge M=
PS
> >       PCI: Clean-up MPS debug output
> >=20
> > Josh Boyer (1):
> >       PCI quirk: mmc: Always check for lower base frequency quirk for R=
icoh 1180:e823
> >=20
> > Myron Stowe (7):
> >       PCI: Pull PCI 'latency timer' setup up into the core
> >       PCI: frv: use generic pcibios_set_master()
> >       PCI: mips: use generic pcibios_set_master()
> >       PCI: mn10300: use generic pcibios_set_master()
> >       PCI: sh: use generic pcibios_set_master()
> >       PCI: x86: use generic pcibios_set_master()
> >       PCI: latency timer doesn't apply to PCIe
> >=20
> > Prarit Bhargava (1):
> >       PCI hotplug: acpiphp: Prevent deadlock on PCI-to-PCI bridge remove
> >=20
> > Rafael J. Wysocki (2):
> >       PCI / PM: Extend PME polling to all PCI devices
> >       PCI / PM: Remove unnecessary error variable from acpi_dev_run_wak=
e()
>=20
> Any chance to push https://lkml.org/lkml/2011/10/21/192 any time soon?
>=20
> It pretty much is a necessary fix for a problem with _OSC after some
> recent changes.

Yeah, pushed to my for-linus branch, thanks Rafael.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/QoTgZGU.=3i8byHs7sfzdri
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOrthvAAoJEIEoDkX4Qk9hOJUP/0rEaK7kN1H/DoUpOOCg5HB5
oavVTfGRy4quEBZ/FreygHYybBk3+zK1FcJOYCVGhMWm9rUS6Du6oPRE/NziZXMa
zAZfbX9MA8TInnFfTRspV854K+AqkT0yXBkXrRjCHLPCKlcBrgbSt3jIrAQk1Pgh
tFuNx8rVdIDdBpbF/iuL2i4N5CLzhpRsggwtqYJ4S90LSgwrppl2IcE60dLC0Yv/
lcYXliaOyIKVRoSummDaHu8NXgWqinSzrBUYKjJTXRT4+pzjbyY2IYMekViPIGfz
gJvnZ+7Jc4/ZaG3cdV53ZvHJKrDmMRJqq32Yqp+q+aiKZ6XoMjYkjiFaWGGzs+hj
tu8dFhcdf11VkmK4FyCdLAFk7rBD1GnLoLQriErKusPipb0yj1UrbJ/Gz8SI6zrR
IWhBI2ExSiz7SHPbmL3aXDJkXu7N80rqHTfR934HvG7MNX7EM5+vH06COhL1iR4I
YWXnML4XsqJ0y72BscNbsWtRns710FzW3iTkr3+oMI/gnB//5aLFzvKkyt5heRvw
WUOEg+NndhvsWu1BtmF0ZMXAGUcTsHdjpQ44mUIf1PcVniD+8hFE5WkBwzRw7vDF
OrSj/svSUDRz0o6QNI+myE7nuVSNqBsjdh00XLW/pfqbHWqyxiL27Ra70Oh81323
McPPQ7BhO4F5PZ35Krq5
=qA69
-----END PGP SIGNATURE-----

--Sig_/QoTgZGU.=3i8byHs7sfzdri--
