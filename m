Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756476Ab1GRAq4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jul 2011 20:46:56 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:52560 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754979Ab1GRAqz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jul 2011 20:46:55 -0400
Date: Mon, 18 Jul 2011 10:46:46 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jean Delvare <khali@linux-fr.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failure importing the jdelvare-hwmon tree
Message-Id: <20110718104646.c6b59b75792a1688d079fa28@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta1 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__18_Jul_2011_10_46_46_+1000_UM5=cHOTamD_DQGD"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__18_Jul_2011_10_46_46_+1000_UM5=cHOTamD_DQGD
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jean,

Importing the jdelvare-hwmon tree failed like this:

$ git am ../quilt/jdelvare-hwmon/hwmon-max1111-improve-memory-usage.patch
Applying: hwmon: (max1111) Avoid extra memory allocations
error: patch failed: drivers/hwmon/max1111.c:224
error: drivers/hwmon/max1111.c: patch does not apply
Patch failed at 0001 hwmon: (max1111) Avoid extra memory allocations

I fixed up the patch ('&' needed in call to mutex_destroy).
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__18_Jul_2011_10_46_46_+1000_UM5=cHOTamD_DQGD
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOI4J2AAoJEDMEi1NhKgbsiQAIAJLUeKIvfV5hpHxGsr4u2j/Y
GtQAgRMOjtG+aF0p91SMGYxNUJJHoU6Me3cSyocSbaUbJxQ9bfYt9/wpOwF/FbbF
H+xF/SRAB3D5vRXpH3/BFvnwQvI5FfbxNLJuKsmDOXngyNpQyK8tI4ICBz8IM7aj
7MOM1ag7ErV9k66kUCxTmR0uhteKpQNT9sIvgF+7MnitBZRR3+IQgn/hCQiVdrCm
THkeCENTymqFnIElvnGIfQ2iwldQyA52IsVhSXpV7Z30L0jvY53tI8+agrCa8ZKi
sjPPHV5YYa4UU1fudtE+q39FsGn//qhJAiuEIEvAbYtYXw48jCfLSA/B7vMI7qg=
=bCH6
-----END PGP SIGNATURE-----

--Signature=_Mon__18_Jul_2011_10_46_46_+1000_UM5=cHOTamD_DQGD--
