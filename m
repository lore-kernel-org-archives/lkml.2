Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751761Ab2HBMBS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 08:01:18 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:39556 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab2HBMBR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 08:01:17 -0400
Date: Thu, 2 Aug 2012 22:01:06 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Ben Dooks <ben-linux@fluff.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-next@vger.kernel.org
Subject: Re: linux-next: removal of some trees
Message-Id: <20120802220106.42bab0e216528eb2167ed43d@canb.auug.org.au>
In-Reply-To: <501A4978.3010409@gmail.com>
References: <20120802084154.875a13db0ec1ebd3f5a4dab3@canb.auug.org.au>
	<501A4978.3010409@gmail.com>
X-Mailer: Sylpheed 3.2.0 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Thu__2_Aug_2012_22_01_06_+1000_kd/zoAP7OZ6.NjH0"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Thu__2_Aug_2012_22_01_06_+1000_kd/zoAP7OZ6.NjH0
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, 02 Aug 2012 17:33:44 +0800 Cong Wang <xiyou.wangcong@gmail.com> wro=
te:
>
> By the way, please remove my kmap_atomic tree[1] as well, its mission is=
=20
> completed now. :)

Thanks for letting me know.  Gone, now.
--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

--Signature=_Thu__2_Aug_2012_22_01_06_+1000_kd/zoAP7OZ6.NjH0
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJQGmwCAAoJEECxmPOUX5FEEo8P/3do3qvP+wrC1qko4n7PyRGC
DmsMZC+synGPxGO77h3aFS85hKg0jnWlSftT0Bc1ygfCFH1DodSBK7HEv14TJ+DO
HegU/ANmYlWeZoa12T1FZI/tXmO+cVZIDg8UQvoB1IUS+9+6LvI8o2Pa0tZrp0S/
eDZp47Uh89eSP0dK9IOAJDFl6lxiS33sPHzZUSWRjn9YSaxxhmdV8Jq6El9tt3qd
4xdmcgW2EmdzPB9MADvVkIzbxRLQpU/0wA/8nluApyjtsn8IApOT45UMPLAHqcNZ
OvGUfjVig+r2QrXfWNVC0Inc5D6uR27i7tytGyrCJNivoCkYMRxE4TuRIVxYmVZ5
dNYGvwFJ0/b5Pv4d2quByXjfRD2HkJwOFvWGO8Kvt4QXwUkeRbUervNAv8nFxwvq
WOj+6tKIYiWJUxn9xs0/R5KodeS4fn4Br/y2cKoMZAOMcXnlLnDMrP7VY16PH4YI
r8V2+D4mQj9cKbiwP4aUv7SSvQwwxLvD8yESyXdAIG+nODCZbV6KspsMHMtY07ad
nyhoeRgN+c1D24J2JL78NTLei4cTYtqgFbsiYou0qsx7208VQFKEKp/85nCziz4K
5BakwGlkz4zWSzbtqKKWHbMYyHhv7uq31MddvnKyqwgH38IHVxzTL4cImSPakCFJ
r92oVR+4fu5mwzMcAHo5
=H8KQ
-----END PGP SIGNATURE-----

--Signature=_Thu__2_Aug_2012_22_01_06_+1000_kd/zoAP7OZ6.NjH0--
