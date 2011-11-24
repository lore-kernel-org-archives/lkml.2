Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113Ab1KXEUg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 23:20:36 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60587 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971Ab1KXEUf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 23:20:35 -0500
Date: Thu, 24 Nov 2011 15:20:18 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Tejun Heo <tj@kernel.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michal Hocko <mhocko@suse.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: linux-next: manual merge of the cgroup tree with the pm tree
Message-Id: <20111124152018.66ee4f15447837dd01443fdb@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__24_Nov_2011_15_20_18_+1100_J2OPY9doEK=ZYCca"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__24_Nov_2011_15_20_18_+1100_J2OPY9doEK=ZYCca
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Tejun,

Today's linux-next merge of the cgroup tree got a conflict in
kernel/cgroup_freezer.c between commit 6907483b4e80 ("freezer: make
freezing indicate freeze condition in effect") from the pm tree and
commit 41dfa07cedcc ("cgroup_freezer: fix freezing groups with stopped
tasks") from the cgroup tree.

I think that the latter is a superset of the former (but I may be wrong),
so I used that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__24_Nov_2011_15_20_18_+1100_J2OPY9doEK=ZYCca
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOzcYCAAoJEECxmPOUX5FEWTIQAJMxT1/uRdlcwtaFCbciUaXn
UAnjLHjHfeNqC526tkIjsuLle2iyj2k1myX0uRyym1R2u9Y7t7fPtJCFElYWRwgg
Ev87BRG3RcxvNhPPeusxFqdKgvj86CoFGwSrrDTaXhR4Z7pJiyWb2cNCfsv7qpiV
BTa64iT1Yb91S+GW/V51Njh5Nb+X/jJEsiLL17UepUj1d1rzVsyOA46tkIvf+mB+
8ztP5qsIV4qYNtT1QHmPULZe/HRd1DtweeNm4kEHg9xDSRZeZNi6VlYAq6pPrBJg
WrzR0o9zKb19lM95aFDAo+D4lEmN3+KVij5sqXhI0VozOYevtrJpjO0H4E2JDY1l
4cpYGk1njirjhGqE8cS39YqqTtFigdtQEDgBvDk4dMx6OWUZNT4gJ94Tp5Fv87EU
zTrU4VTUgLKTdmgJ5ZuhKM6b68kTolc3m3HQq/I8u5/7FmKLJCi/DZeVkPPPOcF/
6iZhySKaGFvHiIiCUqa59cKCnkS/Rg4Tmtc575l3I+BxX/O3GpdR1a5uACCuywjw
jmTtm5U6egl/n3ucYM4uzg8XCocmVmO+BrSnCvtge4hNoAAKWsXzHghHqv1O4oyd
ocXRY7D8OW25r8V8eprRfAbCmb4QC0cKq6JEaZwcmfDbDf0S76meZ4qFNi7rLKWf
8oPLvgOJfQwhNObId3jR
=dGe9
-----END PGP SIGNATURE-----

--Signature=_Thu__24_Nov_2011_15_20_18_+1100_J2OPY9doEK=ZYCca--
