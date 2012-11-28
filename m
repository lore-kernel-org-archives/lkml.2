Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150Ab2K1D0Q (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 22:26:16 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44075 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751308Ab2K1D0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 22:26:15 -0500
Date: Wed, 28 Nov 2012 14:26:10 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        linux-arm-kernel@lists.infradead.org, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Vinod Koul <vinod.koul@intel.com>,
        Vipul Kumar Samar <vipulkumar.samar@st.com>
Subject: Re: linux-next: manual merge of the arm-soc tree with the slave-dma
 tree
Message-Id: <20121128142610.9fdfaf75a98ef83a12c32d9b@canb.auug.org.au>
In-Reply-To: <CAKohpo=K2kX-M4NM9onrn-Rr4otJwcQ1HxN5cKPYvj+Tza_0Ug@mail.gmail.com>
References: <20121127154430.36e87542081a7cc50f80d0f6@canb.auug.org.au>
	<CAKohpo=K2kX-M4NM9onrn-Rr4otJwcQ1HxN5cKPYvj+Tza_0Ug@mail.gmail.com>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Nov_2012_14_26_10_+1100_63N0AWW5OgRqPlPO"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Nov_2012_14_26_10_+1100_63N0AWW5OgRqPlPO
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Tue, 27 Nov 2012 11:08:36 +0530 Viresh Kumar <viresh.kumar@linaro.org> w=
rote:
>
> On 27 November 2012 10:14, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> > Today's linux-next merge of the arm-soc tree got a conflict in
> > arch/arm/mach-spear13xx/spear1310.c between commit b47394911c26 ("ARM:
> > SPEAr13xx: Pass DW DMAC platform data from DT") from the slave-dma tree
> > and commit 300a6856324a ("ARM: SPEAr1310: Fix AUXDATA for compact flash
> > controller") from the arm-soc tree.
> >
> > I have no idea how to fix this up, so I just effectively dropped the
> > arm-doc tree patch.
>=20
> So sorry for that, Can you please take arm-soc version here? Patch 300a68=
56324a
> is doing the correct thing. i.e. we need
>=20
> +       OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, &cf_pda=
ta),
>=20
> instead of
>=20
> +       OF_DEV_AUXDATA("arasan,cf-spear1340", MCIF_CF_BASE, NULL, "cf"),

Done, it should be correct on today's linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__28_Nov_2012_14_26_10_+1100_63N0AWW5OgRqPlPO
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtYRSAAoJEECxmPOUX5FEZT8P/12x7/C3h4ayWzgOmpiaY6l1
iKkAfiw6t/8p1/lIO1sSLVgUqVVKiSb12l1xzMRUV1hGsN4/glS0lSf8JlIoYczj
j283JHUOn7IThcskdykYl0xlhrs1FWkTLvfPKsml2zc0yb1Fmumqkazx7WPaWNfN
Frp8xV8mbKbEa7W7xv471yKPCc2TfhlzT+TSD8WLH7KqRIg760fVsmzQfdh9yuJ5
1GSqTbBE4eTqFFAAZXJPH2u8bwobFHHWQJs8itmz2uWNUnjkjO5PFbUu+kQr578R
CkmzOVviOX/efTvkuDC8qcwZ9lKFvH17W/uZtTN+lAobgOpTy6wYvFhSTY5O2Bdu
SyxmbEPHz2ahYLd3EpA4/kOdHl8Lj2VcCegsSRcotrJlxoaVaXGgres+He7LeLCl
ak9IEaqwCuhH5y91avETO21r81OGt5bWbPlf5WY+7RDf3OFvuzu0GVwxrBy7H8Zm
Mv/m1mUxv+W+9vs9/sExjkujcr4HYtCNX3c0MMlS8PHyYfdjf/m0gh/kka13pAOt
B5p2X8vDWFbedg4pDrWkjPlUJLIl6SH9CdvUXsSORee30H+mopJpApL3hLgyM7mW
SCT0n6j5bXKCPhFPTiehzvxNOV3i3ETLtJ9V/XV1UBHhmPLSr3LgXjYXBLcvs0rR
xby4Qrp/npxXCw9MLlrH
=e7QG
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Nov_2012_14_26_10_+1100_63N0AWW5OgRqPlPO--
