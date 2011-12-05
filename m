Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932147Ab1LETDh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 14:03:37 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:51882 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756492Ab1LETDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 14:03:35 -0500
Date: Mon, 5 Dec 2011 11:06:09 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Gary Hade <garyhade@us.ibm.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org,
        Bjorn Helgaas <bhelgaas@google.com>,
        Thomas Renninger <trenn@novell.com>
Subject: Re: [PATCH] x86/PCI: Ignore CPU non-addressable _CRS reserved
 memory resources
Message-ID: <20111205110609.7f4fa6e0@jbarnes-desktop>
In-Reply-To: <20111114234216.GA16000@us.ibm.com>
References: <20111114234216.GA16000@us.ibm.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IUxP=WniClYJsuWnyRQ9ZwK"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/IUxP=WniClYJsuWnyRQ9ZwK
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 14 Nov 2011 15:42:16 -0800
Gary Hade <garyhade@us.ibm.com> wrote:

>=20
> From: Gary Hade <garyhade@us.ibm.com>
>=20
> This assures that a _CRS reserved host bridge window or=20
> window region is not used if it is not addressable by
> the CPU.  The new code either trims the window to exclude
> the non-addressable portion or totally ignores the window
> if the entire window is non-addressable.
>=20
> The current code has been shown to be problematic with
> 32-bit non-PAE kernels on systems where _CRS reserves
> resources above 4GB.
>=20
> Signed-off-by: Gary Hade <garyhade@us.ibm.com>
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
> Cc: Bjorn Helgaas <bhelgaas@google.com>
> Cc: Thomas Renninger <trenn@novell.com>
> Cc: linux-kernel@vger.kernel.org
> Cc: stable@kernel.org
> ---

Applied to linux-next (don't want to send something this fundamental to
Linus at this late stage).  It can land in stable if it turns out ok in
-rc1.

Thanks,
--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/IUxP=WniClYJsuWnyRQ9ZwK
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJO3RYhAAoJEIEoDkX4Qk9hPnsP/itN2IrfeFI3xVYt0hXN9iIo
Y7KSlW/yime32zS3AFM2v55jQXxTq8TngV/KTUU5y4wO8Y0RLRLgtJHpZ5m9f+w6
315nCaQ4tp7W7cIhK3Zm3udIAv3kIqGzKMwLLGjZKM8Gm5WrPrKKpB9LucE0GuUO
wR/hHAkxaFCC3ejcxCWDJYxXNrH7YszA2C1e5w3jWoezHIo+1Bw40G6OoZQu5lux
jEylmAIJ18GlKMO5tF7FftYlSu/oDTIHKX8bSPfKRRIth9sZtLQqRUyc0Kh3tt1O
KUyMjOiAMmljw973DwCNhj/ta+bfEPiU/GLddUQTx1wM5qqQf3wxcwk3YfQHkePV
k1gpUTuggLfeqFIkw/OUl/tSg7rHBXcKGx5+BlYnXIP3kA8AWfn2Zvq7bJDmfRcb
mvWDjgqLy9Z75W43JjJieo75c8vQN25VssdPUiO5wIQGx08/Jvc6q3h3JgqXLG+P
Lt0app6O6YAcIp88vAJiGtMBiznosfAfQ1vTM46aqGmx3aLsNg3+CNzUxMIm/KdC
1aSd3XV9YRH35tMRmZgTTITptYz+HG57/QpjRGkktQEDIvmSBSlwNJ7Vb6jba/06
+rYm1zV88tPiM9McrPUcyJjZtzyB8H0U3UEl64V4krIoaE55WcAfgvDjlaHOYBiU
udof09ttbZi0DHIvqBjT
=2ASo
-----END PGP SIGNATURE-----

--Sig_/IUxP=WniClYJsuWnyRQ9ZwK--
