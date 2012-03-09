Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752482Ab2CIGs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Mar 2012 01:48:26 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:54495 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751881Ab2CIGsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Mar 2012 01:48:24 -0500
Date: Fri, 9 Mar 2012 17:48:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, <linuxppc-dev@lists.ozlabs.org>
Subject: linux-next: manual merge of the irqdomain tree with the powerpc
 tree
Message-Id: <20120309174808.88d351153355f3783d24b33e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__9_Mar_2012_17_48_08_+1100_bWlGETrHCrklAJvJ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__9_Mar_2012_17_48_08_+1100_bWlGETrHCrklAJvJ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

Today's linux-next merge of the irqdomain tree got a conflict in
arch/powerpc/platforms/iseries/irq.c between commit 8ee3e0d69623
("powerpc: Remove the main legacy iSerie platform code") from the  tree
and three commits from the irqdomain tree.

I just removed the file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__9_Mar_2012_17_48_08_+1100_bWlGETrHCrklAJvJ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPWaeoAAoJEECxmPOUX5FEfzEP/2dAFFqzzJUwQhZ2oyUiMgLX
48INrlRmaFpkddbbgbon1PCkpVu9khmnaJVh82A5hb6TXj67K5/7Pt5+idxLqUmr
u0Yb8WSz9VnA+/NMiturI2xLp4lg5Bi8ytCHgm6DLArezTZwR6Vga1foTVmQY4PE
R/Kgxneu/z5dt/BzU873hiVdkivi7PxVZrMguNObg2YhPFr1S8oWCUVeoyd28ABz
+4iP0YkYMKaVNuFAw1Fpne/Lm4d2UzaJGb1/RGWh+9rYb/MZQ//sLdZaB0WFThcW
mC1iuamVRqKwWLRGQw3aC+Yr6ruBAnGVI25sw3OW4tP72b4m92PYRx6KCX+HBks+
sKk9YCJQ7bNoKJyfjpskIwKjV84V0unB+6lx2GBiC9Ms9adTum8JzEuFvUHWQzWg
9cx5hF0Ko6RreeOsirVC7W/b7M9XQP6p3wsWqiPCHFptfEbvWr52wyGMwlo52fXo
MHxHoi0ZQxgfBTvjvp9od1sGvQ9uZnISPNHdxM8LMzrYIJZHU3pCPKUMbgkHuLsU
+ILTsGdJcVXz/tABMuJ5BXfdPCHWAhCCGWtvYg9KzKIv4bWbqBrdlX01jgSNzZ58
uckECGNtuMlYinZCDSXwff3cGitEo5aMJv1/TEeF+W5KNX+9NpSdXeF8ZlQIUzYw
RBL9wd9HNEG0x9QgxSWk
=j+ie
-----END PGP SIGNATURE-----

--Signature=_Fri__9_Mar_2012_17_48_08_+1100_bWlGETrHCrklAJvJ--
