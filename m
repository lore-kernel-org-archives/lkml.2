Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755305Ab1A1TS2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 14:18:28 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:46947 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab1A1TS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 14:18:27 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: xfs@oss.sgi.com
Subject: Re: xfs: very slow after mount, very slow at umount
Date: Fri, 28 Jan 2011 20:18:11 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-tp42-rtime-00004-g9eb63ce; KDE/4.5.3; i686; ; )
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Mark Lord <kernel@teksavvy.com>,
        Christoph Hellwig <hch@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Justin Piszcz <jpiszcz@lucidpixels.com>, Alex Elder <aelder@sgi.com>
References: <4D40C8D1.8090202@teksavvy.com> <4D419765.4070805@teksavvy.com> <4D41CA16.8070001@hardwarefreak.com> (sfid-20110127_220503_352851_8BD9DFC6)
In-Reply-To: <4D41CA16.8070001@hardwarefreak.com>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3926807.QEyy5ibxh2";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201101282018.12247.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3926807.QEyy5ibxh2
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Am Thursday 27 January 2011 schrieb Stan Hoeppner:
> Trust the defaults.  If they give you problems (unlikely) then we can't
> talk. ;)

With one addition: Use a recent xfsprogs! ;)

Earlier ones created more AGs, didn't activate lazy super block counter=20
(likely no issue here) and whatnot...

=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3926807.QEyy5ibxh2
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk1DFnQACgkQmRvqrKWZhMc2qwCgrnlXK8kUFcYrtLFEyX6XzsW3
tU0AoKhzXci4d/RObXp7lZnjWofQXv7y
=FYnv
-----END PGP SIGNATURE-----

--nextPart3926807.QEyy5ibxh2--
