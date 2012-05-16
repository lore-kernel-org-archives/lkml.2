Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966793Ab2EPJzX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 05:55:23 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:41261 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759894Ab2EPJzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 05:55:21 -0400
Date: Wed, 16 May 2012 19:55:13 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the final tree (userns
 tree related)
Message-Id: <20120516195513.29d921bc25f308f92f0d6471@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta7 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__16_May_2012_19_55_13_+1000_lD7z/pgwfSqa/hed"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__16_May_2012_19_55_13_+1000_lD7z/pgwfSqa/hed
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Eric,

After merging the final tree, today's linux-next build (powerpc
ppc44x_defconfig) produced this warning:

kernel/user.c:30:4: warning: this decimal constant is unsigned only in ISO =
C90 [enabled by default]
kernel/user.c:38:4: warning: this decimal constant is unsigned only in ISO =
C90 [enabled by default]

Introduced by commit 22d917d80e84 ("userns: Rework the user_namespace
adding uid/gid mapping support").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__16_May_2012_19_55_13_+1000_lD7z/pgwfSqa/hed
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPs3mBAAoJEECxmPOUX5FEgncP/0sNLgeOzy9XqaBi2EAOQ8QO
MwqmWDyawXTJxM4S4bO6+phZf2Yd8WKDTBueeaxPHM4oVWD7RI4Ox4hjxy1a2WAU
+Nt+EPVQf+99pQE2vcsqZ91XiRL9aVyW1jeQ+znBPFvdGBeb+PYsKFqoI6x4Jnng
X9btN8m3BsSPhpYxn85hEADyl6Dar66hu0da00y72BfG8H1XOKhHWO6T5X0Al1Zs
AvvxTf59AQVOeDW+ObBHgYsEijojDLHLLw/lL7yS/p8W0aUagg8ophtvdzn/kaQj
E4pO6WKhTvqov5ogpDTMoLENcr08lASVTNgEoyGh/g5Fpe0cxwuJVSEOS6rhVWez
sBreVw8vi56dLiMsszkga7K/dGnf9UCSvC71o/C+ZQPmIQ+zGFnrLqWBnyTeIXWv
C9C/4mi1NIMhRNsMtgIfR44TeoXM1zzdDDOpMDXq1afvUbOkD7lTE20HJYF38wtd
RHI1yFZL+pb7rAfurnTqiyCAQjljx5C+jvy9p1JH1F0w/LC5/ooTEjmO5SBaKw1U
jt9S6zZw7y9zNsY/Co6jva0NjILW9GCAmBUe75qz1DilCdKfHsWDERPt6fuD/aEN
rYNutxjen3bJsf4wxnFpRr87//8Ow7bAXtA07oiFtWxV2PD/DPyoSVK7zh2fG9Pj
u9Ij6kJAc5nChwOGamHc
=NegO
-----END PGP SIGNATURE-----

--Signature=_Wed__16_May_2012_19_55_13_+1000_lD7z/pgwfSqa/hed--
