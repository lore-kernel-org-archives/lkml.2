Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755375Ab1KHXTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 18:19:19 -0500
Received: from calzone.tip.net.au ([203.10.76.15]:47494 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750865Ab1KHXTS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 18:19:18 -0500
Date: Wed, 9 Nov 2011 10:19:09 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: failed import of the rr quilt series
Message-Id: <20111109101909.585d2406dc46af8890f28e66@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.7; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Wed__9_Nov_2011_10_19_09_+1100_=5cWu3jO_E3MBfi2"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Wed__9_Nov_2011_10_19_09_+1100_=5cWu3jO_E3MBfi2
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Rusty,

Tryiong to import the rr quilt series today produced this error:

Importing rr based on v3.1-8907-g43672a0
$ git reset --hard 43672a0784707d795556b1f93925da8b8e797d03
Checking out files: 100% (37600/37600), done.
HEAD is now at 43672a0 Merge git://git.kernel.org/pub/scm/linux/kernel/git/=
steve/linux-dm
$ git am ../quilt/rr/virtio:pci_fix_use_after_free.patch
Applying: virtio-pci: fix use after free
error: patch failed: drivers/virtio/virtio_pci.c:822
error: drivers/virtio/virtio_pci.c: patch does not apply
Patch failed at 0001 virtio-pci: fix use after free
When you have resolved this problem run "git am --resolved".
If you would prefer to skip this patch, instead run "git am --skip".
To restore the original branch and stop patching run "git am --abort".

Maybe you forgot to update the BASE?

I will use the rr tree from next-20111108 for today.

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Wed__9_Nov_2011_10_19_09_+1100_=5cWu3jO_E3MBfi2
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOubjtAAoJEECxmPOUX5FE670QAKfV68VjQdOFZBJ57O/fNDlu
wSsUgn/F9+bXu38UfFiXZHflXjeuxJTaqD5vipDF/Dp/eSr6U97LwctAdakv2Mty
ELV4RWYvFG6bFXQ6I0F1GHHoKSDoAjd2G/I5VejUz4kCtZHcGZhPbbdvUjCgNsVy
efwx2J5wsaiw3WmcMfB1pfgeio9++Y1Irf3ULvBabQJSOvvYMMa1vE7idp5ogchv
CRAaWWrUuW+L8GYaI5GGm+Qns30E6HqaXW2gsSzbNdM7/ylNpjJv4H98Yh1pl6ME
Pp9UiCHH1iFoy6Ucm3aYmAHlguXAAWaoEyb8H6Chxrt07f8W4/J5r0cpH381W4kT
4VxH5Fh0H7fjkbIsBxTjTj4zo8+FL8OheBYAsYxJ7YgG2Q5vlZ71yIh1kRjckgmX
v6nBA57qju3RQ/H+DbP09Xt1tjOKT84bbqofsQ4zgd5KhyLuUNSAzemBcRRMQjZJ
Hm+XEq3MNmqZXkSh4gY95pHmIxXSoF5glLKvr0Ch/u237poDG63RoxqPvTAUwlEE
fletJo/nAaM7Wv+QqFlxOOXbObqUzM6krR2/wVEpt0BHZInYLJa+LYKug7/Tr9Gp
C/QgjzPXK9y7JeDXwLPoGhoZSv98+8tVZ2c0pYduKXkYKIuVe/mOgZwAARcTlYui
UovEXDeRPiWV2CRgqATh
=I0Zh
-----END PGP SIGNATURE-----

--Signature=_Wed__9_Nov_2011_10_19_09_+1100_=5cWu3jO_E3MBfi2--
