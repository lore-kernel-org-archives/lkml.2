Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756987Ab1D2CAJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 22:00:09 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41732 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753026Ab1D2CAH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 22:00:07 -0400
Date: Fri, 29 Apr 2011 11:59:48 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Jiri Kosina <jkosina@suse.cz>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Joe Perches <joe@perches.com>
Subject: linux-next: manual merge of the trivial tree with the ux500-core
 tree
Message-Id: <20110429115948.e949234b.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.24.4; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Fri__29_Apr_2011_11_59_48_+1000_V/PGJz6JuqVF6Qxt"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__29_Apr_2011_11_59_48_+1000_V/PGJz6JuqVF6Qxt
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Jiri,

Today's linux-next merge of the trivial tree got a conflict in
arch/arm/mach-u300/gpio.c between commit 4a5a6e2804a3 ("mach-u300:
rewrite gpio driver, move to drivers/gpio") from the ux500-core tree and
commit b0c3af5ef0d7 ("arm: mach-u300/gpio: Fix mem_region resource size
miscalculations") from the trivial tree.

The former removed the file updated by the latter.  These updates should
be applied to drivers/gpio/u300-gpio.c, now.  Joe, maybe you could update
your patch and send it to Linus Walleij.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__29_Apr_2011_11_59_48_+1000_V/PGJz6JuqVF6Qxt
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJNuhuUAAoJEDMEi1NhKgbsq+8IAIDhETJ3vXMla55Vkj4htRrx
/imESuyqd2pM/30KrVJXUGaXeF+OCXbuEeMEmQuuggxNHvB+R2/TOV9vSeNoR80U
OX0TbiCg7xzqYbsQnMqRZd6YDDpkv7oyVfiJaW8G1/2u6mI7c6E36TdlrsVvNWTx
JjG7dp5uhjGnlXqNaK9EcBdbNSwKepToWFrd/HBKnWyTYeBQ9dP1RdpGG4NID7EK
Ninlzof2lYRSLZt6Y3zR7QJV24SKq9aof0tRVZ4up8PBS3Xh9CFPqPipaOVFlM+8
6U2TRfC+jEDNHBqrF5eKvX9Ws7o9usyjBBBXsoCZjBSbocQN0sEiUTXzlPS3AvA=
=AXcS
-----END PGP SIGNATURE-----

--Signature=_Fri__29_Apr_2011_11_59_48_+1000_V/PGJz6JuqVF6Qxt--
