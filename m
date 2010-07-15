Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758204Ab0GOCPS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 22:15:18 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:54114 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758145Ab0GOCPP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 22:15:15 -0400
Date: Thu, 15 Jul 2010 12:15:08 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: linux-next: build failure after merge of the devicetree tree
Message-Id: <20100715121508.61f66363.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Thu__15_Jul_2010_12_15_08_+1000_i9vXKrbck4foN/QB"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__15_Jul_2010_12_15_08_+1000_i9vXKrbck4foN/QB
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Grant,

After merging the devicetree tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

drivers/of/platform.c: In function 'of_device_make_bus_id':
drivers/of/platform.c:437: error: implicit declaration of function 'of_tran=
slate_dcr_address'

As you requested, I have dropped that tree form linux-next for today.

Andrew, I hope this does not cause you too much pain.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__15_Jul_2010_12_15_08_+1000_i9vXKrbck4foN/QB
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMPm8sAAoJEDMEi1NhKgbswjUIAI549YMkKow+94ttHgvgHA/l
7Rkd22OGsurDHVEQbZTgYyEBZRPkNTCAgsKuOtlOE2khehjPdSUxgXdQPd0pS5nY
NnVsmojvEQ53IIzhdBFsIggRCM00ikPDPrPIQ/cTa8fi5pgCVWJEeqF70EmLcrzf
/QEGEyYtLL3+agrT8edbenGhv/QL+NSP+6unTvM6oLRX3VcNkuUvBLWbed2BJ4Vf
JuI9cnYGJyV2td8ntW1KHCPltEKAh/VdYmHkThzWGfC76h9zVa3hPjaat1S+DsDt
m49IGW8MiHAwGA7DQyEj3DxQ2hbC+LxEctrGMln90Qq1XPZ2UA1Iq+3UTxQtNBY=
=ow4E
-----END PGP SIGNATURE-----

--Signature=_Thu__15_Jul_2010_12_15_08_+1000_i9vXKrbck4foN/QB--
