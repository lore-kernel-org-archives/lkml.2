Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757602Ab2C0DKp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 23:10:45 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55393 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756875Ab2C0DKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 23:10:43 -0400
Date: Tue, 27 Mar 2012 14:10:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Chris Ball <cjb@laptop.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>,
        Linus <torvalds@linux-foundation.org>
Subject: linux-next: manual merge of the mmc tree with the s5p tree
Message-Id: <20120327141033.352dfd5cc4ee937ee7371860@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__27_Mar_2012_14_10_33_+1100_CssjVMcg8u3v0izY"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__27_Mar_2012_14_10_33_+1100_CssjVMcg8u3v0izY
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Chris,

This conflict has been caused in part because you rebased your tree and
copied some commits that used to be merged into your tree from a shared
branch.   Do *not* do that ... BTW, when you rebased those commits into
your tree, you did not sign them either.  This is exactly what Linus has
just berated one of the other maintainers for ...

I am not fixing this conflict, I am just using the version of your tree
that I have from next-20120326.  Please fix your tree up properly.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__27_Mar_2012_14_10_33_+1100_CssjVMcg8u3v0izY
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPcS+pAAoJEECxmPOUX5FEKuwQAJUgUsH9mBUTfIkDkl99e1lw
buV9xNpbNmpmdxHcSkAnm2qY3S83/0q1W8Kotg8l98UkF+qFa1EpWuah5+GlvO7M
VZIe6MpYHd+06un9zqAC/lB4h/1lr3jYgTJRSNukaud8vBVCnYjt62mTWOV1biSK
qakinjpW/fYIejddpUg4H+WtVOy9QDbEHjfy/yAltkYuf6OTPhN1VcX6arZN7d8b
cdXosT1x6/UcTcdvyt9KPSOZExduD9hXem+JI43FUA2bcOBkRgskagBo9Y3B1k9d
TJlCqcM6dl0F5Baf09RN9QpIl2LENfGYRxUdJxadGvf5pUNBNDtTsKI9RmFVepaA
pPcXnwPD56tKJwJUoKMN8gdX6ZN5Ay+Db3R07ORGaSvPE35RfXMHCF7piNTKt05U
JFzXV4i4e3aCrfPmD9JkF745FJI0FRPyGLucYR2jf0j91uziV1Dzk7GTOFQEDkH5
1N4tExDzAsdSVZfA0xBgautP9IZDY+1Dc1NoFbmMCqlyiuitVqZD/RBdZhR37vfu
WAjn2dVAp4MApfFmWFtuBUeYPK4uIlzVXh8+wrCetF/TJtKIG2GmfYHqs8vBm6LV
lWXM40pEi/wiulscDxmlS6mkLx4pB5sdBH8xch83pQChadmsCeSwNvPXz4lYJ8EH
uYoAzcOKaIsaPm5PSLkr
=u3yi
-----END PGP SIGNATURE-----

--Signature=_Tue__27_Mar_2012_14_10_33_+1100_CssjVMcg8u3v0izY--
