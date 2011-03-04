Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751799Ab1CDFjN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 00:39:13 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60466 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751243Ab1CDFjE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 00:39:04 -0500
Date: Fri, 4 Mar 2011 16:38:56 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans Verkuil <hverkuil@xs4all.nl>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-Id: <20110304163856.7ce5d15d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Mar_2011_16_38_56_+1100_4h3BMBhd+B/Sof=C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Mar_2011_16_38_56_+1100_4h3BMBhd+B/Sof=C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/dabusb/dabusb.c and drivers/staging/dabusb/dabusb.h
between commit f8f4a7f5c1219571acf55f3889138b594e5b3b68 ("[media] dabusb:
remove obsolete driver") from the v4l-dvb tree and commit
868788278eaa5b841ec1a810b41e156f5fba0ab5 ("Staging: dabusb: fixed coding
style issues") from the staging tree.

I removed the files.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Mar_2011_16_38_56_+1100_4h3BMBhd+B/Sof=C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNcHrwAAoJEDMEi1NhKgbsf88IAIMo6QqKIy62W29k1O8CwifJ
t6Ne/JcR088/nEmyjCUMnBkraa0FVfzeV5D+N2M4ecwutxkeOGBqJjnd9TUoYYcL
f+wS58y52gMgOYJRbmUN+JyVgsW6sHQ0Rgvpw0ZWs3yz35tUFvz4se1w7Gx0XuUi
EObWOu1v79TJ0T70ccRQDcEhE10sQS6B77f3So6hLy0Yn9nzzYfWyhylbP14eSQX
cJ8PF6xp1IhzLjeTGUTbaSA2d92MH4mU1roB7a2guZ8+lCqIaaP4+UZzzIC+uSZq
sT2iOTGo7SGWmK+5QewTZ75Yt+SQU/0W62BFHKeJvTBFRAhheRlEEuPMoaXC870=
=WBgu
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Mar_2011_16_38_56_+1100_4h3BMBhd+B/Sof=C--
