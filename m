Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752834Ab2CGGiq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 01:38:46 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:65314 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750958Ab2CGGio (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 01:38:44 -0500
Date: Wed, 7 Mar 2012 07:38:29 +0100
From: Thierry Reding <thierry.reding@avionic-design.de>
To: Dmitry Artamonow <mad_soft@inbox.ru>
Cc: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Stephen Warren <swarren@nvidia.com>,
        Mike Rapoport <mike@compulab.co.il>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH/RFC 2/2] arm/tegra: add timeout to PCIe PLL lock
 detection loop
Message-ID: <20120307063829.GA16359@avionic-0098.mockup.avionic-design.de>
References: <1331023544-6439-1-git-send-email-mad_soft@inbox.ru>
 <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ZGiS0Q5IWpPtfppv"
Content-Disposition: inline
In-Reply-To: <1331023544-6439-3-git-send-email-mad_soft@inbox.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Provags-ID: V02:K0:jizolPp+hW8VJLexorDSXdmWv68kiFwtgWfIYXNaol0
 gXNZAlMZKEJ8VrQ8/jtuRNYSe2n1CQUNn59LGMDXDsYVrstl3h
 mbAgLmq758eVwmSlzggm5BU9HLd18Q/PCZ57jMjEAhoV7TXvsm
 4Uu/aVZgEQjjpBSLmxqVCpGnw5kgsfU97/zK2EHaOgZguwZkIl
 tkH13flvmLuSIhZs0GU+mby+uDaWBDTbeIfGJtFCjN70O6VGe+
 nuOMPpPvDjxIJd93iMUG7bJ07b/0Yn8aKksDe85AHXNKTOA0ar
 DdNJJ21T7YCy0MQknzSs3fNhUk3WGpQWbzM3rPAPRIp5nuCgtw
 GzX2fp59ps2/aaBF1XZ8wppSh4IkxQrbmmmtNmtQ8LW8tfWYKo
 A7RYgbLKJmoacLcHgNMwLS5MdMDdQwKuwGD6WA/sGhLoTrtbF0
 TOtIQ
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--ZGiS0Q5IWpPtfppv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

* Dmitry Artamonow wrote:
[...]
> diff --git a/arch/arm/mach-tegra/pcie.c b/arch/arm/mach-tegra/pcie.c
[...]
> @@ -639,8 +639,14 @@ static void tegra_pcie_enable_controller(void)
>  	pads_writel(0xfa5cfa5c, 0xc8);
> =20
>  	/* Wait for the PLL to lock */
> +	timeout =3D 2000;

FWIW, the Vibrante kernel uses 300 for the timeout value.

Thierry

--ZGiS0Q5IWpPtfppv
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAk9XAmUACgkQZ+BJyKLjJp/h9ACfW2R7xi0f+fb2NTSlgOKIYWG7
5kgAoJ0ePwn0g2bF7wd4Emgucpaz4MgL
=PFZd
-----END PGP SIGNATURE-----

--ZGiS0Q5IWpPtfppv--
