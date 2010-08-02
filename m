Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752215Ab0HBAcO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 1 Aug 2010 20:32:14 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:43605 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752024Ab0HBAcN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 1 Aug 2010 20:32:13 -0400
Date: Mon, 2 Aug 2010 10:32:04 +1000
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Nick Piggin <npiggin@suse.de>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Al Viro <viro@ZenIV.linux.org.uk>
Subject: Re: Linux 2.6.35
Message-Id: <20100802103204.3d1b2863.sfr@canb.auug.org.au>
In-Reply-To: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
References: <AANLkTim8FALeVG+NPLNLEQChu=dPD=GHSpnxmZHYgsNx@mail.gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA1";
 boundary="Signature=_Mon__2_Aug_2010_10_32_04_+1000_INL9wNrNsTS_3uH5"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Mon__2_Aug_2010_10_32_04_+1000_INL9wNrNsTS_3uH5
Content-Type: text/plain; charset=US-ASCII
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi all,

On Sun, 1 Aug 2010 16:52:42 -0700 Linus Torvalds <torvalds@linux-foundation=
.org> wrote:
>
> On a slightly happier note: one thing I do hope we can merge in the
> upcoming merge window is Nick Piggin's cool VFS scalability series.
> I've been using it on my own machine, and gone through all the commits
> (not that I shouldn't go through some of them some more), and am
> personally really excited about it. It's seldom we see major
> performance improvements in core code that are quite that noticeable,
> and Nick's whole RCU pathname lookup in particular just tickles me
> pink.

To that end, Nick, can you please submit that tree for inclusion in
linux-next in case there are some interactions with some of the other
stuff there?  (or send it all to Al, instead (or both), I guess.)

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Mon__2_Aug_2010_10_32_04_+1000_INL9wNrNsTS_3uH5
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iQEcBAEBAgAGBQJMVhIEAAoJEDMEi1NhKgbsM5EH/R8JmoHSVBrxM1Te7hecKHbS
+pLb2Dzm4DcOVcNPyEjcRjI78SKeDZB0FJBwxpzI8uI/mf1NcKtCAuPb82jp9L6T
UvtgtmDYo74S6WpmkYlnKqKDvTve/Ri85oa6dCwlb8ql3BD511ECDUYHJk4XQ29D
ERMaCjasP/AAXWrN7y+dxiaf42d6hx+mk9ff9etGLLi5RaA7AQ+Azeq819jmFrlD
T6mhjHfSPQHgdNzqKeGVzZd2NnWPQlEBrelKfEOnbTk0i+GWxDTHU30EcT8K9hRa
gcjO3XHMHHqqdtVZuA38pWOZj4mVO0KcSu7gT8MtHW3idBUf2MvwHLDcmCzKz9Q=
=Qqwr
-----END PGP SIGNATURE-----

--Signature=_Mon__2_Aug_2010_10_32_04_+1000_INL9wNrNsTS_3uH5--
