Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757465Ab1ANASD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 19:18:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59585 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757455Ab1ANARy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 19:17:54 -0500
Date: Fri, 14 Jan 2011 11:17:47 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        "Matti J. Aaltonen" <matti.j.aaltonen@nokia.com>
Subject: linux-next: build warnings in Linus' tree
Message-Id: <20110114111747.efdddf0c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__14_Jan_2011_11_17_47_+1100_dJ2ebAxRvHXalbkc"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__14_Jan_2011_11_17_47_+1100_dJ2ebAxRvHXalbkc
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the Linus tree, today's linux-next build (x86_64
allmodconfig) produced these warnings:

drivers/nfc/pn544.c: In function 'pn544_read':
drivers/nfc/pn544.c:356: warning: comparison of distinct pointer types lack=
s a cast
drivers/nfc/pn544.c:377: warning: comparison of distinct pointer types lack=
s a cast
drivers/nfc/pn544.c: In function 'pn544_write':
drivers/nfc/pn544.c:463: warning: comparison of distinct pointer types lack=
s a cast
drivers/nfc/pn544.c:485: warning: comparison of distinct pointer types lack=
s a cast

Introduced by commit 0329326e85aaa30fb8d427828c718d565c287385 ("NFC:
Driver for NXP Semiconductors PN544 NFC chip").

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__14_Jan_2011_11_17_47_+1100_dJ2ebAxRvHXalbkc
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNL5YrAAoJEDMEi1NhKgbsF4AH/1UIIhYxE1sE9qsyZ3E8kxAh
We6Sb7kZKanfBMpFH+fEFo/HvNiS45UI6lrMq3yxk12vlUM9gvhaU7nvUE/CtVha
FM1RvFaIpZ2ntaV7Rzx08/7HmOQ8tHvUJbjaaExoHTq23mitabTVRcSd1pT+iDuK
1Vuejb9+xzex/Sz28DfFXy6pmFKR2lwIOxS8Usbye7K/y+hOyLx4aDLIxocjwdoI
RNm0LOXnNtXi8wVUiU39iPPZgH9Yq83FIlrVbwG1lrPGZ2OeBpzkkP0BZdPX6IQZ
Mozh6M1Ra28U44fNude1HXfGH0Lq99QtKNb/g865W83iYsRqCAL6kOamDy5tvNQ=
=uWDc
-----END PGP SIGNATURE-----

--Signature=_Fri__14_Jan_2011_11_17_47_+1100_dJ2ebAxRvHXalbkc--
