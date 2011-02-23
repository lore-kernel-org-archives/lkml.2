Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756200Ab1BWDe6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 22:34:58 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:44042 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756159Ab1BWDe4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 22:34:56 -0500
Date: Wed, 23 Feb 2011 14:34:46 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Wim Van Sebroeck <wim@iguana.be>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>
Subject: linux-next: manual merge of the watchdog tree with the sh tree
Message-Id: <20110223143446.8646373f.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Wed__23_Feb_2011_14_34_46_+1100_V8kjgd3EIUHjSQk5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__23_Feb_2011_14_34_46_+1100_V8kjgd3EIUHjSQk5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Wim,

Today's linux-next merge of the watchdog tree got a conflict in
drivers/watchdog/shwdt.c between commits b1fa888e0124 ("watchdog: shwdt:
Kill off mmap stub and superfluous comments") and 8f5585ec3d17
("watchdog: shwdt: driver model conversion") from the sh tree and commit
e273d97a2281 ("watchdog: cleanup spaces before tabs") from the watchdog
tree.

The spaces seem to have been cleaned up in the former patches, so I used
the sh tree version of this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Wed__23_Feb_2011_14_34_46_+1100_V8kjgd3EIUHjSQk5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNZIBWAAoJEDMEi1NhKgbsEiIH/3W3FDxrgGlAQf6bfLbfi7qK
MNkUNAh8owTIwU7+CPAvXBcOBGRTu1e+w4XZSPyUhGthZCUxqFeJ0IlzYJmLAzLn
aEv2LGi5HWRD1LL/islbA6A0IPxyR1OUHrB8C8ZyquBk7xfKiDYaH+mrVts+pneQ
qze+dE3l4gxqK0Xs0LUosi7hV0Cwrxl3oHrYbz0vRuChu6bycLtDABVIF42xRUS9
PKFP2IcGx1tEl2mVNjpD6ZBDRILcIdBVVKzvweJW9ova+JSEFPT1yODBc0sILZ8W
RqrRvSi2GctLnFtEsPtcZCmVSsH4Girj2nW+dmTGnp/qaGFgTwjf/ajYvH2t2gU=
=YWrO
-----END PGP SIGNATURE-----

--Signature=_Wed__23_Feb_2011_14_34_46_+1100_V8kjgd3EIUHjSQk5--
