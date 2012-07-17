Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753934Ab2GQBAj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:00:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:38383 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752693Ab2GQBAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:00:37 -0400
Date: Tue, 17 Jul 2012 11:00:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Artem Bityutskiy <dedekind1@gmail.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        David Woodhouse <dwmw2@infradead.org>,
        Gerlando Falauto <gerlando.falauto@keymile.com>
Subject: linux-next: manual merge of the l2-mtd tree with the mtd tree
Message-Id: <20120717110025.35e6d8404104e77019bef6ce@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Tue__17_Jul_2012_11_00_25_+1000_5TN35iZq4z0d+gm_"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__17_Jul_2012_11_00_25_+1000_5TN35iZq4z0d+gm_
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Artem,

Today's linux-next merge of the l2-mtd tree got a conflict in
drivers/mtd/chips/cfi_cmdset_0002.c between commit 420962884379 ("mtd:
cfi_cmdset_0002: Micron M29EW bugfixes as per TN-13-07") from the mtd
tree and commit 39c0c188e160 ("mtd: cfi_cmdset_0002: Micron M29EW
bugfixes as per TN-13-07") from the l2-mtd tree.

I just used the version in the mtd tree.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__17_Jul_2012_11_00_25_+1000_5TN35iZq4z0d+gm_
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQBLkpAAoJEECxmPOUX5FEjy4QAIhMeispn4G7srzuq1Z1iIs5
6zgDBy0S8HKMN1Yw4gbHBsfrNdDhgb+dLkKEBbdO8zE42uVX7rxAP27DqbpjxtU5
C3owLBgoRLsBG0HxXk3+F86LaR3Y7Z3ugv7xWFlq58VEgpl8WnciKnjFcC7Ux7V/
k4erP518rcP3Gbq4Cqa+bD8l0WfJTXAkZXs4ZryH6Lx0DEE7j84FXD6+2bO/9W0J
s10x4NjLeS8xnkahYAhAfYDRvIF/vsL/F7C2TCRlOGnYT/EwVZfFYt9n+Uv0uVaH
+bY+OAfoIdhITwmb8yT78KFz9wpC4K6jv50pyho5Pvsa/IKFd4R/CyjhZfAOKQjZ
Sd8Isnzv7J5t37vw7iWaANCgP6E7sDSVct3D1E3p6Jy15Y+pe3E8/PmujnGAAXhy
HomV5GjIoQs+Ufi5XxQKqboX6eDVrrvnwyohtGstNBBprzqgaX5Y8z81q8WQL0x+
Qg2kZGmmGl7iS/LZ9kPuV16/6X0yOm9s70SIGOGCgTVuLvuV7zKWv7C6CWtif4BT
XYXkOfg8SFVy8oc4eUWih628+WHAE3z83UXag0oBWGypKkGED7arOxO5vKIYZ6hv
tVkXav4iiqW3pke/7bT1TS4aq3XR4XXgqLrQAQtpibOr1AsmPg115xIzXzft6YyX
a/fLL0eF3/BwAJBvtcC4
=Rohm
-----END PGP SIGNATURE-----

--Signature=_Tue__17_Jul_2012_11_00_25_+1000_5TN35iZq4z0d+gm_--
