Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753941Ab2DWMIA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 08:08:00 -0400
Received: from na3sys009aog120.obsmtp.com ([74.125.149.140]:50068 "EHLO
	na3sys009aog120.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753040Ab2DWMH7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 08:07:59 -0400
Date: Mon, 23 Apr 2012 15:06:46 +0300
From: Felipe Balbi <balbi@ti.com>
To: Hiroshi DOYU <hdoyu@nvidia.com>
Cc: linux-tegra@vger.kernel.org, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] ARM: tegra: Add AHB driver
Message-ID: <20120423120645.GY26302@arwen.pp.htv.fi>
Reply-To: balbi@ti.com
References: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="1RfOVxRbNnn9f8MI"
Content-Disposition: inline
In-Reply-To: <1335181043-15348-1-git-send-email-hdoyu@nvidia.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--1RfOVxRbNnn9f8MI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Apr 23, 2012 at 02:37:21PM +0300, Hiroshi DOYU wrote:
> +static inline unsigned long gizmo_readl(unsigned long offset)
> +{
> +	return readl(IO_TO_VIRT(TEGRA_AHB_GIZMO_BASE + offset));
> +}
> +
> +static inline void gizmo_writel(unsigned long value, unsigned long offse=
t)
> +{
> +	writel(value, IO_TO_VIRT(TEGRA_AHB_GIZMO_BASE + offset));
> +}

why don't you ioremap() your address and use it as a void __iomem * ?

--=20
balbi

--1RfOVxRbNnn9f8MI
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBAgAGBQJPlUXVAAoJEIaOsuA1yqREsJQP/RPUP2NsTxL39fKtxe1pocAp
yzyuR/JS2ZrKze6I3K+W7gPPqdgIu6NHedKG/DEaBHOcs8v7k6vguTkoull2K3m1
uRthfO3Pu0xq213imgvPCNXnejDoymseWL+j7hGEsVi3LroL6/xGBUk0FS77anks
k+etiU/Ch9RLBwauEjwja87ICPiSl1lHptPGx5MQ/5s0U4J6euEhADf5WCOORJrR
Q8xEc9//KoSbx7AY9hN724IBS/yf7QXpCZHvf/FK/HB4mQoAlT0d7wRdAIkr0lCf
4bBBYZcKO/sUQO0OmKa8PzBq1OzwPKg0nhcBVCPsV0vF85LUN0UWHxxP3Ny9HlMC
wP4DtB1nnK+PMs9rgeCHvjSQXfQb032Rx13gp2kSbVmxcVeOLUomX87WaXd/ysQ4
3J/wfKRbUT422ftxvtGtBr/6F2aXJ8omUpA8XWHk0MA0ozki8HhlONbmHFPbD32K
znGnk0rCcWmoaZ5ljaq+1Lnkf7/HAQi8vhoVFTyYpcMV8K0WAFM0cY8T3Dn6HdxE
CRtssLP/hJpUBfFEfNyeBWzdKyQz2d7Ss8uUsABVtWZkWGu6Hc9e89JzlvWj0KNs
0UDBczNvCcLDLm71KCown3F3q3qNDZ6pWsBmIrqMP5Jt/JubjErJq0MPAZZCHdHF
/NbYO23CivMqStvwDC0a
=GtWW
-----END PGP SIGNATURE-----

--1RfOVxRbNnn9f8MI--
