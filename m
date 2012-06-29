Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751845Ab2F2GyG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 02:54:06 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:54068 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751258Ab2F2GyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 02:54:04 -0400
Date: Fri, 29 Jun 2012 16:54:00 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Laxman Dewangan <ldewangan@nvidia.com>,
        Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Subject: linux-next: manual merge of the pwm tree with the tegra tree
Message-Id: <20120629165400.8eec105c4495ebcdbf31944e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__29_Jun_2012_16_54_00_+1000_4+yXOhCaW4=leqEg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Jun_2012_16_54_00_+1000_4+yXOhCaW4=leqEg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Thierry,

Today's linux-next merge of the pwm tree got conflicts in
arch/arm/mach-tegra/board-dt-tegra20.c and
arch/arm/mach-tegra/board-dt-tegra30.c between commit bd976e0307fb ("ARM:
tegra: add device tree AUXDATA for APBDMA") from the tegra tree and
commit 3ad1308c8dee ("pwm: tegra: Add device tree support") from the pwm
tree.

Just context changes.  I fixed them up (see below) and can carry the fix
as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/board-dt-tegra20.c
index 1b43c33,962f1a1..0000000
--- a/arch/arm/mach-tegra/board-dt-tegra20.c
+++ b/arch/arm/mach-tegra/board-dt-tegra20.c
@@@ -64,7 -64,7 +64,8 @@@ struct of_dev_auxdata tegra20_auxdata_l
  		       &tegra_ehci2_pdata),
  	OF_DEV_AUXDATA("nvidia,tegra20-ehci", TEGRA_USB3_BASE, "tegra-ehci.2",
  		       &tegra_ehci3_pdata),
 +	OF_DEV_AUXDATA("nvidia,tegra20-apbdma", 0x6000a000, "tegra-apbdma", NULL=
),
+ 	OF_DEV_AUXDATA("nvidia,tegra20-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
  	{}
  };
 =20
diff --cc arch/arm/mach-tegra/board-dt-tegra30.c
index 4a40986,ffc6cae..0000000
--- a/arch/arm/mach-tegra/board-dt-tegra30.c
+++ b/arch/arm/mach-tegra/board-dt-tegra30.c
@@@ -52,7 -54,7 +54,8 @@@ struct of_dev_auxdata tegra30_auxdata_l
  	OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000C700, "tegra-i2c.3", NULL),
  	OF_DEV_AUXDATA("nvidia,tegra20-i2c", 0x7000D000, "tegra-i2c.4", NULL),
  	OF_DEV_AUXDATA("nvidia,tegra30-ahub", 0x70080000, "tegra30-ahub", NULL),
 +	OF_DEV_AUXDATA("nvidia,tegra30-apbdma", 0x6000a000, "tegra-apbdma", NULL=
),
+ 	OF_DEV_AUXDATA("nvidia,tegra30-pwm", TEGRA_PWFM_BASE, "tegra-pwm", NULL),
  	{}
  };
 =20

--Signature=_Fri__29_Jun_2012_16_54_00_+1000_4+yXOhCaW4=leqEg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP7VEIAAoJEECxmPOUX5FEcFgP/1sdKVafjsHmQBRKtDeC0awz
xGYD4d4oiMd5Fa0+mn7iNpOKvCWzN+Jq0HygrHH6zkQeIDEQQ9yoccnp1AG+rQM6
6IrR1x2sGg3yjvc+iDV08AqLElvauCRGDMOH74umhqC26km9o+SFKmyjBez1SMiT
cb+Aj+bw2OERBM9p2xqeNR0oZM/xfIz6KBrPn6TPlUgFRXEXOb/fcceH0/K2L9lq
hH25zVc/o7Y1W/LTMWUrX8GY2kBK1Y2TrWxNC0PqUQrn6QCEUQneLhj+Oi5PcMmP
I4cIbBNu17n0kaecmesZqI6Zd08hFGZq3DBC+pkQBA8okcUNMR8o5B8MA9zL09Pp
a7YxjEMchqWbRuh7vM0f0qrONujOX6gKUQz74/RME3bJTzJz4kgyYEzE1oN3OTHy
7a/pI9z6gvo+ylDkZK+3D9PpSjwBOQOKWJIe+oUEo0dtnShwQpWHo9YbAIqq1k1k
pIz5MqZWc3ZFqkCTPS5gwBVKVbPisN9cNSJT+Z7U8osj4CqrolUiTwZzsxb0ncpM
Vc5FGuTm9B2cyUj+MkWnQN7djzDFfXuUH9N5sqq8TZz20OZx90S9BvWG25cwnKoo
uhGZW7aNVRwUmW34piwkLnGogrthE/c3CcxLlgCXoyMMGL0lVWoP50DiTQTK2ZQ2
r5ATD9WU37ZnMgy5O5dh
=h0Ct
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Jun_2012_16_54_00_+1000_4+yXOhCaW4=leqEg--
