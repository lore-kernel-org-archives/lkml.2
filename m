Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752861Ab1BVAxv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 19:53:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:57034 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751840Ab1BVAxu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 19:53:50 -0500
Date: Tue, 22 Feb 2011 11:53:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Eric Van Hensbergen <ericvh@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Venkateswararao Jujjuri (JV)" <jvrao@linux.vnet.ibm.com>
Subject: linux-next: build failure after merge of the v9fs tree
Message-Id: <20110222115340.da48b908.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__22_Feb_2011_11_53_40_+1100_h0LMVhcEvmnCOfwG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__22_Feb_2011_11_53_40_+1100_h0LMVhcEvmnCOfwG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the v9fs tree, today's linux-next build (x86_64
allmodconfig) failed like this:

ERROR: "p9_payload_gup" [net/9p/9pnet_virtio.ko] undefined!
ERROR: "p9_nr_pages" [net/9p/9pnet_virtio.ko] undefined!
ERROR: "p9_release_req_pages" [net/9p/9pnet_virtio.ko] undefined!

Caused by commit ac8c81621fe5176f1bb18730e5db2e347af08255 ("[net/9p] Add
gup/zero_copy support to VirtIO transport layer").

I have used the v9fs tree from next-20110221 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__22_Feb_2011_11_53_40_+1100_h0LMVhcEvmnCOfwG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNYwkUAAoJEDMEi1NhKgbs21kIAJ1y8qTBmvoidCtMiBzF6mas
kEHfz++WDRis9zfsWzlqEAOMPWDa6xdn9CzFhkGL65R7fT/QmT8dRndH84Y1UxHJ
Ewsy0iNFBaQIHdAFRTKIIPxHH/2NcmRUdDiU/iBOZgC2cIPzld6zl7Qy4IJ2BXzU
aKQ6BlCDnpKnLsv5whO71CKkIm2nDUHMBtxlEDBNqetyMiM7C3fY778oxzPhDvEW
EoRR3pv/GbOvF7uyr7MX/lbPUqrmwZdnhDd3cFtj8U/B6kwmLQpTVJdC2gCSpmbT
OHHQy9OwBOJcMLWx1GXx+iDB52tF4L536pxV8klmt3JS/YPYTMJywUT9Rty/U1U=
=Ak3p
-----END PGP SIGNATURE-----

--Signature=_Tue__22_Feb_2011_11_53_40_+1100_h0LMVhcEvmnCOfwG--
