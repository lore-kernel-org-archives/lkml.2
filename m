Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934667Ab2JXLAY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 07:00:24 -0400
Received: from mga14.intel.com ([143.182.124.37]:10855 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757443Ab2JXLAX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 07:00:23 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,639,1344236400"; 
   d="asc'?scan'208";a="159769160"
Message-ID: <1351076421.25066.14.camel@jtkirshe-mobl>
Subject: [BUG] checkpatch.pl with commit
 058806007450489bb8f457b275e5cb5c946320c1
From: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Reply-To: jeffrey.t.kirsher@intel.com
To: Joe Perches <joe@perches.com>
Cc: netdev <netdev@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Date: Wed, 24 Oct 2012 04:00:21 -0700
Organization: Intel Corporation
Content-Type: multipart/signed; micalg="pgp-sha512";
	protocol="application/pgp-signature"; boundary="=-HyVN+UXG0ydUy0dgtNqB"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-HyVN+UXG0ydUy0dgtNqB
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

With the recent commit to checkpatch.pl:

commit 058806007450489bb8f457b275e5cb5c946320c1
Author: Joe Perches <joe@perches.com>
Date:   Thu Oct 4 17:13:35 2012 -0700

    checkpatch: check networking specific block comment style

We are seeing false positive warnings.  Here is an example of the
code the would generate a false warning:

#define foo	0x0000 /* foo comment */

checkpatch.pl generates a warnings that the */ should be on a separate
line, which in this case is incorrect.

I apologize for not digging into the checkpatch.pl code to provide a
fix, I figure Joe (or anyone else with great checkpatch kung fu) can
figure out the issue and fix it faster than I could. :-)

Cheers,
Jeff

--=-HyVN+UXG0ydUy0dgtNqB
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAABCgAGBQJQh8pFAAoJEOVv75VaS+3OgPUP/AzNILq/YVcb+D1Ut5PeV6zz
biyzhiakAkcyRJq6/5c4Cu6zEucgG8j+f43M6moM9BoDKLi7WHwyUguWuG+7t9DG
N/IHh1isAER0/hn9q0bF0rg0sXgUMOMbPKM8sR9/vGXwtgE/pmciDxQ6D5P0M8Lj
opNBG7IGykrawQVKOsRC5smnDyivJqtRwXkherNF37Xz/jx0wPVqlzO42RNIbP0W
YXKmuc2yn3wT2c62f+ya8RR/N2n63VHfl8GbmTi5FVv6tj8aiQ0YUlphGmJz613K
ZMaHyc4dfbQgjjGLe/dow2nT3QoxdJZ84GdOUvqVrDH4v69E6J7rxMtyUmjtFtaj
ekR+t8d049MASl82p9gj7jblkiR0u/u/RkFXp4LihZB2vx3WS3pVNJRadPVkAYX1
FAJ7kuzlm/nRS2D+25zC7oV4jBNWvY/v0+nB0t/OaYekzbxUkjBPgFDcCAJir1Bz
JM4bCAUN8MUdL0aPSn7JU+x9mSwvC0E01Z+oM6uctakH52DFq5J9MFW9ekk0GCYG
NZ8xnyiKka1SeiUkhnRx30RZaPrXakdhOiP1U1VSn2npSSdcqDWNvaBcLXoNFK/i
ZFLfCJtWIquell6LR99HAEi2a+5+Onj4SVMaL4a7WbkitfZNFWPrbDRMhD5crAR3
XSL57JB4njxH8JY/gxn7
=WIIH
-----END PGP SIGNATURE-----

--=-HyVN+UXG0ydUy0dgtNqB--

