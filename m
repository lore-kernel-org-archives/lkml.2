Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab2ISBpa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Sep 2012 21:45:30 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:51409 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752646Ab2ISBp0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Sep 2012 21:45:26 -0400
Date: Wed, 19 Sep 2012 11:45:20 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Gustavo Padovan <gustavo@padovan.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jaroslav Resler <resler@cs.cas.cz>, "Cho, Yu-Chen" <acho@suse.com>
Subject: linux-next: build failure after merge of the bluetooth tree
Message-Id: <20120919114520.458f75082ccf2a664547d386@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__19_Sep_2012_11_45_20_+1000_cpbpIlM4lHRRoJeU"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__19_Sep_2012_11_45_20_+1000_cpbpIlM4lHRRoJeU
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Gustavo,

After merging the bluetooth tree, today's linux-next build (x86_64
allmodconfig) failed like this:

drivers/bluetooth/btusb.c:100:2: error: expected '}' before '{' token

Caused by commit 493969cf4728 ("Bluetooth: Add support for BCM20702A0
[04ca, 2003]").  That wasn't really well tested, now was it? :-(

I have used the bluetooth tree from next-20120918 for today.

BTW, why is that commit not signed off by its author?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__19_Sep_2012_11_45_20_+1000_cpbpIlM4lHRRoJeU
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQWSOwAAoJEECxmPOUX5FECIkP/0a6u5TrEUxRD+EtIKjnlScB
/mVQWuiyzbqTfIiUBNDO2D9bdELIGCEXH5LDh9iPW3FZAh5MjfRhoW54djhAQWac
IyXikyAaQQ5gJxfaX+E+zkAfAzS4wm85wIJeS1chi5UnBiycmmBiWCbs+NajV9M3
LPsOkaQI8pW+2LiPsN0WCGOt2JMe3IpixN+LbMgfDEXmT/qw/TMFzUEbuLxcjA7h
jkc5KZj65f7bhs50CH53tvvz9BBGOxJZHMDNdtsL4GHMr6g5xonzGvg+EWnciG8y
xHJ7PpE7sUmEAsh8ldbER4jdEzsnywCpKBftzRjGezDgAaPDU+8QKkU53EneOyeu
Q0tqrRR7TvLzkSHo/tGdFYA92xqTPjRdA3S1D/KYwJ3WnsNh1u0qiQt3Wldc+NyC
BVBL62owV4JYQsxV96CZAA2qiNBXsAVHk0cTvRrM3IJVZ524qpXIbA48CpEg7r+b
i9SQImYbTd3HSGosyavsaJsXeNPu+CReZdaYTjGxNDcv6X/hHXcXJyvnQF0alqRR
+WoDOV78zJ+3BIteFgI6caVfsIa5zZIsQGf4qNz35Ich4tSvqI9mfMYN2g1CMO9r
z8XBIUSEBSMxz40Iey3nC9yfEAQ0NKGxQB5N6Ahfux26g6GXM3+mQpDKRUlBx0GD
huBSdErRtAtDUcx8KM94
=sct5
-----END PGP SIGNATURE-----

--Signature=_Wed__19_Sep_2012_11_45_20_+1000_cpbpIlM4lHRRoJeU--
