Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755316Ab0LMEpD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Dec 2010 23:45:03 -0500
Received: from chilli.pcug.org.au ([203.10.76.44]:59458 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755020Ab0LMEpC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Dec 2010 23:45:02 -0500
Date: Mon, 13 Dec 2010 15:44:44 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>,
        <linux1394-devel@lists.sourceforge.net>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Clemens Ladisch <clemens@ladisch.de>
Subject: linux-next: build failure after merge of the final tree (ieee1394
 tree related)
Message-Id: <20101213154444.eba34b5d.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__13_Dec_2010_15_44_44_+1100_=s941E.0OQ=BuNJX"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__13_Dec_2010_15_44_44_+1100_=s941E.0OQ=BuNJX
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

After merging the final tree, today's linux-next build (powerpc allyesconfi=
g)
failed like this:

drivers/firewire/ohci.c: In function 'ar_context_release':
drivers/firewire/ohci.c:635: error: implicit declaration of function 'vm_un=
map_ram'
drivers/firewire/ohci.c: In function 'ar_context_init':
drivers/firewire/ohci.c:961: error: implicit declaration of function 'vm_ma=
p_ram'

Caused by commit 713c11a3fd56c8324b5cd63d02cb270866095ea4 ("firewire:
ohci: Asynchronous Reception rewrite").

I have used the version of the ieee1394 from next-20101210 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__13_Dec_2010_15_44_44_+1100_=s941E.0OQ=BuNJX
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJNBaS8AAoJEDMEi1NhKgbss0YH/3s+/TtkIvA6hzPjcr6z+C7T
tILd9yboy7lFmpVq8EnvBPp4orNfHv6rgms7fd7SnnBUgX/T1S75d24bL84XowXd
eJpmVIyUNmc1x7Iz/Yljzpn7goXJEGyfR8QwFWRWlbYzx7dAiDg1J7jt2ezdc5zq
ajunspNv9D7vkjEWVMVyJUPGB6pcivjRpOroJpjsxlepgAXqJvwkCWwjFgBaO/4u
tpFh5vJTkTEWCe/wWOC3yKNNz30uDh5YhtNaQOzKwiama/21zn5Q4IThqdo7ryvp
v9VAKYYuFIsVY62YonMfuXvCwOQO1YHGtdC2UWdDwt31hUY6BqrZKGfeF+kdE5M=
=9pIQ
-----END PGP SIGNATURE-----

--Signature=_Mon__13_Dec_2010_15_44_44_+1100_=s941E.0OQ=BuNJX--
