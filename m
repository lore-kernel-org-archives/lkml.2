Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754376Ab1KKRst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 12:48:49 -0500
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:56147 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751624Ab1KKRsq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 12:48:46 -0500
Date: Fri, 11 Nov 2011 09:49:05 -0800
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [PATCH] PCI / ACPI: Make acpiphp ignore root bridges using SHPC
 native hotplug
Message-ID: <20111111094905.1bc3be9d@jbarnes-desktop>
In-Reply-To: <4EB737A8.3000208@jp.fujitsu.com>
References: <201110220043.38635.rjw@sisk.pl>
	<201110261342.51843.rjw@sisk.pl>
	<4EAA1762.1060207@jp.fujitsu.com>
	<201111062311.28913.rjw@sisk.pl>
	<4EB737A8.3000208@jp.fujitsu.com>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/m0B4Vl1TV/R9l11O/qhQcJT"; protocol="application/pgp-signature"
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 67.161.37.189 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/m0B4Vl1TV/R9l11O/qhQcJT
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 07 Nov 2011 10:43:04 +0900
Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com> wrote:

> Thank you for doing this.
> Looks good to me.
>=20
> Reviewed-by: Kenji Kaneshige <kaneshige.kenji@jp.fujitsu.com>

Applied to my -next branch, thanks.

--=20
Jesse Barnes, Intel Open Source Technology Center

--Sig_/m0B4Vl1TV/R9l11O/qhQcJT
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQIcBAEBAgAGBQJOvWARAAoJEIEoDkX4Qk9hxFMP/AnMEDRdiELZvkdcO/RG8jJy
fu+DaCY6257ElogtriS9yL/V9xDVs5DEkq3ta+fDWomtzxGGHqczuGYx21LI71KH
cp1oC+6fs79KWj9OYJdb6ko2JuyuZvt+n1zvcvhCOJZzA7P0Ylj+0ortyJLww7kn
xL0XD97SPheqHPqZfiR6Bzmn/sZpb2Zbc1sDanCsq2SsjNvdQhDKy2MdhC94NWSe
A4OFQ/e25GXZ9tJPQHcptpotDOiE8VUKSMJ2VbZd6nVVjMGlDi62M71s0GKp1UaA
hHg9+zvo62GeCFSikIpJfwiSbNdmU7o6DMlrhBCR4wxuSAEPMr5w7JBPWKEMk4ux
i4lU/d48gty+MZrY6b8NvZ8mKRUX4/xYEWBtK2IIA/szFMAXDrMpZRsYD8DjdZve
RHEX5+LTIXuUChKZdymv3RAQkAckbOzOOHl8c/H/CUZmWZdX9+9rjbMm+vQTa+ty
b9QSjk/h5yuUTPAhlH0QR2dIHtw3IHlk8M9+quHzysDCYKTjTfDkmDEDWwmG52bl
03eSuaTXiWmfZjMY44gGijz+QjC0AL7khdnRZVgCe9iOnylCp+GqhGKQn8g5KClO
i9+FYubu8yQK/T5pESJQ8YIiEMOeFoFe+K23RIXKwN7ptdQZgvVEmwCck3989X6i
Mn+pnhoI1wCLr2Hcm/n/
=CWqU
-----END PGP SIGNATURE-----

--Sig_/m0B4Vl1TV/R9l11O/qhQcJT--
