Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756838Ab0LRBAO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 20:00:14 -0500
Received: from gate.lvk.cs.msu.su ([158.250.17.1]:51382 "EHLO
	mail.lvk.cs.msu.su" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756381Ab0LRBAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 20:00:11 -0500
X-Spam-ASN: 
Date: Sat, 18 Dec 2010 04:00:01 +0300
From: Alexander Gordeev <lasaine@lvk.cs.msu.su>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "Nikita V\. Youshchenko" <yoush@cs.msu.su>,
        linuxpps@ml.enneenne.com, Rodolfo Giometti <giometti@enneenne.com>
Subject: Re: [PATCHv6 00/16] pps: several fixes and improvements
Message-ID: <20101218040001.7b4a1bc0@apollo.gnet>
In-Reply-To: <20101217161938.9247e433.akpm@linux-foundation.org>
References: <cover.1292604060.git.lasaine@lvk.cs.msu.su>
	<20101217161938.9247e433.akpm@linux-foundation.org>
Organization: LVK
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA256;
 boundary="Sig_/XaqTwwJfnMAw4c9sh/hVt3l"; protocol="application/pgp-signature"
X-AV-Checked: ClamAV using ClamSMTP
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/XaqTwwJfnMAw4c9sh/hVt3l
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

=D0=92 Fri, 17 Dec 2010 16:19:38 -0800
Andrew Morton <akpm@linux-foundation.org> =D0=BF=D0=B8=D1=88=D0=B5=D1=82:

> On Fri, 17 Dec 2010 22:54:24 +0300
> Alexander Gordeev <lasaine@lvk.cs.msu.su> wrote:
>=20
> > There is one problem however: kernel consumer works bad (if enabled)
> > when CONFIG_NO_HZ is enabled. The reason for this is commit
> > a092ff0f90cae22b2ac8028ecd2c6f6c1a9e4601. Without it hardpps() is able
> > to sync to 1us precision in about 10 seconds. With CONFIG_NO_HZ it is
> > not syncing at all. This only affects patches 12-14, others are ok.
>=20
> Is someone working on fixing all this?

Not right now but it is planned. I can only ensure that users can never
select CONFIG_NO_HZ and CONFIG_NTP_PPS at the same time. Is it ok?

--=20
  Alexander

--Sig_/XaqTwwJfnMAw4c9sh/hVt3l
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBCAAGBQJNDAeRAAoJEElrwznyooJbBggIAJLNp6QCcdvQSICHk0lN7AC8
A0XijdFcRKI8X7+iZz4r4VheK8tx0CkS9d7nUNE/AkwNoo2pr5KSHhaVPtWzrAZ2
n0Gy7Bf1rh06C/E3LSn2xY2JU2e6FUjtxO3fEUVQRgEXFpN4WLPELsjfYnA2WuPZ
b8D5PvCTspewbo+ws7Y7/QggpAhRi63ZckDVY9W6++QDJtxI+pGxBogxZ6f8nszd
UuCLHo5/xZeb0rNJOZu0ke2Q1XnWg7NQVeiXNMhOwiTM31vWU6t99d0KsBM4+Tqh
pgPlwEBxiWeP9INvLs55D6loBD+KHtFwN0DeuQ14l299mCFaFdIW88NW+SgmD1E=
=xHQR
-----END PGP SIGNATURE-----

--Sig_/XaqTwwJfnMAw4c9sh/hVt3l--
