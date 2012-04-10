Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758508Ab2DJDGy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:06:54 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:44320 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753319Ab2DJDGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:06:52 -0400
Date: Tue, 10 Apr 2012 13:06:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Karsten Keil <isdn@linux-pingi.de>
Subject: linux-next: build failure after merge of the tty tree
Message-Id: <20120410130637.d9aff141830a3eb71ff21440@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__10_Apr_2012_13_06_37_+1000_bUPyR=PBGOomClEe"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__10_Apr_2012_13_06_37_+1000_bUPyR=PBGOomClEe
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

After merging the tty tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "isdn_tty_revision" [drivers/isdn/i4l/isdn.ko] undefined!

Presumably caused by commit 1ca6711ec001 ("ISDN: i4l, remove cvs crap").
That variable is still referenced in drivers/isdn/i4l/isdn_common.c.  Grep
is your friend.

I have used the tty tree from next-20120405 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Tue__10_Apr_2012_13_06_37_+1000_bUPyR=PBGOomClEe
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPg6O9AAoJEECxmPOUX5FE7zgP/irmd/hN/6l2KW8QmUpuaCQI
PdkilCkZH4+maPhZlBFai0z5xkJE5UM2IzAvp4lbhNQMYs4qJRIVimLIJ8JHyBmM
VVWFZWmlOE7BN1eibeGIbQQvW2pi7XdbqzOOgdLHbuJtlMwaLfTGII1W2rv8tHy6
4lSvMEGMRrR/nrTwO+iIGKfercx1ZVHeUy/gVzL5NGEezGzjl5D6mXuDmjra72FC
rzS/pa7/BHHXEj5VdbtIpt0oC95v9QW+KWYITRAYsfceSxUf+sWj/8EDVprmZwu9
CJTAiwpkGi6Z2YudPksmMrOVb1qTj4aYhcY3ld54u5vmeJ+axcJxPGOYpYNMVS9i
L6LjpPSYCTAfHAvimVoz7mir+R1Oi0lDgCnTwP23WJr8xG1K2LSw0p4+KHEN/cbe
6NfqsHlDSSNc7wd1GnRgiWwKVdSDxW1rGINsNLaoWxJlv672IG0N6Y+gfBZmoOM8
J0wur6WXkY0mc6yN6nsGxNcdAPxb6uXT1+UzvFkpBghHdnIGmg9+xOiNh8fUvYVX
X3Ymq26iJG9g5TATCiCcvE4Up8PTiGxKrRhJoqNemw4BkUqxU/KUTxCrN0/DSg3w
sfFaOyda2q6DHEFnmy8per+lN0NGmrqIP1ep8TaQZ0SDcUxuTGKcRCv0nfaHSTnI
ovq6ftcLAw84XDJzhde8
=3haH
-----END PGP SIGNATURE-----

--Signature=_Tue__10_Apr_2012_13_06_37_+1000_bUPyR=PBGOomClEe--
