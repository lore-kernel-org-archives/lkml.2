Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754735Ab1KCCh5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 22:37:57 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:34321 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754422Ab1KCCh4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 22:37:56 -0400
Date: Thu, 3 Nov 2011 13:37:39 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: linux-next: build failure after merge of the pci-current tree
Message-Id: <20111103133739.2d81eb3bf43ab1b1272e3814@canb.auug.org.au>
In-Reply-To: <20111102190436.5b4c805a@jbarnes-desktop>
References: <20111103125325.c1e20275e3a68498465b5ddf@canb.auug.org.au>
	<20111102190436.5b4c805a@jbarnes-desktop>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__3_Nov_2011_13_37_39_+1100_HOJpbm7lwCMUTMwo"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__3_Nov_2011_13_37_39_+1100_HOJpbm7lwCMUTMwo
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jesse,

On Wed, 2 Nov 2011 19:04:36 -0700 Jesse Barnes <jbarnes@virtuousgeek.org> w=
rote:
>
> Oh I thought Randy said this stuff was in -next already...  Sorry for
> the trouble.

It is in -next, but merged way after your tree is merged.  You can't
depend on stuff in -next in your trees ...  This sort of fix needs to be
carried in -next itself until the bits get merged by Linus.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Thu__3_Nov_2011_13_37_39_+1100_HOJpbm7lwCMUTMwo
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOsf5zAAoJEECxmPOUX5FE1BwP/3L17Vco7S0jUBvNMsblHs5q
HQb0kQry40wiUkn8Ezz6A8GjPgs4QNACB/vh3BkZc+PP7pDgMWcDXRX6Zb5YVTgX
koj0OkXgO5a3oaDXZla/topIXdFz2LvEXLUt7UDwiUykCMSdbuki722eXZolgeYW
LQfu1QtH7/RYOdgaVWODuxdt5J7a/SCFulp680mUg+B4pjLBbG7fkWRuf29xp2bw
HHz8R2G7QPtHCKOg5PaXopfyQmRmleZ9IW3Bw7M0okAcu2r4qx6ewtTDseA+8Rxk
fihdcD0TE4tx7bgcS7ZJ1Z/xeg47NSmgF6opOBssBS6eQD/BHLIEtSCNNmS1ZFaZ
nIaeBgcregsNfpdfPw24SkDFM4A898cJsPGQxq/vzmIsnY6bWx0ld0nywolEYZ5R
MTpkDKJg8P6ghhEaSp/1J81/g9KcYk3aK+9zlOImmzdhq87U1ALfibQtehDqZgFG
pR7DAZGspj+J5Db/j+OifsECN852QZ4briuhG0hn1BMtGa1m8TJaf6hctKMPUUFa
nt/E9c15sl3LKX2ygMJ1cSwGmXiWQrmIiFHNyH5/Bw0vG5BSPZCIxWJiDH424hma
5TQbAP09zZeT0g76EWiMYeI4BHpprTjGK60hT2adxvpT+osJ/DhHw62P6frpSS2X
/HZEBTXpC2QAeIMv4Rui
=8Q8D
-----END PGP SIGNATURE-----

--Signature=_Thu__3_Nov_2011_13_37_39_+1100_HOJpbm7lwCMUTMwo--
