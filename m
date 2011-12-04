Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755299Ab1LDTzE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Dec 2011 14:55:04 -0500
Received: from ist.fellig.org ([84.200.228.103]:46757 "EHLO v0.fellig.org"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754774Ab1LDTzB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Dec 2011 14:55:01 -0500
Subject: Re: [Linux-decnet-user] Proposed removal of DECnet support
	(was:Re: [BUG] 3.2-rc2:BUG kmalloc-8: Redzone overwritten)
From: Philipp Schafft <lion@lion.leolix.org>
To: mike.gair@tatasteel.com
Cc: Steven Whitehouse <swhiteho@redhat.com>,
        Chrissie Caulfield <ccaulfie@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Linux-DECnet user <linux-decnet-user@lists.sourceforge.net>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Matt Mackall <mpm@selenic.com>,
        netdev <netdev@vger.kernel.org>, Pekka Enberg <penberg@kernel.org>,
        RoarAudio <roaraudio@lists.keep-cool.org>
In-Reply-To: <OF6A1EB29A.D9A6FBAC-ON8025795A.00311C05-8025795A.0032A610@LocalDomain>
References: <OF6A1EB29A.D9A6FBAC-ON8025795A.00311C05-8025795A.0032A610@LocalDomain>
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-6gyiy/Yf0KLaz6yRmUEU"
Organization: PH2
Date: Sun, 04 Dec 2011 20:54:56 +0100
Mime-Version: 1.0
X-Mailer: Evolution 2.6.3 
Message-Id: <20111204195458.65F1C7AD9C@priderock.keep-cool.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--=-6gyiy/Yf0KLaz6yRmUEU
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

reflum,

On Fri, 2011-12-02 at 09:14 +0000, mike.gair@tatasteel.com wrote:
> I suspect I'm not up to the job,
>=20
> - definitely not got an in-depth knowledge of the core Linux
> networking stack
> or the DECnet specs,
> Have limited, but growing experience of C, (mainly work in coral66)

I'm willing to offer you help with C and the protocol stuff. I'm the
current most active developer of the userland part.


> But I'll have a look at code/documentation
> & see if I understand any of it.=20

Ok. If you are still interested let me know if I can help you with the
above. Maybe Steven can give you some pointers for the kernel stuff.

>=20
--=20
Philipp.
 (Rah of PH2)

--=-6gyiy/Yf0KLaz6yRmUEU
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Comment: Because it's your freedom

iQEVAwUATtvQD2CSpmW8W5B8AQKRWggAgW/ZdtN0m1kcTGTb9agioN8aBibc2xbi
5LOxT4IYWWoTWi+U1gEYu6a3eMCMGD3q78dEmLSXJUy0QLpU8dhfDSjGrBVDyfzF
AjFYBZyRxtOgcuESCltl4GFihCM/rJTuuyJ4rXVlAH4DWc7O7u3EvqdBgo3LS6cm
LA+8d/5UxQMeEQV6obqz7soCWg+B+sEekFkHOGxTqOOdKt30+8N2Cp/r8rm2wrPY
7Cl75M2YOtrXTTUU3BUas1tWuYIRanyI6UMZJUeQEfEvdMn7cI2pE/gAlyiN43Jv
XcCal2lbDw4P61rodIz6bJ1oun2zXnnTmNzlreouVh8ZOxX7lUaSLw==
=VQjb
-----END PGP SIGNATURE-----

--=-6gyiy/Yf0KLaz6yRmUEU--
