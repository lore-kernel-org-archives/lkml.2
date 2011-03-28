Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004Ab1C1DwT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Mar 2011 23:52:19 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:48601 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753464Ab1C1DwS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Mar 2011 23:52:18 -0400
Date: Mon, 28 Mar 2011 14:52:12 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andres Salomon <dilinger@queued.net>
Subject: linux-next: build failure after merge of the final tree (mfd tree
 related)
Message-Id: <20110328145212.8ed636e8.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__28_Mar_2011_14_52_12_+1100_biVcqco_t+k276D4"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__28_Mar_2011_14_52_12_+1100_biVcqco_t+k276D4
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc
allyesconfig) failed like this:

drivers/mfd/cs5535-mfd.c:30:22: error: asm/olpc.h: No such file or directory

Caused by commit fa1df691688f ("mfd: Add mfd_clone_cell(), convert
cs5535-mfd/olpc-xo1 to it").

I have reverted that commit (and commit adfa4bd4a8bf "mfd: OLPC: Clean up
names to match what OLPC actually uses" that conflicted with the revert).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__28_Mar_2011_14_52_12_+1100_biVcqco_t+k276D4
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNkAXsAAoJEDMEi1NhKgbsOagH/21jBsx9KmhQBAfWIuCcqcL/
X3CDJBkazCBA+TVU2s8VtrZ4IwTQvTk9LwHEHUKFKw6h4McPoNgSJtAvuhQdIsPK
TKDTklyvF5MdOO/3AC8gJlNwGvjqgR162QAFy03Othe+fUtCMwtzwbvOJkOzRByw
5PfZ0a4RUpyOn5KGTslqSh64p0zKyR2UHWOy24R1IxM+nP5ylNgFEF2OGrPf4VRV
r3kOsL9QkO+CUzOlK7gsH2rMjeWOdDdumFgy1bejUYbeccc7lg3IbChrq8BHKeob
aR6w+x86/zCRQWFR6d51luA4PFAf0uGus+4D3AQxJGV25UvaNdpRbYAaliWCfoI=
=BK8X
-----END PGP SIGNATURE-----

--Signature=_Mon__28_Mar_2011_14_52_12_+1100_biVcqco_t+k276D4--
