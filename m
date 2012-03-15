Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754698Ab2COC4U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 22:56:20 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:42733 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752950Ab2COC4S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 22:56:18 -0400
Date: Thu, 15 Mar 2012 13:56:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Anton Vorontsov <avorontsov@ru.mvista.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Arun Murthy <arun.murthy@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: linux-next: build failure after merge of the battery tree
Message-Id: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__15_Mar_2012_13_56_09_+1100_0Gq5sP4k=yosvrZ2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Mar_2012_13_56_09_+1100_0Gq5sP4k=yosvrZ2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Anton,

After merging the battery tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_batctrl_volt_to_res=
':
drivers/power/ab8500_btemp.c:142:2: error: implicit declaration of function=
 'is_ab8500_1p1_or_earlier' [-Werror=3Dimplicit-function-declaration]
drivers/power/ab8500_btemp.c: In function 'ab8500_btemp_templow_handler':
drivers/power/ab8500_btemp.c:619:2: error: implicit declaration of function=
 'is_ab8500_2p0_or_earlier' [-Werror=3Dimplicit-function-declaration]
drivers/power/ab8500_charger.c: In function 'ab8500_charger_ac_en':
drivers/power/ab8500_charger.c:1126:3: error: implicit declaration of funct=
ion 'is_ab8500_1p1_or_earlier' [-Werror=3Dimplicit-function-declaration]
drivers/power/ab8500_charger.c: In function 'ab8500_charger_remove':
drivers/power/ab8500_charger.c:2519:2: error: implicit declaration of funct=
ion 'usb_unregister_notifier' [-Werror=3Dimplicit-function-declaration]
drivers/power/ab8500_charger.c:2520:2: error: implicit declaration of funct=
ion 'usb_put_transceiver' [-Werror=3Dimplicit-function-declaration]
drivers/power/ab8500_charger.c: In function 'ab8500_charger_probe':
drivers/power/ab8500_charger.c:2688:2: error: implicit declaration of funct=
ion 'usb_get_transceiver' [-Werror=3Dimplicit-function-declaration]
drivers/power/ab8500_charger.c:2688:14: warning: assignment makes pointer f=
rom integer without a cast [enabled by default]
drivers/power/ab8500_charger.c:2695:2: error: implicit declaration of funct=
ion 'usb_register_notifier' [-Werror=3Dimplicit-function-declaration]

Caused by commits 89449ac8d6d2 ("ab8500-charger: AB8500 charger driver")
and 20ac1aed6206 ("ab8500-btemp: AB8500 battery temperature driver").

I have used the battery tree form next-20120314 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__15_Mar_2012_13_56_09_+1100_0Gq5sP4k=yosvrZ2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYVpJAAoJEECxmPOUX5FEe+MP/iBpwTxh/rjNmZTfHGrEEUjp
aBwPDKLGeyaNhMigVCiIaj2C9QIMR0eidNbTN0A2hoNpGm/xwM6IKJdy5Z4wFOwy
AXmTAH8iLXpM1H2Vy0MWefPyybXYfE1xb/Z/+zRc2k1t1uvhyb0bghkZ754NuiqD
ect1XL0QDBWUjYLFeUwawm3hwRBXL/sxpqws4G3UPUZ498W9bmrDQ5KbueGoDglw
/aZ8nAELGHXZpdyNRwjE78tkRpqRLobZP3QKZ3QSwOb+ON00TduYdHY/ub5l+VIG
Xii8KUOPinFTxlcK3seLL86ct3f04j4O1+b1x2C0SqMeKAJCMYjq+pF5DqH3eytU
mTWWfZiYWokjZyWOeqS31VU6nuQb/4y0wHinMIBspXP6FKf+IFCmGmOcuAluWNek
Kc6wwAvvpSRfQlDyAKpQsBZzxX0eaXqwWh8tfwOJ5BmQztgjE5ixvNydd9TXPWxh
hZBv3DofYFQP+9SLMudc45GHvdrxiM1rmmt1H+xw7nc3eRJ/AFmDy2flkRmE6nCc
Gkg4Snk/v98DuT1UV+q9BtztgXB83KSE5Pg324pABGMmDpmqpJvIvpuYcFaextvj
WITp5GbZpcOcik5n+1AlgjF7XS40lGW/VpoT2LFCU/HPFwv8J74Swbc5XsPnL/xG
SIuDEVfVBm5ghq7V7XpV
=HwYk
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Mar_2012_13_56_09_+1100_0Gq5sP4k=yosvrZ2--
