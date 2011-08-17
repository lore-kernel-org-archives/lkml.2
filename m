Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751054Ab1HQEWM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 00:22:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:46369 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750831Ab1HQEWJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 00:22:09 -0400
Date: Wed, 17 Aug 2011 14:21:56 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the final tree (sound-asoc
 tree related)
Message-Id: <20110817142156.04f20226dbb44becff34b9c2@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__17_Aug_2011_14_21_56_+1000_u125dDRq7lGltSVC"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__17_Aug_2011_14_21_56_+1000_u125dDRq7lGltSVC
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mark,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

sound/soc/codecs/wm8994.c: In function 'wm8994_codec_probe':
sound/soc/codecs/wm8994.c:3144:27: error: 'struct wm8994_priv' has no membe=
r named 'wm8994'
sound/soc/codecs/wm8994.c:3146:27: error: 'struct wm8994_priv' has no membe=
r named 'wm8994'

Caused by commit f0b182b003e2 ("ASoC: Implement WM8994 thermal warning
and shutdown interrupt support").

I have reverted that commit for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__17_Aug_2011_14_21_56_+1000_u125dDRq7lGltSVC
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOS0HkAAoJEDMEi1NhKgbsee4H/2qUme/BcL/FprOny86lCokZ
V+ceQ9NAmCJ6J6+kBHWldbyFtGbINdY/boqmW+b1WimU5sRW1PL0ImEPgr89/glR
AHPBdCVUJm4t9Z6D5zisVKVkv6trBCObaIDK5JAVc1nbf/1HGffqK7H4APtOiTSH
L/uahlxm64azbd8LtJjFAy67HdqUrk+/ubq/Mxw/Ym8dxkI05DaWiLoXNtWljYH0
8KxkpTYeJmKJQyOzdux2W2D3Ic4mDSZjzaUDncUGr22TvVADOpSyjs2OGWlTos3d
dDhcLwCVTrSWG6/VIxX2jl1d0kvBJthRxhMCzkgbY1CxJv5znPNMft8hsUFi+PY=
=HcvT
-----END PGP SIGNATURE-----

--Signature=_Wed__17_Aug_2011_14_21_56_+1000_u125dDRq7lGltSVC--
