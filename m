Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751633Ab1L1Gys (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Dec 2011 01:54:48 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:60585 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab1L1Gyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Dec 2011 01:54:46 -0500
Date: Wed, 28 Dec 2011 17:54:40 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: linux-next: manual merge of the staging tree with the l2-mtd tree
Message-Id: <20111228175440.fa8c027e41dbeaccddb0e6ea@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta4 (GTK+ 2.24.8; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__28_Dec_2011_17_54_40_+1100_=HNlTWXOo7Y0TPg7"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__28_Dec_2011_17_54_40_+1100_=HNlTWXOo7Y0TPg7
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/spectra/lld_mtd.c between a series of commits from the
l2-mtd tree and commit be7f39c5ecf5 ("Staging: delete spectra driver")
from the staging tree.

I just removed the file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__28_Dec_2011_17_54_40_+1100_=HNlTWXOo7Y0TPg7
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJO+r0wAAoJEECxmPOUX5FESZsP/0Nt+IdfdxlaOaGI416BLqgk
Ek4uwRmMEB3XWmONyFdBInANFCx+4DK4VVp7MUE0h4Dwyi6QA/A7YRAVB/6ts8fS
f2IEobLEJ/0oriSM0gKlZoY7PG7wEbbcOo/MVThfTsvJNNQ6HQNmx7QcSrdiMG75
k8zzaZ1SZV0MK/5Y7JtKxVJb0bVLnEENkIEHRwcwUuFDhCtrDqFVneV41lgBtO2r
FjQOwzJ1LKVSl07NY/CTTBSitQW2hoG5ZORyoN52O0HpI5FWTTRKl8EfGyWZhZHL
1ZBm3o0dQm7A4QiLPkdyUK7pTK7uwXMDIPv1s+7KzmUpi6aKg5gpOfjPZXUHFmhM
o7hsr0ZdYsDPzb3yZmkO2a9Alhf0TSh/ORyE/fVhNVD6OnAvkVVzOBvw3AS02xiF
ibFPYjfJoudPN+7QOiD+63CCMCa7AAOrJSWja2+whpaG8kOt2U/TIHeiKrI0Q5cI
86otk0ypoVEwZqqGY9Ixp1uG1f+VJrW+rinbEPxFKaARlGjrlDSPtGXMkghVQhbj
+AQKGohqeHWn+IPXmkF+lTD3w0lyYXrQVPoj4RHwgj+lsNZNrZnqf3AvHQJYYukC
H6fcdxeOYS9lYgxnurJT99vCj5S8KwuqFAykG5NzI/oQlsxeIAHD0Vx7fQko/plj
TzN+Dad9pUHEaRQ581+6
=iG3a
-----END PGP SIGNATURE-----

--Signature=_Wed__28_Dec_2011_17_54_40_+1100_=HNlTWXOo7Y0TPg7--
