Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757486Ab2JBAjS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 20:39:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:45438 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab2JBAjP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 20:39:15 -0400
Date: Tue, 2 Oct 2012 10:39:07 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Trond Myklebust <trond.myklebust@fys.uio.no>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the nfs tree
Message-Id: <20121002103907.e43f5bb1cc9e6b85b3a51ef8@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__2_Oct_2012_10_39_07_+1000_FF/8XDs85xzEqtpr"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__2_Oct_2012_10_39_07_+1000_FF/8XDs85xzEqtpr
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Trond,

After merging the nfs tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

fs/nfs/callback.c: In function 'nfs_minorversion_callback_svc_setup':
fs/nfs/callback.c:206:21: error: 'ENOTSUP' undeclared (first use in this fu=
nction)

Caused by commit 141e1f553b6e ("NFSv4: Fix the minor version callback
channel startup").

I have used the nfs tree from next-20121001 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__2_Oct_2012_10_39_07_+1000_FF/8XDs85xzEqtpr
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQajerAAoJEECxmPOUX5FEXKsP/RJTQ2qSVHap+AiQddDLnm1U
kxvkD748u5T2A0wRzxfFBJ0rsVEPyT4eBZL9LCeJKJcoGdv6cHgkP+JWkwRwhv40
gDsatVFw6ORqHizbOaAk2o510MthcvI5pMI5ogkikGYkjusJfBPIBNTh3drtDST4
WLbvkxaanV0oL/cLE6woxC1rBHiYn55xzv3kWEAaIQXWo+MU7axDIy0m8+WpHYYV
e/c2U39ZOkxyZssJS+i6N0dxYBBqNVtazdxo1QCSmzJZvkDKKFNzy6rp0CyYVz/3
2SCJZTnLdyFsxXXFKr3GLY8WyIwlf0tMzzgpCvuNr4Sx2b4GsptBwNVwmYAduSYB
33ygm1NGCAnRxzZT1kenc2+YD+r0HhSxWAgqleZIU0Lyke3/2wbViJAHcisqDNwZ
018TlsxQABiPlctvy7Pf4BpYlL9y+QoswERJQP9CEJgYl1uGoiM/s3icpW8CISiJ
glbBRCNFGsNjZKu2+HeEJWBcKaqk3y5t4a6r95rDNNizDCqmOO9ZxqayX5FUtdik
tCR3YP132hEgzY9ukNHFFvS7g775VmP/EAUF+A/vZI65leA+npGwaq798S+4YQA2
O88tAW6/kSOz7m/vJY3hkuRnTwZQxBg1lwtzuB/t5XE+YKgj2OGv4qKp0E3NQaok
TpnEDhbp8h0zzlHmB09v
=Tbp+
-----END PGP SIGNATURE-----

--Signature=_Tue__2_Oct_2012_10_39_07_+1000_FF/8XDs85xzEqtpr--
