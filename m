Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752419Ab2K2GZq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 01:25:46 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58039 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692Ab2K2GZo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 01:25:44 -0500
Date: Thu, 29 Nov 2012 17:25:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20121129172539.c2985a1ea7ddebc8dec28a50@canb.auug.org.au>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__29_Nov_2012_17_25_39_+1100_w/X/pF2fRnfbsJkG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__29_Nov_2012_17_25_39_+1100_w/X/pF2fRnfbsJkG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) produced this warning:

sound/soc/codecs/wm_adsp.c: In function 'wm_adsp2_event':
sound/soc/codecs/wm_adsp.c:556:4: warning: suggest parentheses around compa=
rison in operand of '&' [-Wparentheses]

Introduced by commit 973838a030d2 ("ASoC: wm_adsp: Enable DVFS for ADSP2").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__29_Nov_2012_17_25_39_+1100_w/X/pF2fRnfbsJkG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQtv/jAAoJEECxmPOUX5FEwMEQAIaP6A7sdbl3jaxti+b/3e3p
6IDyeCZp85Evcu9vvpNxFtEqr/3GjKlWROgTc8fbwIgZ7Cjvt4ie1We/ffNSaw3I
qzJwBjMKKiYFBwfMF2Hz4zt0mjXr45WVGFg0IYv1W/ra4NGkHT5zsVYoXTV2PYPa
1qMNkYQG8eKyri8kn8qVbchPgVnMK6a0vdiM4esSaGrrcPXfpXvzt//knQoSRx+R
sf1tR5TJ27uYBygjdWd5WrIW06mlpqI7WpN3++Y3weHzA0MZCvQVyyj761GbaePd
ceSX99TvktD/UUDFz9zzpEGgTs3fcZU5PQ7uWrcexp9gwG21qCXT9nbEvqVyQsTQ
e+fupKqJ4HS4im0o8tybBMuhPQ7JFuLYXDPnm7+1hTVKYBeXwwDOuS75Rjdkgn/p
wuqy5bPmYz83eNzOaxbMQbO4DuQ37OKe7zUqqOOmTxnN8h1V/kZh9DhexIZJDJtz
e+vV2qAp+L1suuM05YHP0iy5AFEKH3zqnMyV4ls9MVNly9HbKHucmwBKgymTSWg0
EWotEha4nTBDT40WS4B48MNBYR4JkNqP+gYKwSszx3QhM5mRB+y8qsaxNl2/WAfV
fq/sBurTKl9AHLf4vGwABkFlZNxLwhjnBLV+4PauohbJzKYUvGMeyjgvH+D2Jv4E
0y4kM/QgNMsvyHl4z2GT
=lOJS
-----END PGP SIGNATURE-----

--Signature=_Thu__29_Nov_2012_17_25_39_+1100_w/X/pF2fRnfbsJkG--
