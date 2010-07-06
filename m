Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755699Ab0GFHx6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Jul 2010 03:53:58 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:44228 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753944Ab0GFHx4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Jul 2010 03:53:56 -0400
Date: Tue, 6 Jul 2010 17:53:37 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
       Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>,
       Scott Kidder <scott.kidder11@gmail.com>
Subject: linux-next: manual merge of the staging-next tree with the v4l-dvb
 tree
Message-Id: <20100706175337.bec9305a.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__6_Jul_2010_17_53_37_+1000_Q_DeX4QlKoOgOhw="
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__6_Jul_2010_17_53_37_+1000_Q_DeX4QlKoOgOhw=
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging-next tree got a conflict in
drivers/staging/cx25821/cx25821-audups11.c between commit
e302c8255a198a567dab3a4ace7bd0222a6dc037 ("V4L/DVB: cx25821: Removed
duplicate code and cleaned up") from the v4l-dvb tree and commit
231ded903f2f30b2bcdbf6672c7197187e3bb1ee ("Staging: cx25821: added KERN_
facility levels") from the staging-next tree.

The former moved all te code in this file into other files, so I
effectively just dropped the usb patch by deleting this file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__6_Jul_2010_17_53_37_+1000_Q_DeX4QlKoOgOhw=
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMMuEBAAoJEDMEi1NhKgbsQrUH/iJ7Rx3q0djQSfv1HHphjWdF
vHQPN1BLxIgGuhhl6FYw03Ay8/HEpBXWW0UtJzvgKAP5afhtG5GYEVObOdbGAbvH
y8QcYdI7cKH45MC0M+olux6kMg8Dt7hp7kW1PAc1PS2LGYz02D30UJMNatLLTCQo
Ep4Af3udyqGHx6dlckqzluhOMcOs44AXkWEWorOoxsqTxkjgOx1tabPkJe/t096b
/wGh30Wmkhz29oL+ZgLTeSd+hFAtcWJQ1Raz8UDFh34jrsWrOA7e3FlNpnrzjoHj
4hl/xh+/dHnWQBhwe8vkVPW1+mZ9/kB0Qqit3+Tl2m0tzMIOz2BYfeQI4I3jb1s=
=a0cn
-----END PGP SIGNATURE-----

--Signature=_Tue__6_Jul_2010_17_53_37_+1000_Q_DeX4QlKoOgOhw=--
