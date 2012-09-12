Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab2ILGn7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 02:43:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:49749 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757372Ab2ILGn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 02:43:56 -0400
Date: Wed, 12 Sep 2012 16:43:53 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Venu Byravarasu <vbyravarasu@nvidia.com>, Greg KH <greg@kroah.com>,
        Felipe Balbi <balbi@ti.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Will Deacon <will.deacon@arm.com>
Subject: linux-next: manual merge of the tegra tree with the  tree
Message-Id: <20120912164353.6fb8b35ff534088a79792acd@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__12_Sep_2012_16_43_53_+1000_wr_Wy+9NET0Zp+jW"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__12_Sep_2012_16_43_53_+1000_wr_Wy+9NET0Zp+jW
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/devices.c arch/arm/mach-tegra/devices.h between
commits 2db4ddfe6e23 ("ARM: pmu: remove arm_pmu_type enumeration") from
the arm-perf tree and 1ba8216f0bc0 ("usb: move phy driver from mach-tegra
to drivers/usb") from the usb tree and commit ba07ee57d4bc ("ARM: tegra:
remove dead code") from the tegra tree.

The latter removed the files, so I did that (no action is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__12_Sep_2012_16_43_53_+1000_wr_Wy+9NET0Zp+jW
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQUC8pAAoJEECxmPOUX5FElxkP/jnZRIx75PNZEQ6HmZ9OrPdq
CIntP85QBbYVO3VbpBRGpIPntPSb/vpn6xsZ7NtB3khPpkQ6LsFTl5zZJlq4AAiU
CPxi43706eB3txY1QGeFXY1UT4oHA45tdwWZj8teBZdzcApcPXBQJbe2152+KwiE
+1bUY+aEk1Geg+9rcrGdQANbecNXNHKypTuMYfFY6MQmmW0dtSjuYN4NQBwW/bpa
5Mml7+pgyYsDcjX9HzO5vvvDXdtmuPzPkTMALK4wTHa7SyJc8cupZenF3o+QZp5e
EmFOh3iS9VAwlxAP/iIY4qdyJpYOAypZ1AOMs3BvHORxv5nXWd7foI4XfsT+jqkD
tikyNId/UqFXCa6ttEO4aFmkLuYzqATOxfx+RQQNRWG5IiL/+dsm8zuOrJZR4CGL
RyMDJjq0MCtbmERWBDjErW1siLk5fqCpoH36PtsBQcOJM+QfSttTHokVcWFZ/Ah4
NtsgT4EfEv7ERsracqcpDk77upLd9Eiykx7Xa4JoLtgyDxbYwfR0k6Tj8AmSqj1L
Bwu0cG2Vn6uo7YOmJGH44WX/A5p5/Jf88Y6tymxXxtJyVZFCvZgrXbFUiUl2B8bW
bJqyoeqWV1fP4T6As4A4CQbUm/LE9Mv8+0Wx7iX9G/GLAUL7tDsIYSmECZfhZd/O
Rx5BFXspwsleKuTliTk4
=vb6Y
-----END PGP SIGNATURE-----

--Signature=_Wed__12_Sep_2012_16_43_53_+1000_wr_Wy+9NET0Zp+jW--
