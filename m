Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752319Ab1HOGoQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 02:44:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40342 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306Ab1HOGoP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 02:44:15 -0400
Date: Mon, 15 Aug 2011 16:44:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Chris Ball <cjb@laptop.org>, linux-mmc@vger.kernel.org,
        linux-kernel@vger.kernel.org, patches@linaro.org
Subject: Re: [PATCH] mmc: sdhci-esdhc-imx: add missing inclusion of
 linux/module.h
Message-Id: <20110815164407.9dee291afbc627e0dafe6b6c@canb.auug.org.au>
In-Reply-To: <CAAQ0ZWSqRiaPRF0ofyQL75QyYJov1VVnQjgs2LWAgSgp804NpQ@mail.gmail.com>
References: <1313375298-18546-1-git-send-email-shawn.guo@linaro.org>
	<m2mxfbmirn.fsf@bob.laptop.org>
	<CAAQ0ZWRX_POwMZY9m9ath=oC0OS538+wRcfj-vay5VSkSRkzEg@mail.gmail.com>
	<20110815154607.8c34ffd02558b4d86e17e396@canb.auug.org.au>
	<CAAQ0ZWSqRiaPRF0ofyQL75QyYJov1VVnQjgs2LWAgSgp804NpQ@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__15_Aug_2011_16_44_07_+1000_eExonE/6_y0zE02_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Aug_2011_16_44_07_+1000_eExonE/6_y0zE02_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Shawn,

On Mon, 15 Aug 2011 14:05:49 +0800 Shawn Guo <shawn.guo@linaro.org> wrote:
>
> My .config is attached.  It's used to build i.mx53 image.

Thanks.

> Before you start building it, you need to cherry-pick the following
> commit from Linus' tree to fix another error.
>=20
> commit d9c927833a42b4eaae4addd031f780f4530f7a2d
> Author: Arnaud Patard (Rtp) <arnaud.patard@rtp-net.org>
> Date:   Fri Aug 5 09:32:41 2011 +0200
>=20
>     iMX: Fix build for iMX53

That is included in today's linux-next.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__15_Aug_2011_16_44_07_+1000_eExonE/6_y0zE02_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOSMA3AAoJEDMEi1NhKgbs/iEH+we5TjWoPRZa71iqNahB06Dx
oxPh+xJXlalkcRPHUVOuikBoHKZUb+p17Gp/ObnKUoY6bPUdJTNJRQkZJBJqhi6p
w028pedyl/u3FaZE489glXm7oeZ2GwPffZzVD3Q7QOlvP6e4sKgD/0h9ALeTAeDV
d8G8m4YMPtUWr3GJiVzo9SZ/w9Pkfqy4qhdasghOKht9dM3WGV2oqEYjABSUK3Cq
1WOPMywfj1NBarGOLwImC+CsiIaBp5Py3fBiUmtiWI82aiVwCVCM7YkTDRDow78f
2m9ytAsw7zNDSVgtNvPdmSH1h/MVnL3fBq1efJZBvkMaOte+E+8CMkVA2lpGR0k=
=ruSJ
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Aug_2011_16_44_07_+1000_eExonE/6_y0zE02_--
