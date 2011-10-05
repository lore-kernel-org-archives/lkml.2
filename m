Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935506Ab1JEW4h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 18:56:37 -0400
Received: from calzone.tip.net.au ([203.10.76.15]:35895 "EHLO
	calzone.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934900Ab1JEW4f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 18:56:35 -0400
Date: Thu, 6 Oct 2011 09:56:25 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Russell King <rmk@arm.linux.org.uk>
Subject: Re: Changed location for arm-lpae/for-next
Message-Id: <20111006095625.c4814b818efdc61842451625@canb.auug.org.au>
In-Reply-To: <CAHkRjk7YBJJO9HW3JC0AUT2-JTyMwj=4=zd==dSG=pfBvCiFNg@mail.gmail.com>
References: <20111004132614.GA13865@e102109-lin.cambridge.arm.com>
	<20111005120621.46c24fe4b8f83ac78944b777@canb.auug.org.au>
	<CAHkRjk7YBJJO9HW3JC0AUT2-JTyMwj=4=zd==dSG=pfBvCiFNg@mail.gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__6_Oct_2011_09_56_25_+1100_gX7i+C4e=nQ9CiH3"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__6_Oct_2011_09_56_25_+1100_gX7i+C4e=nQ9CiH3
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Catlain,

On Wed, 5 Oct 2011 18:04:56 +0100 Catalin Marinas <catalin.marinas@arm.com>=
 wrote:
>
> Ah, sorry about that, some IT issues again (looks fine internally). If
> you don't mind to change them again, I created two branches on github,
> the first one for LPAE and the other for kmemleak:
>=20
> git://github.com/cmarinas/linux.git for-next

I have switched to that from today.

> git://github.com/cmarinas/linux.git kmemleak

And added that from today as well.

Thanks for adding your subsystem tree as a participant of linux-next.  As
you may know, this is not a judgment of your code.  The purpose of
linux-next is for integration testing and to lower the impact of
conflicts between subsystems in the next merge window.=20

You will need to ensure that the patches/commits in your tree/series have
been:
     * submitted under GPL v2 (or later) and include the Contributor's
	Signed-off-by,
     * posted to the relevant mailing list,
     * reviewed by you (or another maintainer of your subsystem tree),
     * successfully unit tested, and=20
     * destined for the current or next Linux merge window.

Basically, this should be just what you would send to Linus (or ask him
to fetch).  It is allowed to be rebased if you deem it necessary.

--=20
Cheers,
Stephen Rothwell=20
sfr@canb.auug.org.au

Legal Stuff:
By participating in linux-next, your subsystem tree contributions are
public and will be included in the linux-next trees.  You may be sent
e-mail messages indicating errors or other issues when the
patches/commits from your subsystem tree are merged and tested in
linux-next.  These messages may also be cross-posted to the linux-next
mailing list, the linux-kernel mailing list, etc.  The linux-next tree
project and IBM (my employer) make no warranties regarding the linux-next
project, the testing procedures, the results, the e-mails, etc.  If you
don't agree to these ground rules, let me know and I'll remove your tree
from participation in linux-next.

--Signature=_Thu__6_Oct_2011_09_56_25_+1100_gX7i+C4e=nQ9CiH3
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQIcBAEBCAAGBQJOjOCZAAoJEECxmPOUX5FE1/AP/2ZUnHKC8mgUxd46K3RubkzK
fjodizcnjHhgX1H4JLnRmGJWrNba2c6kV4le+aXpgVhV1lvPZC5DvuxjwhTv2mUK
XYmMQUJpvrzjqM28k7IY2Zpl9F+ENfoIHf0z0iG7BtIzP05eJThqFxvuaElqm3Q9
YK8IhTyVHBqL2PoZ+L3To70zZUPp02T2oNqJJ/F+Bs7rVmSHrsIeSww5feXJ2x0M
ytVKio3tSAAW1l4nOmXpiE5zzJgDN6hpsNaJ46ozcI/yGk4R6/O5gjvmzfKPE6mo
WVCDJvWqNX25UcoIp6+7PaPV5vu1uVhrU8ihJhNHwNmCZxmWVaRs4YyH5a8a3xg3
g6+iM6Umy49wUTajkGYVDaZsALH5LAy8pLV6kDJghwMMSYnpRCNs6kDBzglIBLT7
LyNX/S3stIGmJ45Vpsv+ivycP7FqcbzEDjSL+2u638U0TPg3eUwyfluqAiQZcP5U
Ur3RJK7xcx+XN9kAN8m3tzUAoq9XPerF5sqFLqyRFFw/0hnaxFpkBQ0wPVrFQd5o
aFcwuKTqpuW4pRsn2VuFxQKg8gLN8WgqTqlDTJngxxmZM3IM5BucK65b197R+Slp
JmbjpxbBETytyGDOKRzTP+VJcMFyJzeg5cxzdsWZShAZCYasTlY5WelkFVk/kybS
/mqZa7dp5iwgR8mgcE34
=trlj
-----END PGP SIGNATURE-----

--Signature=_Thu__6_Oct_2011_09_56_25_+1100_gX7i+C4e=nQ9CiH3--
