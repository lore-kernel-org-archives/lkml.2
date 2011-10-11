Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753724Ab1JKI5P (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Oct 2011 04:57:15 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:47081 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab1JKI5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Oct 2011 04:57:13 -0400
Date: Tue, 11 Oct 2011 19:57:04 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warnings after merge of the writeback tree
Message-Id: <20111011195704.67c267dbb3c6eaaacf5d7a39@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__11_Oct_2011_19_57_04_+1100_l1Og+_LpvOsIpw63"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__11_Oct_2011_19_57_04_+1100_l1Og+_LpvOsIpw63
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wu,

After merging the writeback tree, today's linux-next build (powerpc
allnoconfig) produced these warnings:

mm/page-writeback.c: In function 'bdi_position_ratio':
mm/page-writeback.c:622:3: warning: comparison of distinct pointer types la=
cks a cast [enabled by default]
page-writeback.c:635:4: warning: comparison of distinct pointer types lacks=
 a cast [enabled by default]

Introduced by commits 6c14ae1e92c7 ("writeback: dirty position control")
and 8927f66c4ede ("writeback: dirty position control - bdi reserve area").
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__11_Oct_2011_19_57_04_+1100_l1Og+_LpvOsIpw63
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOlATgAAoJEECxmPOUX5FEtOMP/0y1JjvCbKt9P+3jb+IxOfG1
B3j91uDOQ40n1lzbQeqUBe8BOT/ypcxUG32xMyTRvYvUzL6nyfCWJanHzPq6MmB6
DYYIqJ0otDScSfdFL5Mz/Q2fqHorNJblGby01WfnghszogiH4hCNC2ckGfXRclIN
+dC3LjC+vf4/TKdajEu+plq/uPQJNSAGjETII9rrfsmtcBaN/HWZMWjHDmUDtqJT
UZFdJItpRmXnaqnCC2swuqZr5hh6Cka33rdWs3EOJZ56UqJxfk8rWetVa0TtqR1g
2VITLsE7WDe9PUFdGsArvnuhX6qSBMRnTy/DY0Jk+YZe/nZGvHgrEGCo/CfDdS+s
IOThxZ3h2zpOFpogOStddhxD05XKGR24sr5rqVFeHuD1z7Vnux8OPFULnUNZmUuD
1dGil723ZZdLSdgdCj0gC7+Kt/e5PX6EssytuqNQ0HdjLvwirb3GesnVcZBZxHOC
HjOtdunCktk0l6opsF3yAzzh3kBcpChzDV19ul3sjAFXsEKYamlxXLR6LkFYyJk8
p0mnOtaXXN1jfb9/M7KBlYzto1lMdp67xBwo6lGO8GGc1gMceYzLE6QsfcmDt9sh
3M15Dg4r+yynFliubo8cwEpKazZxoaYttZIQAfUYHLkj6xMvYA9FLFHuDnCZQNuP
pZgoQPaxco0STA3VwO1h
=kO3V
-----END PGP SIGNATURE-----

--Signature=_Tue__11_Oct_2011_19_57_04_+1100_l1Og+_LpvOsIpw63--
