Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759040Ab2AFUF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jan 2012 15:05:29 -0500
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:49605 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758924Ab2AFUF1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 15:05:27 -0500
Date: Fri, 6 Jan 2012 12:05:24 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, thuban@singularity.fr,
        dann frazier <dann.frazier@canonical.com>,
        Lisa Salimbas <lisa.salimbas@canonical.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org,
        stable@kernel.org, Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 2/2] PNP: work around Dell 1536/1546 BIOS MMCONFIG bug
 that breaks USB
Message-ID: <20120106120524.7801c73a@jbarnes-desktop>
In-Reply-To: <20120105212724.3965.30193.stgit@bhelgaas.mtv.corp.google.com>
References: <20120105212719.3965.40406.stgit@bhelgaas.mtv.corp.google.com>
 <20120105212724.3965.30193.stgit@bhelgaas.mtv.corp.google.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/8cI5J1yeKnqAf3pkmUVg2T/"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/8cI5J1yeKnqAf3pkmUVg2T/
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 05 Jan 2012 14:27:24 -0700
Bjorn Helgaas <bhelgaas@google.com> wrote:

> Some Dell BIOSes have MCFG tables that don't report the entire
> MMCONFIG area claimed by the chipset.  If we move PCI devices into
> that claimed-but-unreported area, they don't work.
>=20
> This quirk reads the AMD MMCONFIG MSRs and adds PNP0C01 resources as
> needed to cover the entire area.
>=20

applied these two, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/8cI5J1yeKnqAf3pkmUVg2T/
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJPB1QEAAoJEIEoDkX4Qk9hmqcP/3p7ELSyiNyEXfjdLUZK0RWR
wLkJE1pVf1ZMcyhQ1vSikSWw/BVMqfT2wHDvQl3Io0nFUJMmQJXRX/YZYDhWo2eX
PV5TaQ9K4Pn0UkcskfGq8Y0Ch1+MJthUeBkCp6i8CPpRrPZ+NorGPUQ9nC/cfrup
mzqqMwlRgpQN2NwW013HtEd1I5IuXy4/HNYHHk96vWdy7AdXNqIjSxr197p4u1gt
vlMQsLTH+TKoSi5CngwvCGhM98GiLuNMvy3SAlakir9cqXSo/qVmfyQLVhDX0MrC
FGglfDC6CiUmg1IzEI++bzZlfFaBgekptPYlokksikYdN7bC83sRpgo6JrQR3Wt/
MnzahLl6NcGm2BhaCByAf8UzQeM8V5c5ku6HV5b84QjfI1pF3GygIWfHxEx/Nod3
qoAKWGtemy3FVxXaYtl6pci8YvLRpC6+HgAcmcUrtZ54dbk+JhGrO8f9egZSgwDc
KKqxWb4PCtN2zJEy6BnraTMVgkwCy7rU+gSUthmo6nunAB0w4MhkQU7kLQTUXKfL
9CXtBMgZ3Bx1plwfvYJ6Jgk73kem8gG+7Dj2hMY0ABRRiwMVrLnGcNbky4Tx74BZ
f/8gtRj7kp+CIqWvzcKFsMEuklVhnxIb2CaNKaXJx+OGZ/cQHFGBWEtr0yjIljop
o9S8k5vAjBuw7Wz7qxvB
=4wH5
-----END PGP SIGNATURE-----

--Sig_/8cI5J1yeKnqAf3pkmUVg2T/--
