Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab2FYEL7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 00:11:59 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38629 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745Ab2FYEL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 00:11:57 -0400
Date: Mon, 25 Jun 2012 14:11:40 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Liam Girdwood <lrg@ti.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rajeev Kumar <rajeev-dlh.kumar@st.com>
Subject: linux-next: build failure after merge of the sound-asoc tree
Message-Id: <20120625141140.c6d71065dab293005514ee1a@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta9 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__25_Jun_2012_14_11_40_+1000_nrvdYKZvjeo3/jeL"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__25_Jun_2012_14_11_40_+1000_nrvdYKZvjeo3/jeL
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the sound-asoc tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "clk_disable" [sound/soc/dwc/designware_i2s.ko] undefined!
ERROR: "clk_get" [sound/soc/dwc/designware_i2s.ko] undefined!
ERROR: "clk_enable" [sound/soc/dwc/designware_i2s.ko] undefined!
ERROR: "clk_put" [sound/soc/dwc/designware_i2s.ko] undefined!

Caused by commit 3a9cf8efd7b6 ("ASoC: Add support for synopsys i2s
controller as per ASoC framework").  According to the Kconfig in the
patch, this driver depends on nothing ...

I have used the sound-asoc tree from next-20120622 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__25_Jun_2012_14_11_40_+1000_nrvdYKZvjeo3/jeL
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJP5+T8AAoJEECxmPOUX5FE0HUP/RCwygKHwulg9stdn7NF3w0V
fX8CevXBasTyTySKITtzHSvK3wH7BzR/HPCU1mig3v8fWCLY524bWkaMzmzolXQ0
b6HhyX4K3pxZN5SpSUQmS/sUgRGtjWzdHO/T/+1F0riVFLuM8CXeDjJ9DaQ0OpEe
/OgTR3CK2MfjgLim75vvzxSt9r++fGr2scpxE2o2YPy5EUc39BSnIaAJvaeARdX4
N660SP15vD7uQ1JjOIA/oiISP4U1OzXQLEz6YcVqK2QkKtTEaNP/RLlXyTWED147
J+MWPSWVswxYUqXWcJ52thG+oCRzgiYDDpPdUMuxUqwoSl+5xfeXZBj1OYZh3gbu
OBkEk35LbgTcc57wgNVK8F7wnP42HBgmTx53LNE+HRf/aUvXXGbmcnVVHqWi3h06
jGPd3v+xyEvo3ZaFwjsa5/Gq64tpgSRfBaSjFHUhI8RAM9qENfuTmV0VotcykduN
t0xv439XXwaqoz6PCy12H3B8fLWlQZ2ehfTU0rJY6a6ArhKC/QiXzoYxNmfc3XaE
FCHKGbwPGW6W1yowH6a5l3+rGkLh1ZG8F5mAAUs1p6yR6bqNCTjH1iuWbcpSNs90
58R5uMT1hif9IrdQB+xFzrUc2KdYrKp/y+wycViiEOIv1WLoE8b+S1nJCuk+7sP6
zIUE6OL/iu61zKxD4/G/
=Rdyl
-----END PGP SIGNATURE-----

--Signature=_Mon__25_Jun_2012_14_11_40_+1000_nrvdYKZvjeo3/jeL--
