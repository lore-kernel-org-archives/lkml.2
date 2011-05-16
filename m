Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753735Ab1EPCCf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 22:02:35 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:37176 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab1EPCCc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 22:02:32 -0400
Date: Mon, 16 May 2011 12:02:27 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rhyland Klein <rklein@nvidia.com>,
        Anantha Idapalapati <aidapalapati@nvidia.com>
Subject: linux-next: build failure after merge of the wireless tree
Message-Id: <20110516120227.27a5a343.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__16_May_2011_12_02_27_+1000_Vi8j1h2D6fppQmli"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__16_May_2011_12_02_27_+1000_Vi8j1h2D6fppQmli
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi John,

After merging the wireless tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "clk_get" [net/rfkill/rfkill-gpio.ko] undefined!
ERROR: "clk_enable" [net/rfkill/rfkill-gpio.ko] undefined!
ERROR: "clk_put" [net/rfkill/rfkill-gpio.ko] undefined!
ERROR: "clk_disable" [net/rfkill/rfkill-gpio.ko] undefined!

Caused by commit 165d625850e8 ("net: rfkill: add generic gpio rfkill
driver").

I have used the wireless tree from next-20110513 for today.

P.S. is the Author information for that commit correct?  It has a From:
line near the bottom of the commit message.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__16_May_2011_12_02_27_+1000_Vi8j1h2D6fppQmli
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJN0IWzAAoJEDMEi1NhKgbsMtgIAI3gRFzYJsoTgyb+kw8uO1Xj
T9NNk454aS76rcZmKgoIpC77cdfNJh4D+gbzIbh7aBbN/G1GNN0VTQzBghxcPtG5
9rh+exv3OauMlwRXHkpy5o5ELAaANlWoXkXaibJ3dYz7NYyg+GAPP9Qjico2Kg28
09nddVOzEuH0pjtfwJyHuT+m+QnHd6e4PyCBSuHExLAh1gpl34Lk2iJ8nyaz1E0e
r71ABK3/l5C1c+fq/TenY43XfZd160EJhd7Mx6rpi4fha/PeB+Ps8NqIb4qztB8i
Llj3Bc7nUyOPP9CQyM9TZoH94awg129MwYCJawubo/7YCRIum6UriqNMHfYm5gg=
=Kks2
-----END PGP SIGNATURE-----

--Signature=_Mon__16_May_2011_12_02_27_+1000_Vi8j1h2D6fppQmli--
