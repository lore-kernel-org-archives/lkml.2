Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756008Ab2BFWsF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 17:48:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:47632 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754709Ab2BFWsD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 17:48:03 -0500
Date: Tue, 7 Feb 2012 09:47:51 +1100
From: NeilBrown <neilb@suse.de>
To: Pawel Sikora <pawel.sikora@agmk.net>
Cc: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        arekm@pld-linux.org
Subject: Re: [3.2.2] tasks blocked during matrix auto checking.
Message-ID: <20120207094751.51e5321a@notabene.brown>
In-Reply-To: <2156863.jdbU24e2Kr@pawels>
References: <2156863.jdbU24e2Kr@pawels>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/H6.ZcU.j9_OV=zNfrIcihQu"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/H6.ZcU.j9_OV=zNfrIcihQu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 06 Feb 2012 13:02 +0100 Pawel Sikora <pawel.sikora@agmk.net> wrote:

> Hi,
>=20
> on heavy loaded opterons i've noticed some blocked tasks during matrix au=
to checking.
> is it a known issue?

No.... maybe not too surprising though.
The data-check will pause to let other IO through, but if there is lots of =
IO
queued up it could cause some longish delays...

2 minutes does seem a bit long though, so maybe there is a bug somewhere.=20

And had 3 consecutive timeouts, so that makes it 6 minutes which really is
too long.

What sort of array was this?  RAID1? RAID5 ??

Thanks,
NeilBrown



>=20
> (...)
> [401836.109354] md: data-check of RAID array md0
> [401836.109364] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [401836.109368] md: using maximum available idle IO bandwidth (but not mo=
re than 200000 KB/sec) for data-check.
> [401836.109388] md: using 128k window, over a total of 8000256k.
> [401836.111441] md: delaying data-check of md2 until md0 has finished (th=
ey share one or more physical units)
> [401914.274728] md: md0: data-check done.
> [401914.293562] md: data-check of RAID array md2
> [401914.293566] md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
> [401914.293569] md: using maximum available idle IO bandwidth (but not mo=
re than 200000 KB/sec) for data-check.
> [401914.293589] md: using 128k window, over a total of 849514496k.
> [402723.026480] INFO: task kjournald:1546 blocked for more than 120 secon=
ds.
> [402723.026484] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disabl=
es this message.

--Sig_/H6.ZcU.j9_OV=zNfrIcihQu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzBYlznsnt1WYoG5AQL32A/+JHV46P+j8zE5Qd6IRhqHDaLmSecYvs7g
CqH+6lu67oFhzzytCt+JO8/w8wmseXzoZxJb8bxEGdarH0VKcdehILyI4WFJUSr6
IgC1noC2iagrf9IwkZW5llvFzOUpqk7V6DnG0RBWSqqTMs8RLCaojzjvKWNY0kkY
j2hk7BvzS8cht/3axcBKg9psQqrb3xph4umoFl/GrOg/mL5zlYK3RmQ4OnmOrFZ7
Lr8kWClJfTiOXL/sFb7Ybn1eJYCT5xab/HR6Jnb0YjTMx6Sn1hb2QLMalr2Dc7u+
M6ALgVaehBdpB3jsHWRe3nskWpMZ+ikLZYqICO+OvewmhrBDigBGXc95qXHlX+UD
h8fydW/JA9ubjh0aHxLP5b/KVt/XR85z8lhABuKfJ2p2Dh+3Sr/r6gW36Bt1Ni30
jUe5EJ59QdL9paMW15oNzCabpQenLodgXOs/jHKS+DMKNx08lA7YhCy+1YMrTK6l
IJuy/r1Pzl8H+rVeTuKIlwL2d3FSYk0GJHYTWqnVWQIKSuVwH4vM6t1o7U/h9m/w
vQhZ5YpgEcO+CvUtL/okZsn18rQYhebp7ITcekD80K7R30fhi8f0dDxam4OsvrbI
Oy5thylUKGUqsnyFgDmE9Y4ZKll2vvsZzpSlBoB9tR1zB2FlS0DK2pWy3pEsCb75
17OwP+09SR8=
=rs19
-----END PGP SIGNATURE-----

--Sig_/H6.ZcU.j9_OV=zNfrIcihQu--
