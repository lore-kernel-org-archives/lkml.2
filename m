Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932821Ab1ERKxZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 06:53:25 -0400
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:56785 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932168Ab1ERKxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 06:53:23 -0400
Date: Wed, 18 May 2011 13:53:15 +0300
From: Felipe Balbi <balbi@ti.com>
To: Keshava Munegowda <keshava_mgowda@ti.com>
Cc: linux-usb@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-kernel@vger.kernel.org, balbi@ti.com, gadiyar@ti.com,
        sameo@linux.intel.com, parthab@india.ti.com
Subject: Re: [PATCH v1] omap: usbhs: Fixed the crash during rmmod of ehci and
 ohci
Message-ID: <20110518105312.GG13908@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1305536098-19871-1-git-send-email-keshava_mgowda@ti.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="bFsKbPszpzYNtEU6"
Content-Disposition: inline
In-Reply-To: <1305536098-19871-1-git-send-email-keshava_mgowda@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--bFsKbPszpzYNtEU6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, May 16, 2011 at 02:24:58PM +0530, Keshava Munegowda wrote:
> From: Keshava Munegowda <Keshava_mgowda@ti.com>
>=20
> The disabling of clocks and freeing GPIO are changed
> to fix the occurrence of the crash of rmmod of ehci and ohci
> drivers. The GPIOs should be freed after the spin locks are
> unlocked.
>=20
> Signed-off-by: Keshava Munegowda <keshava_mgowda@ti.com>

Acked-by: Felipe Balbi <balbi@ti.com>

should this have:

Cc: stable@kernel.org ??

--=20
balbi

--bFsKbPszpzYNtEU6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN06UYAAoJEAv8Txj19kN1qlgIAJIm9ndwooLBwB83xBBgqhsX
RsSX+B65lolhwi+6wK4ESu64uVpthBy+CmnPEKJhHPYgPcGcnGSh6YKt8liTI/iU
2OSpCv4wCNY/or3bWNb6mby7R/r2tWWVzKTeB3dpGoQmqCJc66R5YSti3qnGBoPf
pSz1HzL1G4d+Q+ipNOd7zVpql+5i+ICavAluk9M7AS16hqp4Y79OA+6ZvJHcHpsh
kjghLlrcLGAPAgIALUTlGuljKKTQETlJYhWAjPPZaM3WluPQJ6yQbMywOqUBOBH2
O895LERI8nFz9bThYPKc4QCYM3yZTXgVqqtzRPmbEUTr6+g2m+Mddkop80bAR/U=
=UkQr
-----END PGP SIGNATURE-----

--bFsKbPszpzYNtEU6--
