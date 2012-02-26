Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2BZXkX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Feb 2012 18:40:23 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:42109 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752568Ab2BZXkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Feb 2012 18:40:21 -0500
Date: Mon, 27 Feb 2012 10:40:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stephen Warren <swarren@nvidia.com>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Peter De Schrijver <pdeschrijver@nvidia.com>,
        Russell King <rmk@arm.linux.org.uk>
Subject: linux-next: manual merge of the tegra tree with the arm tree
Message-Id: <20120227104009.37c86507539fc4f5d1239807@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__27_Feb_2012_10_40_09_+1100_G5QkBi5S+5sW7X4J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__27_Feb_2012_10_40_09_+1100_G5QkBi5S+5sW7X4J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the tegra tree got a conflict in
arch/arm/mach-tegra/common.c between commit daa14d5e60e0 ("ARM:
mach-tegra: properly disable CPU idle call") from the arm tree and commit
65fe31da5ced ("ARM: tegra: support for Tegra30 CPU powerdomains") from
the tegra tree.

Just context changes.  I fixed it up (see below) and can carry the fax as
necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc arch/arm/mach-tegra/common.c
index 2db20da,09dc37fc..0000000
--- a/arch/arm/mach-tegra/common.c
+++ b/arch/arm/mach-tegra/common.c
@@@ -27,6 -27,8 +27,7 @@@
  #include <asm/hardware/gic.h>
 =20
  #include <mach/iomap.h>
 -#include <mach/system.h>
+ #include <mach/powergate.h>
 =20
  #include "board.h"
  #include "clock.h"

--Signature=_Mon__27_Feb_2012_10_40_09_+1100_G5QkBi5S+5sW7X4J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPSsLZAAoJEECxmPOUX5FEs6kP/3YzumEGSN3/3i2m/584/SbG
Ul41QIj9WH7KnsfZ3olHCj33YHv1okC2mxjsuUhfMbh5Sw2mM8JqXJsd1e0Fifqx
fLi4JYu3oh5ZgDhdj9dJpndkbt6jmfssqWyevEYX6Sqi5QVNMTEqIdmPeJK6+ORA
A68rAoJ4zOjGVDqDdGxgVwZvLZYQI1jOSo52n1Fsu2xxlPv2UvLNaRjk4BgO/z/+
YQPjrzKfd8CIDMfAJet8YN41Tkx4dV4lXu5GZxnw4H3NIZEc8uKKSxy3UaxQpjEO
aSnrR2Z6iXW+GJlVYWOeYoUsuQUNlLPUOSSTWpXN5jdcnmyiw2an0dfCmbcCY7D4
+M5RuS6RkaSZzhn9zPL0lEQfE1kh/PxrrJYx5PFpm32fgnGDNw7y697OAe2MKS75
L3O9f/eHLBNfCDU2lb4LuTrOdqoS6xoGSmgkIyUP69RvHnoXh9Swfe9gc6pMZOUM
qrYXG705dbq9ckjKPWRrSaD6W5U48gvfOZScYXDNCF0m+/T/ONNmDdC/MfS9EZnj
HVCFhim8MYvOiAuOH5ulhzLh3mbnZnT/nryR0h9/YXLrff8k8N50V1Uet1ltMNeo
Cvq5/7Kbb89yKRsU/DOxiiobELLBhsB/jQmHpi5BIp5ViqYr6oMVulrCpV1e91wP
ObICrHG+YWg1BIPIiWDq
=UEyZ
-----END PGP SIGNATURE-----

--Signature=_Mon__27_Feb_2012_10_40_09_+1100_G5QkBi5S+5sW7X4J--
