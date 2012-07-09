Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752266Ab2GID5b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 8 Jul 2012 23:57:31 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:53652 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752053Ab2GID53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 8 Jul 2012 23:57:29 -0400
Date: Mon, 9 Jul 2012 13:57:19 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: linux-next: build failure after merge of the mfd tree
Message-Id: <20120709135719.5c8b0f033520f5981efb2c93@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__9_Jul_2012_13_57_19_+1000_X9NBL4ABTclT0+6h"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_Jul_2012_13_57_19_+1000_X9NBL4ABTclT0+6h
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "arizona_dai_ops" [sound/soc/codecs/snd-soc-wm5102.ko] undefined!
ERROR: "wm5102_aod" [drivers/mfd/arizona-irq.ko] undefined!
ERROR: "wm5102_irq" [drivers/mfd/arizona-irq.ko] undefined!
ERROR: "irq_set_chip_and_handler_name" [drivers/mfd/arizona-irq.ko] undefin=
ed!
ERROR: "wm5102_patch" [drivers/mfd/arizona-core.ko] undefined!
ERROR: "arizona_irq_init" [drivers/mfd/arizona-core.ko] undefined!
ERROR: "arizona_irq_exit" [drivers/mfd/arizona-core.ko] undefined!

I have used the mfd tree from next-20120706 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__9_Jul_2012_13_57_19_+1000_X9NBL4ABTclT0+6h
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP+lafAAoJEECxmPOUX5FEX10P/2k02AhVnmjuy9oLGB8lZuTu
2Me0EHXRlKb0CICjXgP2OIrfuSlj4ucbR3pOKAcnCWxIEi4mwiV6yajRn8DULZbd
4e9NzF+rP1exFpTr/5j7IjpG5/ugCt0bs0xuIz71ix6z7WlInkC5PymaXbwpYhdf
houq1HVRcEeHy1IwgBRq0KuJNzpISz0TClkr3/Espm8FO0hEiZ09EmW9MmqHiYX+
5vVDmu1oYVPG0mkP18UlXsx240X4Gcbe1+7PAX+K6O6LaE/PStBiJRswPcoM7t7a
M8alM6GoOUNPwe0DgFie4xb+hqybaPv62tIaf2gXJ01+GhhbhhQgZpeXhZUst9he
ltMoVRXVb3Y6a4J68TRBHscmXg5R8jpXiHvdec38jkBl4YY97m1ra0KEby8NLepL
3PBIshfuEy6ZviWPPqu449hgh0lL/z4EB82nX+8TmwS6hNFFLtyW84oOgY8K8tfG
oPHpYibdEL/2FxMWGIsO3j6M9PUKrvrT9VEpZ7EAg9MI+HBY/49ZgfvhBQFRgBUc
TMaaeqVS72eog2xftaOAi4KxrJQir3unMkeUIVBkGiCHQuaU3fmewqWHxJtcyjdV
h5M9a4pNr6RBq3BprgJ+thGzx/QiHMAdvUZw4HiixyqoBUL1sHZtkjXpxc0WWiQt
0wLSuaBYvWb2o3tELGEG
=VUMX
-----END PGP SIGNATURE-----

--Signature=_Mon__9_Jul_2012_13_57_19_+1000_X9NBL4ABTclT0+6h--
