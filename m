Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752118Ab1LFSyj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Dec 2011 13:54:39 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:46502 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751320Ab1LFSyi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Dec 2011 13:54:38 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 6 Dec 2011 19:53:53 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: "Luis R. Rodriguez" <mcgrof@frijolero.org>, linux-kernel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        "John W. Linville" <linville@tuxdriver.com>
Subject: Re: Is linux-next.git bisectable?
Message-ID: <20111206195353.6f9a0881@stein>
In-Reply-To: <20111206113346.57b3efd85780b6ff18076e9c@canb.auug.org.au>
References: <CAB=NE6Uz_gXkY3HGXeW1OnPx84fPVUP=gOJ=2NjBtPZhW=_Bbw@mail.gmail.com>
	<20111206113346.57b3efd85780b6ff18076e9c@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/AHyV82=nPg_qenBHBr.IXb7"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/AHyV82=nPg_qenBHBr.IXb7
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Dec 06 Stephen Rothwell wrote:
> On Mon, 5 Dec 2011 16:29:36 -0800 "Luis R. Rodriguez" <mcgrof@frijolero.o=
rg> wrote:
> > is the linux-next.git tree bisectable? I've noticed some trees are
> > not. For example wireless-testing.git is bisectable but only between
> > master-$(date) tags.
>=20
> Within any one day, the tree is bisectable, but not really between one
> day and another.  The tree is rebuilt starting from Linus' tree each day.

The individual trees that are being submitted to be pulled into linux-next
*should* be bisectable though.  This is because only stuff is meant to be
shown to linux-next for which the question
   "Cross-tree integration testing ignored for a moment,
    if Linus had a merge window open today, would I ask him to pull this
    tree right away?"
would be answered with a firm Yes.
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D-=3D=3D =3D=3D-- --=3D=3D-
http://arcgraph.de/sr/

--Sig_/AHyV82=nPg_qenBHBr.IXb7
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAEBAgAGBQJO3mTGAAoJEHnzb7JUXXnQ73cQAIkEU/+SIs3nM/jG5ZOH9VkQ
mqrdpQnPfZlkaOcfaWiLKNbCQrk1s+D1DcB5NoMv4DI0gDx6rW45uDrlMB2Re8ab
M4IkaMmxA2TnzO7UyiDH57vaTvfxtwjCpzdEdpxANZ58Zk1IaDsTq1udEfIzVh54
Wwk0647VhjsQ4S74LH0xk89CbFRrMq/ACeolkK+YHC4vx12VLMsE/UUuyoowBZkV
8KcNqhFIq3dpbc7PzVsdyOFmt+Jn3ujxd6F/1n84w+R6ruVoX8AmqxUHJlsGaT3c
smXoLZnKJIrQzjHka06FIE2c8HLnXArgdyinYyQyELdv9cuiJyLb8PITrXPD6CTS
L9iamwcU5EGuSy8GHHSkaHmr3UAvgAq8ZHbAgY+PX6b1wBg+58JR4TBcbZEhjFfO
HxP1/M9k1NIYJxd2xRJoqinth63ixsS7LNwmojjKSf18NGXxgOOZk6WKvoEahRnx
j/gPJTzY80CAUW2VZRqqolhSuCZES4/WhemCjPn8e6U0hEbWi7DMG6/w/bJNcdky
PvS9/4I2xpFnzy7lU7qeNy2bETanC4RtMIj9s18gavol6GNitiNrOuXZijovjl5j
QijlqiVzIssvhY97dtDTK68LHpji2v/wTTgpIUoys7PEMesJ9G/0WdfcskCHrL7H
qzoNry+xHM9RKPRnru8Y
=yRND
-----END PGP SIGNATURE-----

--Sig_/AHyV82=nPg_qenBHBr.IXb7--
