Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab1H3B7h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 21:59:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:41768 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751775Ab1H3B7f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 21:59:35 -0400
Date: Tue, 30 Aug 2011 11:59:25 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Randy Dunlap <rdunlap@xenotime.net>
Cc: netdev <netdev@vger.kernel.org>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, davem@davemloft.net
Subject: Re: [PATCH -next] net: fix Makefile typos & build errors
Message-Id: <20110830115925.45984bb8eeb73401dd5d289f@canb.auug.org.au>
In-Reply-To: <20110829114940.4d29febc.rdunlap@xenotime.net>
References: <20110829161907.19232776e65389dea1caa7e8@canb.auug.org.au>
	<20110829114940.4d29febc.rdunlap@xenotime.net>
X-Mailer: Sylpheed 3.2.0beta2 (GTK+ 2.24.5; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Tue__30_Aug_2011_11_59_25_+1000_Nyg/YomqZxbT3nSF"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Tue__30_Aug_2011_11_59_25_+1000_Nyg/YomqZxbT3nSF
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Mon, 29 Aug 2011 11:49:40 -0700 Randy Dunlap <rdunlap@xenotime.net> wrot=
e:
>
> @@ -44,10 +44,10 @@ obj-$(CONFIG_PPP_SYNC_TTY) +=3D ppp/
>  obj-$(CONFIG_PPPOE) +=3D ppp/
>  obj-$(CONFIG_PPPOL2TP) +=3D ppp/
>  obj-$(CONFIG_PPTP) +=3D ppp/
> -onj-$(CONFIG_SLIP) +=3D slip/
> +obj-$(CONFIG_SLIP) +=3D slip/
>  obj-$(CONFIG_SLHC) +=3D slip/
>  obj-$(CONFIG_NET_SB1000) +=3D sb1000.o
> -onj-$(CONFIG_SLIP) +=3D slip/
> +obj-$(CONFIG_SLIP) +=3D slip/

It may be my old(er) eyes, but isn't that CONFIG_SLIP line repeated?

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Tue__30_Aug_2011_11_59_25_+1000_Nyg/YomqZxbT3nSF
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)

iQEcBAEBAgAGBQJOXEP9AAoJEDMEi1NhKgbsi0IH/ApkE+VVuc7zKPWNrotpX1ov
o91AJ24Vr/PTY+z475vKYlr5JpMIroUjnmd8rvnAI4d0upSSxp+ODXOpqQC+1UcX
uszINsYeIOt9mAAvaLKgkdHR24vDMdJNnhqWp0dWGejGxEtF19txcpeaeg6jGwFp
J43Kv/h7uKXbq0M4Nc6scDkGoz9EGm9NzWJj0+4/KtxxN7hIJEQfw0Xh5GcMWb1N
+SoGS+1pQOiiH7clUI+Nhv2uINMUyssI2KovHEnnjwiQ0mp6sYrhGhCW7aCQvtK4
OloLn7Co/VIdbXxRRSUJ/jc1BdcAKdF3b5XIVRz76U679PtBPUE+NKQRAYf8R7g=
=EKgZ
-----END PGP SIGNATURE-----

--Signature=_Tue__30_Aug_2011_11_59_25_+1000_Nyg/YomqZxbT3nSF--
