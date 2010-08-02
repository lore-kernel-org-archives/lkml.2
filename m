Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752526Ab0HBBb4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 21:31:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45065 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752371Ab0HBBby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 21:31:54 -0400
Date: Mon, 2 Aug 2010 11:31:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alasdair G Kergon <agk@redhat.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Milan Broz <mbroz@redhat.com>
Subject: linux-next: build failure after merge of the device-mapper tree
Message-Id: <20100802113148.e0b70b34.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Aug_2010_11_31_48_+1000_w4n8vlU6wBVMTyad"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Aug_2010_11_31_48_+1000_w4n8vlU6wBVMTyad
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alasdair,

After merging the device-mapper tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/md/dm-crypt.c: In function 'crypt_ctr_cipher':
drivers/md/dm-crypt.c:1095: error: 'bad_mem' undeclared (first use in this =
function)

Caused by commit 460328b294ddd132945bdf536a9130f2d6cd6ace
("dm-crypt-simplify-crypt_ctr").

Please do test builds ... "No functional change in this patch." :-(

I will use the device-mapper tree from next-20100730 for today.

P.S. the patch summaries could be more informative ... i.e. you should
put "Subject:" lines in the patches.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Aug_2010_11_31_48_+1000_w4n8vlU6wBVMTyad
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMViAEAAoJEDMEi1NhKgbsGS8H/iOLsG8KHtpAtfMyQBNG7EIT
futcOSqvYKh/6F8TrU1Ak+OODsXQAYB+rONZyf4209PGrhsC4FWsx+XtnD7hD0It
hCcCpYkvkSSmieTzs61shZkUgFzapUkf87v0b1gG4hge1I4kFcIKD21CY0pgoeJk
8VzzJI9kJql0jdZxAf3btJQ7Kq9PJq13zqFcYnRramTtucn/fZN2cM1N8l3q3bpB
koNgA0uAwFAjgTe9TrQ1Rr5ZaLlH0AMTunXJnUC2vZ2RvINFUPSNeFEHRndvubZm
xPF0fc9ZsaUt7YN2SSjos73T7pkC84/Kj9l4vt8GiNBG5ZbJAecR5/K0G2wDraQ=
=fCKs
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Aug_2010_11_31_48_+1000_w4n8vlU6wBVMTyad--
