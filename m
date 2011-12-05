Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932267Ab1LETEL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:04:11 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:44189 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932118Ab1LETEG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:04:06 -0500
Date: Mon, 5 Dec 2011 11:06:39 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Myron Stowe <myron.stowe@redhat.com>
Cc: linux-pci@vger.kernel.org, linux@arm.linux.org.uk, vapier@gentoo.org,
        dhowells@redhat.com, ysato@users.sourceforge.jp, tony.luck@intel.com,
        fenghua.yu@intel.com, monstr@monstr.eu, ralf@linux-mips.org,
        benh@kernel.crashing.org, paulus@samba.org, lethal@linux-sh.org,
        davem@davemloft.net, cmetcalf@tilera.com, gxt@mprc.pku.edu.cn,
        tglx@linutronix.de, mingo@redhat.com, chris@zankel.net,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -v2 01/16] PCI: add declaration for pcibios_set_master()
 to pci core
Message-ID: <20111205110639.479a6e8e@jbarnes-desktop>
In-Reply-To: <20111028214735.20088.19168.stgit@amt.stowe>
References: <20111028214726.20088.30551.stgit@amt.stowe>
	<20111028214735.20088.19168.stgit@amt.stowe>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/DSe3th4XPaWhByCfG_A7OoH"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/DSe3th4XPaWhByCfG_A7OoH
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Oct 2011 15:47:35 -0600
Myron Stowe <myron.stowe@redhat.com> wrote:

> From: Myron Stowe <mstowe@redhat.com>
>=20
> Currently, pcibios_set_master() is implemented in architecture-
> specific code.  There is nothing architecture-specific about PCI's
> 'latency timer'.
>=20
> This patch adds a declaration for pcibios_set_master() to PCI's core
> in preperation for pulling the function itself up into the core.
> Without the addition of this declaration, subsequent patches that
> remove inline definitions of pcibios_set_master() would be removing
> the only declaration of such.
>=20
> No functional change.
>=20
> Signed-off-by: Myron Stowe <myron.stowe@redhat.com>
> ---

Ok this series is in -next.  Let's see what breaks this time. :)

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/DSe3th4XPaWhByCfG_A7OoH
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RY/AAoJEIEoDkX4Qk9hxmUQAJB7f32Jn6j/KKvHA3ONU81B
DJUnfedHpLTg8vqUDYxCF1JQDblPst7P2xzLn5BxvCHkwNTeYU/9is5/QhKzJlSZ
mTPbLJOnnad5JwyTsAHQySQTVJTeW1vRlqfYDajVUI0l3zrRakJD4DLi41B+obFm
dy0Nz2aT3v0rWjYcrjniYdF4FcbSs3pmWGMqM7YRzwTmzNIk42LltsZvsa6O1aRS
6YKT/NpiNMq87s9iH5hIXCYNs40P3EZnYVHWF+XKDUodBbsyJUGNmoqlEFNULqbS
iTbs+UdmBFjTrlmwniJfr4yPEjDLcb2cXuR703qjCNYpWreTPS77jDjaz9f1S6/I
IjBOA38aL4quvAqxh2H10rif/ZWwmSAm0kQPKKANJEyMCGKgcCeHBw9+vIrHVrX2
B7QOTabxko9z9eVn8tq/KfWK6DE7MUSGRnYoZ8o3TvDvxK/vZUjzI/GwtXphsXWZ
SZqddyT6DFQqQRGlr7voB1EVOrSXW4Xnmm6BnhpHNGlyXJ+DuqvwQM67LnHRoxHj
5XKCw/R+v3hePvJIkqKeMh09tV8NwknObf0kGtW3+t3tP4ya0MxroIAiUUZmT24J
5rCPmh8aLGVZVUzqphPed9xQsVs77Qg2bvJRUTbwWtA7Neu9Y4wY7K3T9CplxR3g
zw3W+YM/ydVmkok4puCp
=vvhO
-----END PGP SIGNATURE-----

--Sig_/DSe3th4XPaWhByCfG_A7OoH--
