Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753177Ab1DHFyp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 01:54:45 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:45560 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751523Ab1DHFyo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 01:54:44 -0400
Date: Fri, 8 Apr 2011 15:54:38 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Alan Cox <alan@linux.intel.com>
Subject: linux-next: manual merge of the staging tree with Linus' tree
Message-Id: <20110408155438.605a638a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.3; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__8_Apr_2011_15_54_38_+1000_ml.FYfObLx7.Sd9u"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__8_Apr_2011_15_54_38_+1000_ml.FYfObLx7.Sd9u
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/gma500/psb_drm.h between commit 25985edcedea ("Fix common
misspellings") from Linus' tree and commit aea74b656799 ("staging:
gma500: kill off TTM") from the staging tree.

The latter removes the line that the former fixed, so I did that.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__8_Apr_2011_15_54_38_+1000_ml.FYfObLx7.Sd9u
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNnqMeAAoJEDMEi1NhKgbsd3wH+gKXmPbObivP8mRgug1Jzomg
GruJmRcRkDdBw82qsxjjZi29SMbwPd62zWwosAfGbcX3Q2uNf2ZhwqcbbWjoQUb/
c4CeA2Kyz8PYfXh6QCQlsLfdzH8X3+rrHLPHUma6cSC74+wagOzOJvdBc1tYCCWD
MwMDMlBqiwohRN/ZuOC0NBveXXVj1u3FUg0mylev4ulwzDt6+RiArXApzpwU1mo6
6TCkTFLTYf3++ATS0Ar3Tr6wcM1ncMsMT8swcPyTWGNyF7U4yoEU07THYiHTTI2O
GlkbY+W5kpq0HrQv1ssLMsGWAYHf3ZcYj5PKygBy+Q75WQtBVL8092dhwS3shnc=
=JWnw
-----END PGP SIGNATURE-----

--Signature=_Fri__8_Apr_2011_15_54_38_+1000_ml.FYfObLx7.Sd9u--
