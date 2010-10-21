Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757218Ab0JUChh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 22:37:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:58820 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757158Ab0JUChf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 22:37:35 -0400
Date: Thu, 21 Oct 2010 13:37:26 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: linux-next: build warning after merge of the devicetree tree
Message-Id: <20101021133726.d1e5f433.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__21_Oct_2010_13_37_26_+1100_a9Yk4zV3/wgpV4.i"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__21_Oct_2010_13_37_26_+1100_a9Yk4zV3/wgpV4.i
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the devicetree tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

arch/x86/kernel/irq.c:280: warning: 'struct device_node' declared inside pa=
rameter list

Introduced by commit 27f4e2b1060be8bc38146fd30986e7c2858e2a5f ("x86/of:
define irq functions to allow drivers/of/* to build on x86").  This build
has CONFIG_OF not set.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__21_Oct_2010_13_37_26_+1100_a9Yk4zV3/wgpV4.i
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMv6dmAAoJEDMEi1NhKgbsRQoH/RYBPNJCxfwKv8llmJnHC7XQ
CQV2z1f8sg0PDVdS2GdGfuOxkzl6AajIEaECYLFwjZmyW7Uyg+YWPl5WIwv32kvt
89BD1H0jvROBFZBx/6hVrTblEBfmTPNd1uQBCe2OCl/qDtX4ox5S7XqWOc/MTK8j
TQInVem1kpsl58TJcMFb/2Ba7UoHsVCoLXKfbPqgMBemuFH1GyhCO12QPPY0X2gB
iaLXR/Z2iMcRLDJt97fHSqVV1VPgrPmJdxwqJyJrsGcs1yJczneW8H73LqPHhu6n
RNi8H37vJo1QJvhJe+cs+3ZbmvwrdA9arDuhOeVCb9n1khf2U4KK9e1LUKjNJOU=
=eaC2
-----END PGP SIGNATURE-----

--Signature=_Thu__21_Oct_2010_13_37_26_+1100_a9Yk4zV3/wgpV4.i--
