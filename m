Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752333Ab1CEOSS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Mar 2011 09:18:18 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:42780 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750982Ab1CEOSQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Mar 2011 09:18:16 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: linux-kernel@vger.kernel.org
Subject: Re: [regression] 2.6.38-post-rc7 with radeon kms: reproducably locks up hard when using desktop cube of kwin
Date: Sat, 5 Mar 2011 15:18:12 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc7-tp42-00142-g212e349; KDE/4.5.3; i686; ; )
Cc: DRI <dri-devel@lists.freedesktop.org>
References: <201103051510.35057.Martin@lichtvoll.de> (sfid-20110305_151616_695932_4AD33AC9)
In-Reply-To: <201103051510.35057.Martin@lichtvoll.de>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3421253.KEmaq4KIHf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201103051518.13025.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3421253.KEmaq4KIHf
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: quoted-printable

Am Saturday 05 March 2011 schrieb Martin Steigerwald:
> martin@shambhala:~> cat /proc/version
> Linux version 2.6.38-rc7-tp42-00142-g212e349 (martin@shambhala) (gcc
> version 4.4.5 (Debian 4.4.5-11) ) #4 PREEMPT Sat Mar 5 12:03:41 CET
> 2011

As it reads here, this is about 2.6.38, not 2.6.37. Changed subject.

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3421253.KEmaq4KIHf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iEYEABECAAYFAk1yRiQACgkQmRvqrKWZhMcrVgCgsHaNYC7XYCOdqaXXPQ29xeFl
EwwAn3xoRaByAC1SLbNsWrPYlRtH4HOL
=UErF
-----END PGP SIGNATURE-----

--nextPart3421253.KEmaq4KIHf--
