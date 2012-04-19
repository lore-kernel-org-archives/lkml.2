Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab2DSD65 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 23:58:57 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42768 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753427Ab2DSD6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 23:58:55 -0400
Date: Thu, 19 Apr 2012 13:58:43 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shawn.guo@linaro.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>, Masanari Iida <standby24x7@gmail.com>
Subject: linux-next: manual merge of the trivial tree with the sound-asoc
 tree
Message-Id: <20120419135843.80ae7f770cb0b2bc426a2c62@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__19_Apr_2012_13_58_43_+1000_1X_l_BxlW3htDKcg"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__19_Apr_2012_13_58_43_+1000_1X_l_BxlW3htDKcg
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
sound/soc/imx/Kconfig between commit a23dc694828e ("ASoC: imx: merge
sound/soc/imx into sound/soc/fsl") from the sound-asoc tree and commit
59bf89640647 ("Fix "the the" in various Kconfig") from the trivial tree.

The former merged the file into sound/soc/fsl/Kconfig (where the "the
the" now needs fixing).  I have just removed sound/soc/imx/Kconfig.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__19_Apr_2012_13_58_43_+1000_1X_l_BxlW3htDKcg
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPj41zAAoJEECxmPOUX5FEYTkP/3sJaZm8deP/ne9AOpajWmHe
JHLzw69K5PllIqCR2KnJmPRuBEooTrqgBGWe4S5fAOX4xlOWpuVZk01DiFIKfp8C
tmwvLVXi7p1mVOU58KFEwiC19lOHgEMoa5SF2UkJ5RpdTZOpNVWUB1BCo3fo1spz
s6wBLa0HkRym7bH6XRGFlig+0ozA1QhiS2suHBHWioVYXg/s7pAVl7xS3x/zQS4d
IA4/ZLgyX/2EJQDGSa/T8M4ab+lc2V8gTFdnTP988R7i0WGSAHHow+2ZR/KxG0CY
nrFKx0Lb37BbyJYWfEP0X7O1fKM/Np+KQeu75VC5kSxaH9oiIQCxtc8n1XyGnhK7
oyX2ouDSchU1GgJ4Z6kAYs3dhlMa/+O84kmEp+u/bj4lPOGceCAf/pTMOcOujtE4
ZGXzM6SL0Xk2Hkls9UGyClU2Yexn0W1JoDGu024b2eFTeFWPDRxBE0kCDb2+uB2x
3UTyogKgvF6oTY7PT3flPzphjMRD+YVF01IJk/NrOaFLIHphsq5Y/G/4faNY9O5Q
Kza7+/3ZiKkec/FaRscjoIfetp5n8VDSOb/0yjF5Aza1kR0VEGNAx6K4rObl4LJl
3yagTTh5CjwqiGlF9CVugdcScxGLUD1n9g/eBFjeGAdcJQYi+qftJK2SHxZR7R8z
EuwOxjFQezJh8dxpQ7d4
=AZc9
-----END PGP SIGNATURE-----

--Signature=_Thu__19_Apr_2012_13_58_43_+1000_1X_l_BxlW3htDKcg--
