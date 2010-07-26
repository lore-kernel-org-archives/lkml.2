Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754522Ab0GZLUc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 07:20:32 -0400
Received: from ozlabs.org ([203.10.76.45]:46397 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754491Ab0GZLU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 07:20:29 -0400
Subject: Re: [PATCH] PCI: MSI: Restore read_msi_msg_desc(); add
 get_cached_msi_msg_desc()
From: Michael Ellerman <michael@ellerman.id.au>
Reply-To: michael@ellerman.id.au
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>
In-Reply-To: <1279893388.2089.9.camel@achroite.uk.solarflarecom.com>
References: <20100723102202.871a3131.sfr@canb.auug.org.au>
	 <1279847985.4883.391.camel@localhost>  <1279850740.6381.19.camel@concordia>
	 <1279893388.2089.9.camel@achroite.uk.solarflarecom.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature"; boundary="=-VcV+sHjbjlRrKfOs1AzT"
Date: Mon, 26 Jul 2010 21:20:27 +1000
Message-ID: <1280143227.7337.0.camel@concordia>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-VcV+sHjbjlRrKfOs1AzT
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2010-07-23 at 14:56 +0100, Ben Hutchings wrote:
> commit 2ca1af9aa3285c6a5f103ed31ad09f7399fc65d7 "PCI: MSI: Remove
> unsafe and unnecessary hardware access" changed read_msi_msg_desc() to
> return the last MSI message written instead of reading it from the
> device, since it may be called while the device is in a reduced
> power state.
>=20
> However, the pSeries platform code really does need to read messages
> from the device, since they are initially written by firmware.
> Therefore:
> - Restore the previous behaviour of read_msi_msg_desc()
> - Add new functions get_cached_msi_msg{,_desc}() which return the
>   last MSI message written
> - Use the new functions where appropriate
>=20
> Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>

Looks good to me.

cheers


--=-VcV+sHjbjlRrKfOs1AzT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAkxNb3gACgkQdSjSd0sB4dJ6PQCfXdGGM61GX12Yldd3DHo2286j
40gAnjwA/7odh+QQK5AXbiA/ncIey8Or
=+yMh
-----END PGP SIGNATURE-----

--=-VcV+sHjbjlRrKfOs1AzT--

