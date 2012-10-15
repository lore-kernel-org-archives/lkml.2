Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752908Ab2JOAld (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Oct 2012 20:41:33 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:34051 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752377Ab2JOAlb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Oct 2012 20:41:31 -0400
Date: Mon, 15 Oct 2012 11:41:29 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Alexander Graf <agraf@suse.de>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: linux-next: build failure after merge of the kvm-ppc tree
Message-Id: <20121015114129.c5be2be04e44043682b6b661@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Mon__15_Oct_2012_11_41_29_+1100_wG8cmxry.uWZ6yeG"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__15_Oct_2012_11_41_29_+1100_wG8cmxry.uWZ6yeG
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Alexander,

Take into account that I removed the top two WIP commits from the kvm-ppc
tree before the following ...

After merging the kvm-ppc tree, today's linux-next build (powerpc
ppc64_defconfig) failed like this:

ERROR: ".kvm_irqfd" [arch/powerpc/kvm/kvm.ko] undefined!
ERROR: ".kvm_irqfd_release" [arch/powerpc/kvm/kvm.ko] undefined!
ERROR: ".kvm_eventfd_init" [arch/powerpc/kvm/kvm.ko] undefined!
ERROR: ".kvm_ioeventfd" [arch/powerpc/kvm/kvm.ko] undefined!

I have used the kvm-ppc tree from next-20121012 for today.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Mon__15_Oct_2012_11_41_29_+1100_wG8cmxry.uWZ6yeG
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQe1u5AAoJEECxmPOUX5FExTUP/1uMy+0ALyVkYETdwnLGoy3h
A4myTrpR5oL1Ao/VZXG6vCYjTDOhlQLlq0/99lN6e4itiQGZEbNuu/Z/wjYTBAad
Nl+ecjjZrMdQ/n3lXKseeXIU0Hzt3b5d2aUGX0bLMArpz9zYc02jrWTJ8Yi+dnyh
eKT5wsqGPDgtwAHNL07yKNIeKleGQR7wNiZMw8OZS8v36oelIumrtmQpjZIIdLnV
ZMaeJpzBlljyglPANIAyOVZduAdiE2+jjhujtT0inbifMDtVS3AEoGVqVH+3T4Pu
wCP5bYy9TYsj02u2adwZR8tmg4946fZNH6I60sUiF31LA41tdS41IJXw+FR7pIos
k3JiaP8oNygVsWBBNAt9ItsHu952SGESuEzOpVvpmgdCqcng07+6Jf+PlavYUksZ
emAguM+mddRQ1oX+L9rXbFdpTXoS+EH+ECNk7d+1W08pbd0we6xptIIQUDNeISz7
Z1z0ztngH56kecoBROypA9fx4mLUDGByol7NYVI/OS0OE/ouXxNmZM+dsQrDMOe1
nt4+aRF3FRIf7k5z+RZYZu3Xk4aR2GgABlLf6GU1JJrLTnoF/I7PfZ1DnG2xChiY
LU+rryeOmasodkki150qeg9Nf5cyAE2E+fZhBiTRJn6M0gmraXwDdmlZ6uqyJtrI
1BVSrEcoGEjFCP1R2Uqp
=JK+H
-----END PGP SIGNATURE-----

--Signature=_Mon__15_Oct_2012_11_41_29_+1100_wG8cmxry.uWZ6yeG--
