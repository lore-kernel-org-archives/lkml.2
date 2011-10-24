Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756016Ab1JXVIq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 17:08:46 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:64957 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755988Ab1JXVIo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 17:08:44 -0400
Subject: Re: [BUG] Re: mtd_stresstest module bricked my dockstar
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Willy Tarreau <w@1wt.eu>
Cc: Roland Kletzing <devzero@web.de>, linux-kernel@vger.kernel.org,
        adrian.hunter@intel.com
Date: Tue, 25 Oct 2011 00:08:12 +0300
In-Reply-To: <20111024200927.GH5632@1wt.eu>
References: <69501156.1798237.1319395066798.JavaMail.fmail@mwmweb003>
	 <20111024055705.GA4020@1wt.eu>
	 <B10F15EA8AB74E698DC0D94563A30BE7@samsungnetbook>
	 <20111024200927.GH5632@1wt.eu>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-kURkV9AHC+fQCRja/AQ9"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Message-ID: <1319490518.12314.13.camel@golum>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-kURkV9AHC+fQCRja/AQ9
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2011-10-24 at 22:09 +0200, Willy Tarreau wrote:
> You're pretty right indeed ! I think the code has only be tested with
> devices that ought to be killed, otherwise the author would have
> noticed
> it quickly.=20

Yes, they were usually used to validate a new driver or a new platform
before, and no one noticed that default parameter value.

--=20
Best Regards,
Artem Bityutskiy

--=-kURkV9AHC+fQCRja/AQ9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAABAgAGBQJOpdO8AAoJEJtuLFy+q7fesV8H/R5PSaLSJgrMXP4vjDfZJDmd
T9vrzP6cttn40ED3kk2vS+Mvznf7wW54D2GKrAILXf2EV+rfEuAljqLvw17KHWPQ
pB1NicTTbWRRxxL3DxzVy08XeLE3ee5ubx+qNQcq8nx3636tS0VmFdB4Bkeu+TUA
TJmpCfRdlPTP4o38NuwfKDSK7M20Ta3+cTGLIz3hHFwMWSxjyr4/Nu5kyIi1S7Fi
kEXHJeCQNo8N4IEBaV0Yjdd+dsxMG0pYkngGJNAY87uCtPEfVHqPGldDgiUJKHhJ
3SEr2FqZRridC8s5/eC5p/yBEwqmhQ6ifzPx2vDgQgL+Y9sc2JgvvLXEhSRj3QI=
=sYnk
-----END PGP SIGNATURE-----

--=-kURkV9AHC+fQCRja/AQ9--

