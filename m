Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756358Ab1KKRs4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:48:56 -0500
Received: from oproxy5-pub.bluehost.com ([67.222.38.55]:36966 "HELO
	oproxy5-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754681Ab1KKRsw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:48:52 -0500
Date: Fri, 11 Nov 2011 09:49:13 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI / ACPI / PM: Avoid resuming devices that don't
 signal PME
Message-ID: <20111111094913.386ea9d1@jbarnes-desktop>
In-Reply-To: <201111062221.46819.rjw@sisk.pl>
References: <201111062221.46819.rjw@sisk.pl>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CLXG5rsRyy7ugH8vu728vqj"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/CLXG5rsRyy7ugH8vu728vqj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 6 Nov 2011 22:21:46 +0100
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>=20
> Modify pci_acpi_wake_dev() to avoid resuming PME-capable devices
> whose PME Status bits are not set, which may happen currently if
> several devices are associated with the same wakeup GPE and all
> of them are notified whenever at least one of them signals PME.
>=20
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
> ---
>  drivers/pci/pci-acpi.c |   12 ++++++++----

Applied to -next, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/CLXG5rsRyy7ugH8vu728vqj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOvWAZAAoJEIEoDkX4Qk9hiUMP/2PZfrJY+V9buFHV2pn8+/5q
yp1q0HrM3gre5N0RmxnoY4Aju9PivnhteICpMMsjQKCI/MlDrAiLtIcmjkirxgoM
6BY4kFQBf0ro1eTChgBCNyi5FrMgMgyWzdvdo5LuMHeaYwdvlMRpEJS4QWABSIUd
qdQ6kBLyuJrF1fgFGd7zPlvJXqe9a3bz0C3ZcSdS9kGDlkXsJl1rhhhJa+z32Zpc
RUID79oIU6kDmLNKvJobpweP52etFk/x79TUKWaEiS9H7BZdFn+5FU4F4k1JYYw2
hn5YT5IKOD3PC7XYdOq5ETzR2wNGznRJRxnmU9u/Zn/BQ9ENM5vEQky8MyHCtNRA
O/+KnVyebkhJMu38PErpyD9YwnyPd4TsPB2LiACHKNNOsUlIkBIVr15vDKUD4spZ
xPrM9R3TiCyELqzS/ioWq9Rsor6JWYF/SQ5sg2Dpo2pvLqRWFcQ4GruN2NJJhmh/
gHdq6gZYMRW2F6dPUEKB7zNBDVHqnU7a255wRGWFVebrns3l7p+BOd3+1Wp4r2fy
dJFjofbzwxiJUdMXpsvUj1Mc8uM5W6pDcjr8nVRYE+IVxaTVstgvrPzcy8VSluXc
pPJh7sqmJKtKXYemKSr/LzNcEaSko6Xc+H4OaVBlwC91xy+wmTeTAKT3vl0IFbyv
cas4aIhxE6f4C9XAxjfM
=KQVP
-----END PGP SIGNATURE-----

--Sig_/CLXG5rsRyy7ugH8vu728vqj--
