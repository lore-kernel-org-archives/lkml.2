Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754454Ab2HYMdq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Aug 2012 08:33:46 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34237 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab2HYMdj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Aug 2012 08:33:39 -0400
Message-ID: <1345898007.1815.7.camel@kyv>
Subject: Re: [PATCH RESEND] mtd: lpc32xx_mlc: Make driver independent of
 AMBA DMA engine driver
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Roland Stigge <stigge@antcom.de>
Cc: linux@arm.linux.org.uk, artem.bityutskiy@linux.intel.com,
        linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linux-kernel@vger.kernel.org, kevin.wells@nxp.com,
        srinivas.bakki@nxp.com, aletes.xgr@gmail.com, dwmw2@infradead.org,
        linux-mtd@lists.infradead.org
Date: Sat, 25 Aug 2012 15:33:27 +0300
In-Reply-To: <1345674311-16874-1-git-send-email-stigge@antcom.de>
References: <1345674311-16874-1-git-send-email-stigge@antcom.de>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-YtalSsIduH1DYI8aqfD+"
X-Mailer: Evolution 3.4.3 (3.4.3-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-YtalSsIduH1DYI8aqfD+
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2012-08-23 at 00:25 +0200, Roland Stigge wrote:
> This patch makes the MLC NAND driver independent of the single AMBA DMA e=
ngine
> driver by using the platform data provided dma_filter callback.
>=20
> (This also fixes the build error of the MLC NAND driver in case of module
> linking because the (not exported) reference to pl08x_filter_id is gone n=
ow.)
>=20
> Signed-off-by: Roland Stigge <stigge@antcom.de>

I already have both patches in l2-mtd.git. Please, use it as the
baseline for sending patches.

--=20
Best Regards,
Artem Bityutskiy

--=-YtalSsIduH1DYI8aqfD+
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABAgAGBQJQOMYXAAoJECmIfjd9wqK0tJ4QAJzM2TfKrH/UpkUl68kBJhHX
ik82K60COESYZGlVKWGd9Bs9NK7kvU3sjGS87JDhqOtvvM6+wWYOAtHOgQlLkhjh
85ynlApubyCn+NrvDt1CwDin94elv62yvVW0uTMTmDwN6VMlo81uaXGsrvnTof5F
XiUe4M6MYr5GFQNDe2f4+VVat9Bz+Ox21hKKZPGfFXc/bqdi3M7t6wnDe1vovAsK
i/vBzl608kikXMMJyNAlMS0GH7zxaGrjnqeFCLbFxkgDGr8lRu28qX+8QIExzHvD
BpbesYtH2Sf6Z/ppzpjX2eM0dconzQSsDBJkDgPu3TJQW1Jft9uoDXOzBhe2Um92
pUEuubWspZ3cbJw6sMnsJuOBp06nrW4S9rNs1IqoQw03o8vKjGX3CusCcDFI5N6s
AAc9YXKP9Kt3lJIuWgF6/7O4Ag3+7yPF7owyvS4B2s2e2WpRbKYNiFaNOMDHMbDr
TbzWXDTHKNUlQ8EYPI2v09NJEIn80YoJ5yF4OWIEGYNrs+Xn0Cn8JOEy8QrjPieP
rCJ20SRAuly32kQt3KdhJf0EfiWDdgc6DLX11z8aswhQCYzS6dl/lzhGtDsT573i
7WX9M9Zgt74YGmIcqOY8IvfM/9PhWYJKRMJnA1vpeVs6b+OVAA+GzzoCu0ZU+58x
SpmkL7yBaiwiiB74kQlA
=4ueD
-----END PGP SIGNATURE-----

--=-YtalSsIduH1DYI8aqfD+--

