Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757969Ab2CPCxP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 22:53:15 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:58784 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752830Ab2CPCxN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 22:53:13 -0400
Date: Fri, 16 Mar 2012 13:53:03 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Dave Airlie <airlied@linux.ie>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the drm tree
Message-Id: <20120316135303.7ad016ef3e29eac06027658e@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_13_53_03_+1100_5/b7JtvlGiIQ9tjK"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_13_53_03_+1100_5/b7JtvlGiIQ9tjK
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

After merging the drm tree, today's linux-next build (x86_64 allmodconfig)
failed like this:

ERROR: "drm_usb_init" [drivers/gpu/drm/udl/udl.ko] undefined!
ERROR: "drm_get_usb_dev" [drivers/gpu/drm/udl/udl.ko] undefined!
ERROR: "drm_usb_exit" [drivers/gpu/drm/udl/udl.ko] undefined!

Caused by commit 5320918b9a87 ("drm/udl: initial UDL driver (v4)").

I have used the drm tree from next-20120315 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

P.S. on the bright side, I didn't get any conflicts in the merge ...

--Signature=_Fri__16_Mar_2012_13_53_03_+1100_5/b7JtvlGiIQ9tjK
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYqsPAAoJEECxmPOUX5FEoSYP/RIk7W0zvCIVa6557G62zZoT
H8TF9f1PURB+qDIos9WUvcWR8IAKgBfcuchqkxJwNaZIhfLhzTXkfuOZOXhC1594
Tq3VqcwUpuxfczT8f2vxjChrsZ6VhAW9KesvXXM3vSENr1C3UnVHf9OQp/QP2GPK
8YZfJFHa+tavo0TvNJnwyXNx8xnUMXIgyfXyhMpvUriM0CcrroPbkMwcYAlVhyNB
AvVDfhXmsMs263ZjCebi1EF0M49e8cHoeTK7zfkr9X2d2L8SuedQI07tzve3K4K3
Wcm8Y6xxTe8TRXYGjrAxFat2DOBzmQO3pkURo9DvHp2KO4frydYRSvMk/pAZ+8/v
aJUTqkR0XUXvggTq9wnTqxeM1d1Zm0pbt2LGDrjZEkqC0gKwVPM+AIxM980mNDbp
m8VlmO+zxfJ/dKLYF3ykfBcApVFtjXgTHh4UhhgIv+/Dc9/OI+3iJu2FWyNIGAV2
GIKFoz3tNU55tdSkQ3CNAdSWvkv6w5GSyY/i1JVn+dh4pqZfvhCmmrp7auATznKy
Yw3JkcYuJlLQg1iE8pgx81bxgVPfQV4OKKoncsRxKrb4gclxFlN0ohSp3zhLJA9v
DsrtXYWUlAop1gWI+s53BdOrM4Xn+4wdR42vhVvGOvyMcr0r7S5hyDTeoSpqOq9c
qRgWFEUIbLsDUGIW7jFb
=aJZU
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_13_53_03_+1100_5/b7JtvlGiIQ9tjK--
