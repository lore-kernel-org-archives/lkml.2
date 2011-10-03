Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932565Ab1JCUhd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 16:37:33 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:38448 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932210Ab1JCUgs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 16:36:48 -0400
X-Sasl-enc: iVhI/EiGEekjaasucfY9mmzp2f64I+OGnTV7T/e3+cLi 1317674207
Date: Mon, 3 Oct 2011 13:36:34 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org, lwn@lwn.net
Subject: Re: Linux 3.0.6
Message-ID: <20111003203633.GD22113@kroah.com>
References: <20111003203537.GC22113@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="AH+kv8CCoFf6qPuz"
Content-Disposition: inline
In-Reply-To: <20111003203537.GC22113@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--AH+kv8CCoFf6qPuz
Content-Type: multipart/mixed; boundary="cPi+lWm09sJ+d57q"
Content-Disposition: inline


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Here is the 3.0.6 incremental patch, to be applied on top of 3.0.5,
signed with my stable kernel signing key.

thanks,

greg k-h


--cPi+lWm09sJ+d57q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="patch-3.0.5-6"
Content-Transfer-Encoding: quoted-printable

diff --git a/Makefile b/Makefile
index eeff5df..7767a64 100644
--- a/Makefile
+++ b/Makefile
@@ -1,6 +1,6 @@
 VERSION =3D 3
 PATCHLEVEL =3D 0
-SUBLEVEL =3D 5
+SUBLEVEL =3D 6
 EXTRAVERSION =3D
 NAME =3D Sneaky Weasel
=20
diff --git a/drivers/gpu/drm/radeon/r100.c b/drivers/gpu/drm/radeon/r100.c
index 830e1f1..7fcdbbb 100644
--- a/drivers/gpu/drm/radeon/r100.c
+++ b/drivers/gpu/drm/radeon/r100.c
@@ -773,8 +773,8 @@ int r100_copy_blit(struct radeon_device *rdev,
 		radeon_ring_write(rdev, (0x1fff) | (0x1fff << 16));
 		radeon_ring_write(rdev, 0);
 		radeon_ring_write(rdev, (0x1fff) | (0x1fff << 16));
-		radeon_ring_write(rdev, num_pages);
-		radeon_ring_write(rdev, num_pages);
+		radeon_ring_write(rdev, num_gpu_pages);
+		radeon_ring_write(rdev, num_gpu_pages);
 		radeon_ring_write(rdev, cur_pages | (stride_pixels << 16));
 	}
 	radeon_ring_write(rdev, PACKET0(RADEON_DSTCACHE_CTLSTAT, 0));

--cPi+lWm09sJ+d57q--

--AH+kv8CCoFf6qPuz
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIcBAEBAgAGBQJOihzRAAoJEDjbvchgkmk+GrQQANQxEQRM4P3Jc8HLYMYJx3Va
ZGvVUHTbOi2GSrWh/N3CqgPDP/j6e14unKEe5HAZfp45GDUkTDB1oCwFucs0TlGR
tyUqaoDFTPdaOP6nKywpjyN3LrBZYiiIP3akjCT/GC+DhUqLLU7CYgFW10w2m5HU
k/3hZ23dS1fVnTkBqrzUXYnSW4014CXWeAw8KgjOQPJtPGzP3H5m0hkpGpzPuvhA
A2wmgzjVqxhkvidiqBH/5RGiHa67HUAqEFEpjVxyUEPtXT3VIsCkikU/v34VPak0
6Q6LTSscI7zR6pdRdyvc5Es46h5LzORUnUzQu54M1eYttgfl7/t4TxSjIpCwBF7m
psZlckltnZU12reX7/a/EHXv5IBESa9mr/oh36FpWYn2ltz9Y0JVW9IkSjHLCJJC
9AshyKfQpDYaoncE1S+yu22EYha5zoWBx5l5pYGXMqLyGb/9o27YI/a4WD81E8GF
RueAKsYnLKK4HGXXGk/5dWRJK60M766PI62UzDyBJelH7xYDI/NHeH4vfs8xpGa+
mErOiohwLeAB7uZACA2TnEz0KBp1yK47JjRjClPumxZky+vqiKpFRF6Leq5NGZjC
M/SOy/AeJI+4W4G05gYBxS0jXf6j9q+HsyeQEzNVzQYOR1WfnMPLIqZQ32++2zDc
cmNXvmWq2iCAX9twdpUr
=iC9V
-----END PGP SIGNATURE-----

--AH+kv8CCoFf6qPuz--
