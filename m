Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754492Ab0K2AxH (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Nov 2010 19:53:07 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:54575 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754270Ab0K2AxE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Nov 2010 19:53:04 -0500
Date: Mon, 29 Nov 2010 11:52:57 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: linux-next: build warning after merge of the mfd tree
Message-Id: <20101129115257.9a78ad14.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__29_Nov_2010_11_52_57_+1100_MogseOtbvw2HzhUh"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Nov_2010_11_52_57_+1100_MogseOtbvw2HzhUh
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Samuel,

After merging the mfd tree, today's linux-next build (x86_64
allmodconfig) produced this warning:

drivers/mfd/cs5535-mfd.c: In function 'cs5535_mfd_probe':
drivers/mfd/cs5535-mfd.c:106: warning: format '%d' expects type 'int', but =
argument 3 has type 'long unsigned int'

Introduced by commit a0d4503a044e67ac46adfe8f42eddefd2b60f85e ("mfd: Add
cs5535-mfd driver for AMD Geode's CS5535/CS5536 support").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__29_Nov_2010_11_52_57_+1100_MogseOtbvw2HzhUh
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJM8vlpAAoJEDMEi1NhKgbsT2sH/je1ehpGwkU1LHcmGzQGdI5z
Xw35JaHSpVbhPw22/JPcUso28yHCN3ZiHulzBKYaKUFeJJ+VT6wu3HujZ1eG0YgP
CEJne4xUc7lNCu62IPRQfkqIA/io+0Z0oIHniXxFbkWvNd+X9uQD9ow0bglqcCWX
5272r4ihj/JqCEBg+9r3vuzLNc0ZYpAH2PDkA84ICdeIbcLuD6f7tJZkgw2Jgvvb
hx4hA51mI7SMryCR6WwWe2Gbp6GCLZV4WvwbSeO/KrYkY001gHrVPEfG4muiz86I
t0f8vXyOneET3d+QoWu0Y8vBn6YvEmw2kcoB8OyZu+NJ7bhA0J/V9DSznWoYAOQ=
=CYK4
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Nov_2010_11_52_57_+1100_MogseOtbvw2HzhUh--
