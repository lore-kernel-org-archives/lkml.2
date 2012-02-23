Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755086Ab2BWQsW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 11:48:22 -0500
Received: from oproxy4-pub.bluehost.com ([69.89.21.11]:42863 "HELO
	oproxy4-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752736Ab2BWQsU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 11:48:20 -0500
Date: Thu, 23 Feb 2012 08:48:13 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org, lenb@kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: shpc with acpi=off?
Message-ID: <20120223084813.39908d81@jbarnes-desktop>
In-Reply-To: <20120216150421.GA26167@redhat.com>
References: <20120216150421.GA26167@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/eR5zNMI19XUPhk2mZEmMiX."; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/eR5zNMI19XUPhk2mZEmMiX.
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Feb 2012 17:04:22 +0200
"Michael S. Tsirkin" <mst@redhat.com> wrote:

> I have a box where shpc works fine with acpi,
> as well as when acpi is not built into kernel,
> but fails with acpi=3Doff
> Some debugging seems to indicate that
> acpi_get_hp_hw_control_from_firmware
> fails with acpi=3Doff.
>=20
> Is this a bug or is there a reason to prevent shpc
> from working in this setup?
> Do we even care about acpi=3Doff?
> Assuming we want to make acpi_get_hp_hw_control_from_firmware
> succeed with acpi=3Doff, what is the best way to do this?
> Check acpi_pci_disabled?

Yeah not sure it's important to have SHPC work with acpi=3Doff.
Disabling ACPI prevents us from getting all sorts of important info
these days...

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/eR5zNMI19XUPhk2mZEmMiX.
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBAgAGBQJPRm3NAAoJEIEoDkX4Qk9hVjoQAKLz+XnHv42HdmYLE6qtrgwe
XYGjpicKKBQfkG3rTvXQLQnPP9n6xJl7Vbi0bwvsHYr0skA49UbzATWqMi0blbUZ
WgL5CUDpFpXeC8iXTZwlbH4v7FHKd21ukB9RPX45Db11qKhQLN48cWnwJ+1Wki5D
VpWBJ8orhGTSoLBP7dlKAqE0+BMbFTraa0gnzL/UIjgGSWH1t9MhY427cagrIJhn
4DUxdqjqDzj245bybIdnCAzAxv3A5++yev89s25V6W4HqYZThf9oUZKGrkVyvQ6B
MWTOeCMVS1XHogaOtQC4Vq1q5oo0Jr7Okm82xuZduk9/Usuhwt5xpwtoYo/14+ZA
V7KIz5m1hQCNHTUL3PIr1gIBArXhRyFrKNkA8mA9DMPVa2KcrCT8GEWcbdfHRTFB
GdE4FdeRpiRpxIdxSWVaiAbG6/RX0VQmcSNyCTilzeabPf4wodPNltchtGgaeQB+
FoJ1gKHN00lA3+hltMnkpzZmA+N3qPHfgo2QG/Nc47LjghnwQumXwk7XZsfSDk13
k9eZ1vc2YquoS5sPzRSoyNGJ91+Q6BfZnZ9n+oc4WxaIYmIqXYfsifTxcaMg1N4s
B6F183bz++mO1DMIZ7QW4LMdX32cz1S/zZb4uXZVAsbTpVHGgZFmJHKpXUV1Jwhe
cL+B4aHhnurz944FmDct
=eyjL
-----END PGP SIGNATURE-----

--Sig_/eR5zNMI19XUPhk2mZEmMiX.--
