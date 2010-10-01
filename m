Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974Ab0JABlM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 21:41:12 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:40866 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751046Ab0JABlL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 21:41:11 -0400
Date: Fri, 1 Oct 2010 11:41:03 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20101001114103.c6fb755e.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__1_Oct_2010_11_41_03_+1000_CyKqto_mMWwoVC1Q"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__1_Oct_2010_11_41_03_+1000_CyKqto_mMWwoVC1Q
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

usr/include/linux/ivtv.h:26: included file 'linux/videodev2.h' is not expor=
ted
usr/include/linux/keyboard.h:4: included file 'linux/wait.h' is not exported
usr/include/linux/matroxfb.h:6: included file 'linux/videodev2.h' is not ex=
ported

Presumably caused by a bad merge 770a34e607ff7f5ecc72956a007d01f7f21175bb
("Merge tag 'v2.6.36-rc5' into new") which has mucked up include/linux/Kbui=
ld.

I have used the v4l-dvb tree from next-20100928 again for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__1_Oct_2010_11_41_03_+1000_CyKqto_mMWwoVC1Q
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMpTwvAAoJEDMEi1NhKgbsC5IH/0Hek1ucz5Q0owWYX3+WsmpV
BchO0RR3SMjrJV+9psYHiELB6RODBxo0QyuDKQbPFHslQNWAAl/N4VmnXZtC1Avt
q7bknxpPZQ4wzXZXewrkyIjYfl9/7xbu9Q/iQxuZv3NrfxBcf9k4F/A0jJIHELwn
ckFrpYv/onf6nRWJ2QyGFFlqW0uRrgufbvSJdcRN4OutwFWvfnrqI5H2y9j1YxuF
Ptmkn4DYl8gYQUm6EuXxySpGq6dNvIWO0j/G//ylhGX9iCNlxENFqLzWWB+Eb8ea
FihoSDVBEIZhf9mLKPmmu9jspQFRcc6tESJT0FOuQi97A0P1nZpUy3XwLesSdhY=
=TifT
-----END PGP SIGNATURE-----

--Signature=_Fri__1_Oct_2010_11_41_03_+1000_CyKqto_mMWwoVC1Q--
