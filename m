Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753983Ab0IEM4d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Sep 2010 08:56:33 -0400
Received: from csamuel.org ([74.50.50.137]:45016 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753628Ab0IEM4b (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Sep 2010 08:56:31 -0400
From: Chris Samuel <chris@csamuel.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: [Btrfs-devel] [patch] O_DIRECT: fix the splitting up of contiguous I/O
Date: Sun, 5 Sep 2010 22:56:08 +1000
User-Agent: KMail/1.13.5 (Linux/2.6.32-24-generic; KDE/4.5.1; x86_64; ; )
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Moyer <jmoyer@redhat.com>,
        "btrfs-devel" <btrfs-devel@oss.oracle.com>,
        Andrew Morton <akpm@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>
References: <x49vd7f368c.fsf@segfault.boston.devel.redhat.com> <20100902142501.GA14932@infradead.org>
In-Reply-To: <20100902142501.GA14932@infradead.org>
X-Face: Wcb;^Ll1x`\6);#5&v=2":47)c~M=K)9_=0mp[Ob~p==:85h/k)fj6nBf@
 =?iso-8859-1?q?=5ESdaXtmdYGRq=0A=09=5B?=>N&^2m#i\v9ZHe:G-e=OR}-sEf`CdEL2/\).SeCBSC"Cn[(:./c*I|/3KCDO$<
 =?iso-8859-1?q?=7Bn8m=3BX=5F=0A=09g=5CY9LQ=3Dv/b5=60?=)L,WOQdI*?SqUCgiw/9`KxgdU5;z8L.3)
 =?iso-8859-1?q?F!1M3=3Dw=3Ai9MsWp=26v=3B=25usOXL=3Bw=0A=096kF=3FwAZjss=2E?=
 =?iso-8859-1?q?+y?=(78'qBu";bx]>"2dZd/S$^K)nU^N0HM\^^;s#q
MIME-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart3814862.Uf0HDgYkgA";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Message-Id: <201009052256.12386.chris@csamuel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--nextPart3814862.Uf0HDgYkgA
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Sep 2010 12:25:01 am Christoph Hellwig wrote:

> Andrew, can you please send this on to Linus and -stable ASAP?
> It's causing massive problems for our users.

Did this patch get dropped ?   I don't see it in Linus's git..

https://patchwork.kernel.org/patch/119333/

cheers,
Chris
=2D-=20
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC

This email may come with a PGP signature as a file. Do not panic.
=46or more info see: http://en.wikipedia.org/wiki/OpenPGP

--nextPart3814862.Uf0HDgYkgA
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEVAwUATIOTaY1yjaOTJg85AQIdWAf+PyOtvyZrLrZ2dWaI4/gRgKeadsxp6Mb6
Gc3wUhwUTeb/ZrVtrRQsAashDHYyLK/BNj5b+v36Z5vBMqqNps/0/+bqK+1uqpHz
rIdqJU5OdL16b8vKKu8MKhTsGzJckec7j302houg9s+xSRBVX8B+urP4ygcHHBhU
FonKoqMpwybtFeyJxRetOsOT3SC69LrqWP0zrd91XiwCuAoehHhn9aiyajveGn0I
mHg+hOx236Bkmw77vp7f+XFQwaoFuZMzxH+fuf0PzLwlmGYTINlBJy5RxCLY4QQt
mnoGj6G4Nc9wlcPwTMLRAtaHG0xD7jrYA0oXdtQnBV7z/0T8SpV3EA==
=sTOa
-----END PGP SIGNATURE-----

--nextPart3814862.Uf0HDgYkgA--
