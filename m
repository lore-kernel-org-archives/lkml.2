Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761326Ab2FEB0K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 21:26:10 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:46477 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761312Ab2FEB0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 21:26:07 -0400
Date: Tue, 5 Jun 2012 11:25:57 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        M R Swami Reddy <MR.Swami.Reddy@ti.com>,
        Vishwas A Deshpande <vishwas.a.deshpande@ti.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120605112557.61c2aaea05db2684cecb9835@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__5_Jun_2012_11_25_57_+1000_mHBbspSv.==+vEmo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__5_Jun_2012_11_25_57_+1000_mHBbspSv.==+vEmo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

make[4]: *** No rule to make target `sound/soc/codecs/snd-soc-isabelle.c', =
needed by `sound/soc/codecs/snd-soc-isabelle.o'.  Stop.

Caused by commit 4567db1722aa ("ASoC: Support TI Isabelle Audio
driver").  Was this ever built?

I have used the sound-asoc tree from next-20120601 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__5_Jun_2012_11_25_57_+1000_mHBbspSv.==+vEmo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPzWAlAAoJEECxmPOUX5FEdHEP/3trRGMgFHTzCM7gPMK8r68r
SA4+wlqsHiS2aosVbtGJuRWkE5mpC29+8FlaL4YvFQZtt/IJE/jpsZZ2BqxrW3Vy
7UVmMChG+StCZc26wyo8Se2saoZXjz9NidV8nNOdqf/4qDnP/K5+cD2nEJCKcYbT
S9KzCdJtKcapK850JNEm2dtPjwrskBazxVadRvIAtnACBvDUzym30rCqI4dKVU/c
oRW51hiJX5Q/M3Q8eRnZUk855MFv8vPZ6YOJHtioq66FkDU8AmRUk2M6G8xFIXT1
4Tes5oFrAN+qCDdubJogMQNJxxGeEr4hMpCw1H0oSu+DQoNjgloKhLqOaMj1Jq/z
EgqE/RTffb6RYnYOZ2GR/wF9x5Jd62rqV1XV1bP5tl2TXo5kCQs1ApAQ1fmAZniQ
EtHK/j+14+8erA4PS3RnRAai685w0btpRS+/63+ZGWrILoEOBUCOcMctO0dP9Emc
lSDrrAN2ykc/cl/+vt9xlLHb9q20Fisk/SVi751J8F9OmmfzT7xZky8E1IJJEt0E
nbMQD2w8PrJGrgz62Nex71BZ4Iwvm+2wShap4bMssOHZX/+kQhzDUrkrMeIaf2pc
XFo8+w1OeKSFzvwmA6cWEy5A7ZyT42fanXtLL647jQX3VOpOjvELD3Hp171K/XoQ
sOJzs/w9ZYBxSH30YaMe
=QKqL
-----END PGP SIGNATURE-----

--Signature=_Tue__5_Jun_2012_11_25_57_+1000_mHBbspSv.==+vEmo--
