Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750911Ab1CDFiv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 00:38:51 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:60455 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750703Ab1CDFiu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 00:38:50 -0500
Date: Fri, 4 Mar 2011 16:38:41 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Greg KH <greg@kroah.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Hans de Goede <hdegoede@redhat.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Timo von Holtz <tvh@informatik.uni-kiel.de>
Subject: linux-next: manual merge of the staging tree with the v4l-dvb tree
Message-Id: <20110304163841.fa243eef.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__4_Mar_2011_16_38_41_+1100_wR+nY66=zHxpoAVG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__4_Mar_2011_16_38_41_+1100_wR+nY66=zHxpoAVG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Greg,

Today's linux-next merge of the staging tree got a conflict in
drivers/staging/usbvideo/usbvideo.c between commit
af6302700e87a883481c342001ef81b77641bf98 ([media] staging-usbvideo:
remove"") from the v4l-dvb tree and commit  ("Staging: usbvideo:
usbvideo: fixed some coding style issues") from the staging tree.

I removed the file.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__4_Mar_2011_16_38_41_+1100_wR+nY66=zHxpoAVG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNcHrhAAoJEDMEi1NhKgbsWfoIAJm7uFzHqDudxW36ypGMH7R7
N9V81DeDZZN+G0J3MKCY2eyvwsgSoc7367QUHg3Bj3aJ8zjDj+pXo4wUHfIniYaY
lhFMpdO7Zb7m4POLrHHxlgrBbP91GInU7aTbntUh0BgT1vPiAbn41bYXSUXeUy48
qZ/ITUgnQTGR+ArGpR+udd9v/AWLLBZGfLUNxTdX21+JDr/g9UUa3LUcDV8qLr6o
LhhfOZEX5E9P6a1w+D6aRV9GCYMhj+sdQTZ0Ltnh9uMcGTpeud0FXs0NW27tXTvM
0lN8F+W/n3sLzcN3YRiWWz8PnoW4lLtuHzFz9CjqoGN1TPFPU1f5/EtPiteq2T8=
=V5yH
-----END PGP SIGNATURE-----

--Signature=_Fri__4_Mar_2011_16_38_41_+1100_wR+nY66=zHxpoAVG--
