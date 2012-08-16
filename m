Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030299Ab2HPQYR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 12:24:17 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48401 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932905Ab2HPQYN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 12:24:13 -0400
From: Mike Frysinger <vapier@gentoo.org>
Organization: wh0rd.org
To: Tobias Klauser <tklauser@distanz.ch>
Subject: Re: [PATCH] blackfin: Use schedule_preempt_disabled()
Date: Thu, 16 Aug 2012 12:24:11 -0400
User-Agent: KMail/1.13.7 (Linux/3.5.0; KDE/4.6.5; x86_64; ; )
Cc: Bob Liu <lliubbo@gmail.com>, uclinux-dist-devel@blackfin.uclinux.org,
        linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@elte.hu>
References: <1345129335-23688-1-git-send-email-tklauser@distanz.ch>
In-Reply-To: <1345129335-23688-1-git-send-email-tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1772580.7GREs3Q9D2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201208161224.13162.vapier@gentoo.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart1772580.7GREs3Q9D2
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

On Thursday 16 August 2012 11:02:15 Tobias Klauser wrote:
> Follow bd2f5536 (sched/rt: Use schedule_preempt_disabled()).
>=20
> b5affb014 (blackfin: add bf60x to current framework) accidentally (?)
> reverted the change.

Acked-by: Mike Frysinger <vapier@gentoo.org>
=2Dmike

--nextPart1772580.7GREs3Q9D2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iQIcBAABAgAGBQJQLR6tAAoJEEFjO5/oN/WBIXUP/14XKorHWWTchwxljOzmokST
NcUdjxtJVvtHTzgIPybLk5yO2Rc/GJNflqJDzI79BAlsMUml14NtQrY0x/tT1q7Y
3eyHOYGaF207HP/fnRqTXkCTRSaTpfgKOiPVrx/H91RIWLx3Kv76ZCmUP20DUQTe
v/s9/3ECtC9WP336LSqtuvQ+FKiiARYFRhujTg8aBZ9RNgV0DaTRnzmsZjTIhf+a
N13Cp1wyfG7NqksmzcjRGkGOx22l89y+saFBWpoqhi8Lo+mP4NbXa+u6z7VcVqga
G1dxeCTbMq7kUcNOX8T/MOcBMmV2bYi1xId7phiUyOovZGz5Md10/KAM2XZblWUa
ns6nCmVVcYb6WDt07Ijclwyvjq4EXm4SvcY5Dt0NOwLTK+lP8y3HpN2gldDH69Kq
+AhVhjRAFLVmBcBDZxd5WHYNAr24S+bzTRKE6vAXYr9T72whZ4bknKcrSGKmZ9Il
4+N2AteueIlibDDYD796JX3WpzDNwiMloRb4LavTzGvgeHDozyojJgbxFq+vxT1S
41c4Lja9JhwJ7rUtOvFGbO2fXj8X1Tq3psiuIAVB5oX5PxQGmwp5fbyvUqfXoFZ0
hYBXW10DQTn5lXkjXZHuQehWU/7eH3MgLnW7WO/i0SVUXXcJiD0RimZdTHQFxhrx
ti+eQDUbjdb9s6mgdsA2
=7jxX
-----END PGP SIGNATURE-----

--nextPart1772580.7GREs3Q9D2--
