Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab1BMPVt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Feb 2011 10:21:49 -0500
Received: from mondschein.lichtvoll.de ([194.150.191.11]:34755 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750907Ab1BMPVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Feb 2011 10:21:42 -0500
From: Martin Steigerwald <Martin@lichtvoll.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #27842] [regression?] hang with 2.6.37 on a BTRFS test machine
Date: Sun, 13 Feb 2011 16:21:25 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37-tp42-rtime-00004-g9eb63ce; KDE/4.5.3; i686; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <9Pzlq5PlEtH.A.DU.efxVNB@chimera> <1z1FRILH7uF.A.N2.-fxVNB@chimera> (sfid-20110213_161838_638798_F8FAD00E)
In-Reply-To: <1z1FRILH7uF.A.N2.-fxVNB@chimera>
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3280872.JHrJ3yes0b";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201102131621.39691.Martin@lichtvoll.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3280872.JHrJ3yes0b
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: quoted-printable

Am Sunday 13 February 2011 schrieb Rafael J. Wysocki:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.36 and 2.6.37.
>=20
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).
>=20
>=20
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=3D27842
> Subject		: [regression?] hang with 2.6.37 on a BTRFS test machine
> Submitter	: Martin Steigerwald <Martin@lichtvoll.de>
> Date		: 2011-01-23 12:06 (21 days old)
> Message-ID	: <<201101231306.23069.Martin@lichtvoll.de>>
> References	: http://marc.info/?l=3Dlinux-kernel&m=3D129578445613283&w=3D2

Please still list it.

I intend to test this against 2.6.38-rc5 once it is out. It didn't happen=20
with 2.6.36 which I used for several weeks now, so its pretty safe to say=20
that its a regression of 2.6.37.

Thanks,
=2D-=20
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7

--nextPart3280872.JHrJ3yes0b
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEABECAAYFAk1X9vUACgkQmRvqrKWZhMdBPgCfTeyL4hm972cX4XsJ3/a0DjIN
Mp0Amwf47h/xC5jVVkCvzHs7MQjVeToF
=795I
-----END PGP SIGNATURE-----

--nextPart3280872.JHrJ3yes0b--
