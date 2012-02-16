Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751732Ab2BPFGJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:06:09 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:58736 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751005Ab2BPFGF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:06:05 -0500
Date: Thu, 16 Feb 2012 16:05:51 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manoj Iyer <manoj.iyer@canonical.com>,
        Johan Hedberg <johan.hedberg@intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        "James M. Leddy" <james.leddy@canonical.com>
Subject: linux-next: manual merge of the akpm tree with the wireless tree
Message-Id: <20120216160551.dd41d2675bab32ff23afd712@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.9; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__16_Feb_2012_16_05_51_+1100_5uYLSAHwVKqu=uBZ"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__16_Feb_2012_16_05_51_+1100_5uYLSAHwVKqu=uBZ
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Adnrew,

Today's linux-next merge of the akpm tree got a conflict in
drivers/bluetooth/btusb.c between commit 403f048a5705 ("Bluetooth: btusb:
Add vendor specific ID (0a5c 21f3) for BCM20702A0") from the wireless
tree and commit "bluetooth: add support for BCM20702A0 [0a5c:21e6]" from
the akpm tree.

I fixed it up (see below) an can carry the fix as necessary.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --cc drivers/bluetooth/btusb.c
index 789c9b5,e618cf1..0000000
--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@@ -102,7 -102,7 +102,8 @@@ static struct usb_device_id btusb_table
 =20
  	/* Broadcom BCM20702A0 */
  	{ USB_DEVICE(0x0a5c, 0x21e3) },
+ 	{ USB_DEVICE(0x0a5c, 0x21e6) },
 +	{ USB_DEVICE(0x0a5c, 0x21f3) },
  	{ USB_DEVICE(0x413c, 0x8197) },
 =20
  	{ }	/* Terminating entry */

--Signature=_Thu__16_Feb_2012_16_05_51_+1100_5uYLSAHwVKqu=uBZ
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJPPI6vAAoJEECxmPOUX5FENSAQAKI3X48I5g7m8Kmtrf4CPnb3
nJMSQFC/xb8vJrJuFe/l9+Mz3JNi7yL96Hd4GjTqZdAklkerOPDSGcUZjwnkyV2c
vUc0qh7lwWXFrARl9Q6dxznpNWMNvdroqpZ3ZkMS3ne/5uF1MaORWYQPUFpBIZXh
Nx2pSnm99Qo9uAYtIw4zPJsErs19exA4JE34cgY2G42Jd/EGSeML2T8Vvw0FoOE7
jTucktPEwWOTHLzws0NjBSDnjBqu8gqLT7Fj8/LXFeH40HlK8cdMK85BKpMQ0+Ce
6vNovA6beUJRYtl7QsuC1YYguqyhtwb5kLHnD2R/vd79S7psheiwRBH+EkWptdrD
7qmqH9EgpS3O6XeQyCnr6wVslrRd8LmyZLIsCp40PfEdzFcsXdLq/RQQ3BXwVCaR
g8PAEVE/Kph0G+kK+YvD2ugDJC6IdXWyIQCr7y081zKI+ufyDJbAL6aEcQiO8vrV
6Xr5WKmUhiSgfyYDjOYd4VK7CNLLxkipRNkd0qa5VJRo/h6xCPMh9DEt8mmm8+z1
Oc26LQHWfKMuFY8FM6KleHSzBMEWbZwr785Xep3TI161Sgdy0uAwaw/Xmi6X8+FO
0yW7U8O51iIEVU3cGT73mJZ4fm0LWuREwjU9la9IpXzEJaFQl8LHE27jNyXQPrSp
Moe6qpnQ0kN/v+h776ud
=Wy2m
-----END PGP SIGNATURE-----

--Signature=_Thu__16_Feb_2012_16_05_51_+1100_5uYLSAHwVKqu=uBZ--
