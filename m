Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932178Ab2LMCYv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 21:24:51 -0500
Received: from haggis.pcug.org.au ([203.10.76.10]:44915 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab2LMCYr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 21:24:47 -0500
Date: Thu, 13 Dec 2012 13:24:38 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Casey Schaufler <casey@schaufler-ca.com>, linux-next@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: unusual update of the security tree
Message-Id: <20121213132438.7a70a114233057ce22982b7b@canb.auug.org.au>
In-Reply-To: <alpine.LRH.2.02.1212071020050.7590@tundra.namei.org>
References: <20121128101635.d5e864dffc4252ef9d5e1664@canb.auug.org.au>
	<50B5508D.7050409@schaufler-ca.com>
	<20121128110132.0082c87680b9b714b8c0689c@canb.auug.org.au>
	<alpine.LRH.2.02.1212070024460.4693@tundra.namei.org>
	<CA+55aFwJDtofV36R_ot8qj31BCGwBgDsGOKRkMRhRLamf5M+mw@mail.gmail.com>
	<alpine.LRH.2.02.1212071020050.7590@tundra.namei.org>
X-Mailer: Sylpheed 3.3.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__13_Dec_2012_13_24_38_+1100_tRUPIhmez8nqtt6C"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__13_Dec_2012_13_24_38_+1100_tRUPIhmez8nqtt6C
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi James,

On Fri, 7 Dec 2012 10:21:31 +1100 (EST) James Morris <jmorris@namei.org> wr=
ote:
>
> On Thu, 6 Dec 2012, Linus Torvalds wrote:
>=20
> > Have people pulled that thing into anything else? Because quite
> > frankly, I think it's unsalvageable except with a rebase.
>=20
> AFAIK, only developers such as Casey will have pulled it for development=
=20
> purposes.
>=20
> And sorry, I should be checking the trees I pull from more carefully.

Are you going to fix this before asking Linus to pull?
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__13_Dec_2012_13_24_38_+1100_tRUPIhmez8nqtt6C
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQyTxmAAoJEECxmPOUX5FEF5UP/jwZRIVZPRXrxnVqvDTC3neM
O+uxpXn6C/GUDmnNg9w1B94yQ3VEK5l6ELgeWipNNviXB8Xxp21IpG3S+8YIozqT
419wZ0WLn9UI/aI8Dyg+KsQzGlDAoSf8Nv1R41brIT0j/nhnKTRR8dH6Qd1qShPG
ARTo9cEKXnpHLf1TpAWsVlyUc5iFmgTaUpzgAtlK+TnbpQv43DOB8E8IpOUJjPoQ
UkbBg3bZaTEDw/d7Xn/Mt8ODIuAnZ0G+VKfPzZkAzCn6v2b3L6sDA9rEfPLfctVo
s0W7xgKNLAKaJYtlnFZwO5fZHGFH7QauD1PY5qXAYeQLWBzGdWtKIOcmG66pwjCR
mLvcdZv3JkK/RpjiFO0g79L86JbvJaP092g66tCvoz0SnM88npwi1Bjd4cgCSqGE
AgHBG+oPYmwipvmwGcjbfKaO0YGMO45Yl91T5xJgYUrpZOs2ausULfAvXUxs2qZv
UmHw8Wit0ZL+J6z1e5KiQxqXWw7pW+N3nr7dpzBhtmPqwMwFnQMBXclzJ/N+s9pz
EvmWQ3q8dDsoVjKvo4roG0hVpaWMtgl2AZ+KWM+k9PSbgzsiie6HqQa47sjw2w3H
hX5gUAtoKCnqNZlBAyDB/W/N3yhgWnRszRPbnMBN9VpdfBSNZeVuJ9p/O+QODc38
v6i6Qm5jkz+1S5MjVlGP
=K8P0
-----END PGP SIGNATURE-----

--Signature=_Thu__13_Dec_2012_13_24_38_+1100_tRUPIhmez8nqtt6C--
