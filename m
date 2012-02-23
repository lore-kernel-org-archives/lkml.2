Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753782Ab2BWQ2M (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:28:12 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:44719 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752535Ab2BWQ2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:28:11 -0500
Date: Thu, 23 Feb 2012 08:28:07 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Alessandro Rubini <rubini@gnudd.com>
Cc: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, Ingo Molnar <mingo@elte.hu>,
        Giancarlo Asnaghi <giancarlo.asnaghi@st.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH V3 0/3] STA2X11: patches for pci bridge support
Message-ID: <20120223082807.28ea6f23@jbarnes-desktop>
In-Reply-To: <cover.1329947637.git.rubini@gnudd.com>
References: <cover.1329947637.git.rubini@gnudd.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Dh.inh0u.je5GM0x0g9SGBH"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/Dh.inh0u.je5GM0x0g9SGBH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 22 Feb 2012 23:13:57 +0100
Alessandro Rubini <rubini@gnudd.com> wrote:

> This series is V3 of what I sent on Jan 30th as V2.
>=20
> Patch 3 is dependent on patch 1 and 2, which are unordered.  When I
> posted V2 of this set, patch 3 was picked up, but compilation failed
> because of the missing prerequisites. Also, some prototypes changed
> in the meanwhile and patch 3 was miscompiling in linux-next so it
> has been correctly dropped.
>=20
> V3: rebased on next-20120221. Fixed patch 3 to match new DMA
> prototypes. Renamed patch 3 as Ingo and Jesse merged it. Added both of
> them to explicit Cc: list in the email set.
>=20
> V2: rebased, minor and less-minor changes in patch 3/3.
>=20
> Alessandro Rubini (3):
>   x86: introduce CONFIG_X86_DEV_DMA_OPS
>   x86: introduce CONFIG_X86_DMA_REMAP
>   x86/PCI: initial support for sta2x11 I/O hub
>=20
>  arch/x86/Kconfig                   |   34 +++-
>  arch/x86/include/asm/device.h      |    4 +-
>  arch/x86/include/asm/dma-mapping.h |    9 +-
>  arch/x86/pci/Makefile              |    2 +
>  arch/x86/pci/sta2x11-fixup.c       |  367 ++++++++++++++++++++++++++++++=
++++++
>  5 files changed, 409 insertions(+), 7 deletions(-)
>  create mode 100644 arch/x86/pci/sta2x11-fixup.c
>=20

Ingo, you may as well take the lot of these; they won't clash with
other PCI stuff if you take them, but if I take them they may well
clash with other x86 stuff.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/Dh.inh0u.je5GM0x0g9SGBH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRmkXAAoJEIEoDkX4Qk9hkaYP/3rsWfPapibUU+7EE3nF0Ldk
vymrJLDBvnRu4TVWzrQEoghC1TGepZCrvN2pA25rcjWbtpaEKTx04niQij3lI+rp
X86QnINpPFC/qYMkzfYR+uaxTOfKGsO6zo0kghA2BtUOsLkH2fAfwov6/1aaTCdl
8851aDieeNpWaZr8FvryJfyhO76XfRWCzCrqHAbzlXCaIPuMAs7DXFvFC399RC1+
nphi/V0IBLDN2kk9fTNcIHoIKO8O0gmJPAPpRtA0jNWWHySvqWuxrSab7BtYpq5f
iU50yl0uAznqETIRtLB2Js8GLNLkB+k3qOJxDEgw5j9PMRFDMkfEdkdV/NIRWb4F
TYbBqwI0YoeL0C4R4fUELT25jIPoPJ6QaAijhRD4xz4G/ExYNNoqq6Cg4DelQx7q
JMg4oFRSm0lBcSK904ocg0iBwm0LauT8QyiE0gjH3X+FpZebaZ5rNEwoVKtvyt7M
yMqHIBTfMLlc2vnquBWrAi6CKDPHuNAOHl+sErYCBfeUTxZQR46PPEvaVXpBmqni
7PVn47pIn7RFFlFiSfWPZUli0z00xRy2JTlzXcLsKBOJ0pklvCDgtEOpUZgrEcWQ
xWaL3iJt7fhHYMggeipgFwTH0+aZ9nAR71tPJSug8v/QwSOJGq8EcJyoWNEiamhO
3Uy6MNFTobj6tuRcTAkB
=xYWU
-----END PGP SIGNATURE-----

--Sig_/Dh.inh0u.je5GM0x0g9SGBH--
