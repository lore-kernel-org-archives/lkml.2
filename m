Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754663Ab2C3Gbj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Mar 2012 02:31:39 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:55026 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751001Ab2C3Gbe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Mar 2012 02:31:34 -0400
Date: Fri, 30 Mar 2012 17:31:16 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: David Miller <davem@davemloft.net>
Cc: dhowells@redhat.com, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org
Subject: Re: linux-next: build failure after merge of the final tree (Linus'
 tree related)
Message-Id: <20120330173116.ef39d9bdda2ad96ab7e57f16@canb.auug.org.au>
In-Reply-To: <20120330.014500.609615234139434409.davem@davemloft.net>
References: <20120330143156.6c55bd32d207a074f65d1b16@canb.auug.org.au>
	<20120329.233937.885408108371285308.davem@davemloft.net>
	<20120330.014500.609615234139434409.davem@davemloft.net>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__30_Mar_2012_17_31_16_+1100_hjVd/VvPRUWJRxl."
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__30_Mar_2012_17_31_16_+1100_hjVd/VvPRUWJRxl.
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi Dave,

On Fri, 30 Mar 2012 01:45:00 -0400 (EDT) David Miller <davem@davemloft.net>=
 wrote:
>
> From: David Miller <davem@davemloft.net>
> Date: Thu, 29 Mar 2012 23:39:37 -0400 (EDT)
>=20
> >> From: Stephen Rothwell <sfr@canb.auug.org.au>
> >> Date: Fri, 30 Mar 2012 14:26:24 +1100
> >> Subject: [PATCH] sparc: fix fallout from system.h split
> >>=20
> >> Fixes this build error:
> >>=20
> >> kernel/signal.c: In function 'ptrace_stop':
> >> kernel/signal.c:1860:3: error: implicit declaration of function 'synch=
ronize_user_stack' [-Werror=3Dimplicit-function-declaration]
> >>=20
> >> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
>=20
> Unfortunately there's more changes needed to fix the allmodconfig
> build on sparc64 completely, I'll push it all to Linus.

Thanks.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Fri__30_Mar_2012_17_31_16_+1100_hjVd/VvPRUWJRxl.
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPdVM0AAoJEECxmPOUX5FEUT4QAIDvqsvI3p1v/M4CrNAh0Ql3
5JQ7rOUzyScgxXiSykPg4Xv3x8or69eMnIfIJ6LYRS+8oBHHgnOPvJDXLL32ljv2
QGqVEcQNIkafB/VkKpQCdSbDkSSl7AMxh+a+WayM9T+kUovIN+P7eIcvnuluuax7
5BuHsTY+/eANyvC52SHT55HuC4/i6044n21t6LslqvT4UMo4L9yo02DxmvWEa2uO
2U48jg3weO6+vExEU/3KLCnvruKuIDtmVaE5OprCLqip2fQmy2nOpPye3hnTo/gr
oh5mzm5TLICqvVE+/5yWHEiShzylMDUeFZfYzo26U3nJmMhekZkErsYk4+gNU0tC
6ipRy6UDmrMyblibpkCu7aIBTdXG8NpFm4uHRc6RQ2JeagBDK6dDy77ITsVsHctL
s9Q19LTJQ95RDvlro4TnXfVTli0DJ+tKCW+WBJljFOhtK6FZ0zHQ82s5LYxzVBo1
9UGYfiVX4lp1jBLA5ivUgbBMMBblsYwPLiBoMY1fP7dOn/4ufON7rBTi9hGjNwVS
79eGy7ehWpKiVUa28GFZUlNRQjOkWjOauf/hP7FFJVxG3tLsyJZsT31Hgm0GlbYp
pv0FB+DzX64ezLas0cnVZYCXL3s1MsHomOizmbsUeH1KA71whRNN4AAtBGq6oxP+
YXM6KMD9IPCgsdIB2jNm
=Wxwv
-----END PGP SIGNATURE-----

--Signature=_Fri__30_Mar_2012_17_31_16_+1100_hjVd/VvPRUWJRxl.--
