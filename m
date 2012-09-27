Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756004Ab2I0GKH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 02:10:07 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:47584 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755454Ab2I0GKF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 02:10:05 -0400
Date: Thu, 27 Sep 2012 16:09:55 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Brown <davidb@codeaurora.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Subject: linux-next: please clean up the msm tree
Message-Id: <20120927160955.2b26954a0daf42af6d3f7cd3@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__27_Sep_2012_16_09_55_+1000_Y0wStl.Ekee7FX4J"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__27_Sep_2012_16_09_55_+1000_Y0wStl.Ekee7FX4J
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi David,

Since all of the patches in the msm tree have been merged into the
arm-soc tree (but as different commits :-(), can you please clean up the
msm tree.  It is causing unneeded conflicts in linux-next.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__27_Sep_2012_16_09_55_+1000_Y0wStl.Ekee7FX4J
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQY+2zAAoJEECxmPOUX5FERvwP/iC0CsFC7FZ2hNEvrzf5s/iA
arqIZP3AUAIkMr7T9eYBR4fkvGVJ7LNs+uTXWEUo9eYRju1LCNJszKcAGlXADInf
MSoPAA2SecAyjGrlU6XZgyQWoVQZ4pkK4hVL8IczaHji+4szeN16NDGL8NN9J+Zy
VInh1gtzt7pj3Ilw1YxOzLE19rZkmRS8AZmNPF00dWrIp8MkGGHqGTb8CrQlhIR2
rmtu+sMOaBK42qNZR/rt7a/fXX/1nCuia7PCEWbUXrREwy3wy94WqwOv5p9Lf8Ol
IfEF/RVepUPeGzzxEqxoIy2jbv1kwdHIH4Tc7nWjuRxsJQta24cYD/WgBXc7Rryb
Y7XlG3fIk3XqEGgSIb4yGEPRTe0L4Zds5/fLXKAm+Cp1NfGIiIWHPE915LN/kuto
92xyNSSOjf7CFCaHtIhSGpNUjBMQp6HFrHF8eD89U+Mj1zK5mBt7xrjHSnTGfYsC
6/MBk0ZGjWmJWRz3OtTIIeu7Z0QifPdzHePUF7Ks7i02QJxup3fwx/FbpHaXV/L9
aF3NmbJWpmVDWmC+gmvqiXFlcux/kajECq1BhFbTdfftZf4GJ1chhMMh+nXq0y6c
XwEKPOtYfsxz8Kwp0ULZmdl7FTRhVlHdnPvP2Jx75d4xEc8Q4kezb74ojYy8qNNp
uVP5lOW5hfQ8hzj0ein6
=EnQF
-----END PGP SIGNATURE-----

--Signature=_Thu__27_Sep_2012_16_09_55_+1000_Y0wStl.Ekee7FX4J--
