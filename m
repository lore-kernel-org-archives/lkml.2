Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756309Ab2J2AOR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 20:14:17 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:40963 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754906Ab2J2AOP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 20:14:15 -0400
Date: Mon, 29 Oct 2012 11:14:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        =?UTF-8?B?IkRhdmlkIEjDpHJkZW1hbiI=?= <david@hardeman.nu>,
        =?UTF-8?B?IkJy?= =?UTF-8?B?dW5vIFByw6ltb250Ig==?= 
	<bonbons@linux-vserver.org>,
        Jiri Kosina <jkosina@suse.cz>
Subject: linux-next: build failure after merge of the v4l-dvb tree
Message-Id: <20121029111403.911c815a3c7d8d9572ff8e89@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__29_Oct_2012_11_14_03_+1100_MJl4MOzS4h3t.S_z"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__29_Oct_2012_11_14_03_+1100_MJl4MOzS4h3t.S_z
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Mauro,

After merging the v4l-dvb tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/hid/hid-picolcd_cir.c: In function 'picolcd_init_cir':
drivers/hid/hid-picolcd_cir.c:119:27: error: 'RC_TYPE_ALL' undeclared (firs=
t use in this function)

Caused by commit c003ab1bedf0 ("[media] rc-core: add separate defines for
protocol bitmaps and numbers").  The new reference was introduced in
commit ae08e324146c ("HID: picoLCD: Add support for CIR") which was
merged by Linus on October 2 into v3.7-rc1 via the hid tree.

I have used the v4l-dvb tree from next-20121026 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__29_Oct_2012_11_14_03_+1100_MJl4MOzS4h3t.S_z
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQjcpLAAoJEECxmPOUX5FEHhoP/RprIPOvlq2BBIX0xIsfP7H4
x80jF+VN46+7yj175II/8Ko25t7W1q7CojKo9xbKGPyXKywYoxcV0sAaWb46uowM
fwZJJKMvS5XnXdOL2StHAqzSHD9Qx1Iwk0hOYRtllNBwGU1kgtvmoLS2TANZKSjI
aCwO53g6YROT9Be11A/vxb64SRp2ECkfPVsSCQXu7ILkm6FC+MO1QEwpOfiooSZh
0P+RyU+Dc+BS8Wl8O759LhspIBThA3Qa7QmLJAwn0CPe77PhGAQh7W/R++HUhJzZ
8L7utwPlmoTdaxtLidilrdInvTPoo+uz4z7gbBj6LLYThxDaQe3Ju6t3BryEJOiz
mRioF5Dl+wfrNP+YY3DfqNlBbTVZ3/3qAe5sCtyTuC5gS7DPXbjYZvR3Tza1S6+c
S986Itcw++k77AfL0IZqkuC6iAPQz7WZ2JG5Ak/FY1FE+Mw706k3pg4tOwcOixVG
pG9h6m84Kz2vjj1BjEyIia7t50J3V253CG8Bc4wz2vwZ/E61GGSpW7PGaVYncrOI
rnUJae2C74XCKTd1A9riW2VTR70yBmqE/oFJYfmYgx0Bh670ZpY0bWsyZ8YBxaVt
zsGaXE6dAZBh3QSAQyqMexRpAWintYeFg3W0rBXzF+DwOEVKwismU3+d3l7aehlH
K7rAwrKxBt/DwbkSh7tX
=ZCKF
-----END PGP SIGNATURE-----

--Signature=_Mon__29_Oct_2012_11_14_03_+1100_MJl4MOzS4h3t.S_z--
