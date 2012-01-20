Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751697Ab2ATHLv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Jan 2012 02:11:51 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:59453 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750966Ab2ATHLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Jan 2012 02:11:47 -0500
Date: Fri, 20 Jan 2012 18:11:31 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Christian Gmeiner <christian.gmeiner@gmail.com>,
        "Lars-Peter Clausen" <lars@metafoo.de>,
        Richard Purdie <rpurdie@rpsys.net>
Subject: linux-next: build failure after merge of the final tree
Message-Id: <20120120181131.8fc4b0b29893b614e7f1fd6e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__20_Jan_2012_18_11_31_+1100_j62r0FxEU_LM_kfr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__20_Jan_2012_18_11_31_+1100_j62r0FxEU_LM_kfr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (s390 allmodconfig)
failed like this:

drivers/leds/leds-ot200.c: In function 'ot200_led_brightness_set':
drivers/leds/leds-ot200.c:114: error: implicit declaration of function 'out=
b'

Caused by commit 891b7aeff9fe ("leds: add led driver for Bachmann's ot200").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au


--Signature=_Fri__20_Jan_2012_18_11_31_+1100_j62r0FxEU_LM_kfr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPGROjAAoJEECxmPOUX5FEqssP/Ak2of/TpTUF0ktf8zcw3fPf
lGuAF3fY/tA3x7CRGn1B7YKCqA+sJbcAGEkfyTKfSiUCjCrxXeLe7+0HtztHQPCi
CkgLPUTgj9NmDSo6gA5rYvMmEO6YZtEsugCI/pCvIkqFgC4Du4w2anKLYEPTO0a9
SybMcnOFk46A3/fltElh6205mGLil6DikjgWPhUUyjgLHc4x//Dqj/OLDXfDCg3s
CosmLaIcS299zkyV9Jii04FiLq/7DUDL/nsUDi6w4ZfyLcElFLUDoV+crlR5aQ04
gbvTRZhKhqNjDqqLfM4E1LnN78e+RyMPr8reyqTMXC5N8k2cVfpXtao34bEBKPWO
DVXCe/JnRR307Sh1cfZXYCXBMOrVMiuqUW3OU0pA00aqYPWvVycfhLoy6c8NVyot
W0/mi/U2OAucqcz3hzVTVkZaBTIYCRSGO7/DRWJDIytZMf7gCxsjjPRZacuiQzAl
YUYR4Ks4qwq7qWdmcwGqTYL5pteHM4bhwik9YIi60fd3TLF+92cxEFokm3R40zMV
xkZ/0HGTmLZF6sCQgnUT14QrmBgVNpEdkUKJW/Frtwar9MqoqtNGZ36Antjm6RuO
60LNJWlX7qkhL8+GGTwg80X1MZT2ZJ9N8hatr6cPHT+opbuZ5v0ODMqTZPGrv7hc
MYT2CBMcrdd8p9nHvQ45
=fALI
-----END PGP SIGNATURE-----

--Signature=_Fri__20_Jan_2012_18_11_31_+1100_j62r0FxEU_LM_kfr--
