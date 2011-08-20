Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755383Ab1HTXnQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Aug 2011 19:43:16 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:50238 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754697Ab1HTXnN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Aug 2011 19:43:13 -0400
Date: Sun, 21 Aug 2011 09:43:02 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Ralf Baechle <ralf@linux-mips.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build warning after merge of the mips tree
Message-Id: <20110821094302.e46933704cd74ab7728bfc74@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Sun__21_Aug_2011_09_43_02_+1000_fdQIzhQKGSXp6cb0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Sun__21_Aug_2011_09_43_02_+1000_fdQIzhQKGSXp6cb0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Ralf,

The mips tree today seems like a complete mess.  It seem to be some
historical tree including commits with commit dates going back to 1994
and v1.1.68!  Please fix it up as it is unusable in its current form.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Sun__21_Aug_2011_09_43_02_+1000_fdQIzhQKGSXp6cb0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOUEaGAAoJEDMEi1NhKgbsYyEH/icVRBiOF3bx81+pw5WuGsod
jqSOP4SmL/L/wcJruHtn5nhG1l4BUfOVumwpQWk8dCssPnRy/zwWcSYLcN/XsoIF
0liVSZ3wohAFwk5/oX/Pnp6v/3+U3bKD46O6WwGcFcfLh57e9jtYf4ajRSn55xT5
hqTi05KgO2KX1Z453UKnh4v1e2welX2Bp/66Ox8pWFlv/9uT5tNJi05oWL1VwVGN
5f7UsqeO5Ze3uscwmF97nk2LJr/7xIl5XAVOy66oJOuNCfjSpWRLVkorSD4JEDvy
fqq/iquynBDkzObnoKrstvhYYbHX4/fQ6RPKRnYDPwC7CZeh5LmoDhYURCFnADk=
=IOQG
-----END PGP SIGNATURE-----

--Signature=_Sun__21_Aug_2011_09_43_02_+1000_fdQIzhQKGSXp6cb0--
