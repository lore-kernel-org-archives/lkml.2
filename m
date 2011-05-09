Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752788Ab1EIGD7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 May 2011 02:03:59 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:56914 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751703Ab1EIGD5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 May 2011 02:03:57 -0400
Date: Mon, 9 May 2011 15:54:52 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for May 5
Message-Id: <20110509155452.e67bfd6e.sfr@canb.auug.org.au>
In-Reply-To: <20110507032442.GB21017@game.jcrosoft.org>
References: <20110505134959.b3761297.sfr@canb.auug.org.au>
	<20110507032442.GB21017@game.jcrosoft.org>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__9_May_2011_15_54_52_+1000_iyZyc76E=AUrbPPm"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__9_May_2011_15_54_52_+1000_iyZyc76E=AUrbPPm
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi,

On Sat, 7 May 2011 05:24:42 +0200 Jean-Christophe PLAGNIOL-VILLARD <plagnio=
j@jcrosoft.com> wrote:
>
> 	on at91 at91sam9261ek_defconfig and at91sam9263ek_defconfig
>=20
> 	will not exist next merge window
>=20
> 	as we merge all 9263 and 9261 in
> 	at91sam9263_defconfig and at91sam9261_defconfig
> 	respectively
>=20
> 	for at91rm9200 there are all merged in at91rm9200_defconfig
> 	in previous release
>=20
> 	so ecbat91_defconfig does not exist anymore

Thanks for letting me know. I have updated our build system.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__9_May_2011_15_54_52_+1000_iyZyc76E=AUrbPPm
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNx4GsAAoJEDMEi1NhKgbswAsH/0zb/X1oEYkmtFLk/oEpqu5t
aIqbbxN8YXmsWTtPW1fFPGhoj9psjHVBoY0dmzCt9ImkpRRB05kKOSakzA7NzxS6
RbuOhJDAA19/KxsinzQH0PXiGze5/gT9Pzjz/h5RFEfOiWhuT3vRmCbK8povEs3I
EhrXF0Moz3EtBODOqlL96wSkhLJe2ZGJ06UrzuUIKDu3/xuNjKGGIwHCoyVL3+3v
b6WNO7enGWOjfYph5JrWvdB8NHmqcS3Fxt5h4zsHV+6cOwcyS6HZ2SqVxtUahokT
70uvpPDTZI3y3TIt8yc4JMiUOBmLgjDojP5qpA58FpFfohSuDUtibHrOzXnM4yg=
=4Jet
-----END PGP SIGNATURE-----

--Signature=_Mon__9_May_2011_15_54_52_+1000_iyZyc76E=AUrbPPm--
