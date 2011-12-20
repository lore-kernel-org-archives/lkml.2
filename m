Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754119Ab1LTCje (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 21:39:34 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:52328 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750922Ab1LTCja (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 21:39:30 -0500
Date: Tue, 20 Dec 2011 13:39:27 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the rr tree
Message-Id: <20111220133927.f74f564f566166253bcef211@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__20_Dec_2011_13_39_27_+1100_zRWos/X7NBrEtD.4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__20_Dec_2011_13_39_27_+1100_zRWos/X7NBrEtD.4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

After merging the rr tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/infiniband/hw/ehca/ehca_main.c:68:6: error: conflicting types for '=
ehca_use_hp_mr'
drivers/infiniband/hw/ehca/ehca_classes.h:382:12: note: previous declaratio=
n of 'ehca_use_hp_mr' was here
drivers/infiniband/hw/ehca/ehca_main.c:71:6: error: conflicting types for '=
ehca_scaling_code'
drivers/infiniband/hw/ehca/ehca_classes.h:383:12: note: previous declaratio=
n of 'ehca_scaling_code' was here
drivers/pci/hotplug/rpaphp_core.c:40:6: error: conflicting types for 'rpaph=
p_debug'
drivers/pci/hotplug/rpaphp.h:49:12: note: previous declaration of 'rpaphp_d=
ebug' was here


Caused by commit 314332ce8f31 ("module_param: make bool parameters really
bool (drivers & misc)").

I have used the rr tree from next-20111219 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__20_Dec_2011_13_39_27_+1100_zRWos/X7NBrEtD.4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO7/VfAAoJEECxmPOUX5FE4YEP/0aQ6ayCdiu7wSlgfPtZO4x5
/8S/OY2bwUuKAlPOhaxBiuzKgcDKReGExP0jr2T8ivE+421HLbeL21dgKyUqm1tX
+7jQati79aK1+lXqhNqd7av2tM3Q6roteRDo4jtTwth/qF6LHAZGQvUQQI3Okja3
n5DG7pzQKcaYBFCJTZUGr4Xja9IxJyNJFKXO/Z7w1HaO8wU738FPuf3lx/9jwCcb
ZQqfTeiIaEWKznJwawIbet8Cj5AthUft60W5yJz6MRSQeneicvP2q5PSab2n/ngG
GSQjVSky6ADrTUGwZFyDPFPeZuboLmcFDeJ2OOKpn+KSJTlIoBjO5wUE0LHyCv1K
T/p+I11WbzvjKNnizcTUzrUCMXdXTVJd8HLFmAp9VqsinKuBAC9EShx0Bw1KWcJQ
sScKC2Q8cJ+w40OkHD3B3uP2UTLiCgfT6mg4+t339LE7xjDxIVgr4/eL0o/hcKgs
tTca6W7We5DpwloKbF3J+ycRfvy+6eoL908YgJkGfNCDKK7gMfQLiuJVjuGoTtC/
QYY0NiMiyDyEiYB4NOeNmQ8SVwuxPIqVJq7ntvef0V0f8MYvvnJIzv3dlSD5r6zk
qGGmqY9qTXvxooCM9ecChWbd5WKTSOBGZNFsq065dBvz9G7DisZhnTYojGtgbqp3
hYx09pQEiizJcXn0lodV
=MvMF
-----END PGP SIGNATURE-----

--Signature=_Tue__20_Dec_2011_13_39_27_+1100_zRWos/X7NBrEtD.4--
