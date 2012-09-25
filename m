Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752985Ab2IYGkZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 02:40:25 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59086 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab2IYGkX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 02:40:23 -0400
Date: Tue, 25 Sep 2012 16:40:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Olof Johansson <olof@lixom.net>, Arnd Bergmann <arnd@arndb.de>,
        <linux-arm-kernel@lists.infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Stephen Boyd <sboyd@codeaurora.org>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        linux-fbdev@vger.kernel.org
Subject: linux-next: manual merge of the arm-soc tree with the fbdev tree
Message-Id: <20120925164020.8c83339ae70d5eed5fc4b05c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__25_Sep_2012_16_40_20_+1000_TAAx0Ds7zh/TpTr/"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__25_Sep_2012_16_40_20_+1000_TAAx0Ds7zh/TpTr/
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

Today's linux-next merge of the arm-soc tree got a conflict in
drivers/video/msm/mdp_hw.h between commit 8abf0b31e161 ("video: msm:
Remove useless mach/* includes") from the fbdev tree and commit
1ef21f6343ff ("ARM: msm: move platform_data definitions") from the
arm-soc tree.

I fixed it up (see below) and can carry the fix as necessary (no action
is required).

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/video/msm/mdp_hw.h
index 2a84137,a0bacf5..0000000
--- a/drivers/video/msm/mdp_hw.h
+++ b/drivers/video/msm/mdp_hw.h
@@@ -15,7 -15,8 +15,7 @@@
  #ifndef _MDP_HW_H_
  #define _MDP_HW_H_
 =20
- #include <mach/msm_fb.h>
 -#include <mach/msm_iomap.h>
+ #include <linux/platform_data/video-msm_fb.h>
 =20
  struct mdp_info {
  	struct mdp_device mdp_dev;

--Signature=_Tue__25_Sep_2012_16_40_20_+1000_TAAx0Ds7zh/TpTr/
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQYVHUAAoJEECxmPOUX5FEGfEQAI6yEp4Hsc8ABR+YG92XH5aQ
I7/MrR+NJ0nevrNwTcW1nq9l1Y5TJvlDmcrIpPhkTVMz8LlUt2nr2SOzUxpWIO06
dKf/0bHOkkoYxSPKielu8AcexSJDoOzx7/ChgUOp5MNS2D45osy9jC0luCDBYhQo
8xkCTREecPbNKJtAfpfGNwKrPVWf/6vXeEQC+BnrNfzO4q7GWe1+UVScz0Nqawmg
sHvqwA/jjZ6d03BxA7WXq67kVilrjMSjoMsP4hdnAENSxkgNtIDQIfl15xtNRMnf
G3bI2e0sgRH5bjyBq4yxqs8lFaAAmw9vvfdtom6TodZRK43MnvsNCtJyupIHWY4r
83xsobLHUkFZA7qJ2Cu7+iVOYMit6eclFmerAbPq9UfSeOeDYDrE572a8EoEfTxE
+rUWh8EVasU6UgtmCgqYPFyGizK22gxr2d9aCMbX1gqQbkGLRNxaxAMLQv1sPx7j
p/zzjeAWxSgu1j1EEed7pVGQFqKkYZH2K0rvawIlv0FAfhklPtdiVI1Hb++2zF4b
XAyRSOTNeZz4iYEKL+OkaSlYkFQxbQO5HbpBOo5Yqc+bzQMsasJfu0kimChzGuAD
Mgrhawa5B+lJtlT2xuD0+xPVjO0EnfGEBO1w9k570jervA7QCtyy5p3IJXMMRbAZ
VhmDXY1SDX3Oj7+GHjVr
=vJ68
-----END PGP SIGNATURE-----

--Signature=_Tue__25_Sep_2012_16_40_20_+1000_TAAx0Ds7zh/TpTr/--
