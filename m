Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab1EVW3f (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 May 2011 18:29:35 -0400
Received: from mail.sf-mail.de ([62.27.20.61]:38103 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755571Ab1EVW3e (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 May 2011 18:29:34 -0400
From: Rolf Eike Beer <eike-kernel@sf-tec.de>
To: Greg KH <greg@kroah.com>
Cc: Parisc List <linux-parisc@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, stable@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [stable] PA-RISC: compile error in include/net/dst.h
Date: Mon, 23 May 2011 00:29:26 +0200
Message-ID: <2254093.9oQvKLogfV@donald.sf-tec.de>
User-Agent: KMail/4.6 beta5 (Linux/2.6.37-12-desktop; KDE/4.6.3; i686; ; )
In-Reply-To: <20110522143222.GB14556@kroah.com>
References: <2612811.b2htuyZy9x@donald.sf-tec.de> <20110522143222.GB14556@kroah.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart1739995.G2MFWqQSJG"; micalg="pgp-sha1"; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7Bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--nextPart1739995.G2MFWqQSJG
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

Am Sonntag, 22. Mai 2011, 07:32:22 schrieb Greg KH:
> On Sun, May 22, 2011 at 10:15:19AM +0200, Rolf Eike Beer wrote:
> >                  from include/net/ipv6.h:16,
> >                  from include/linux/sunrpc/clnt.h:25,
> >                  from include/linux/nfs_fs.h:50,
> > 
> >                  from init/do_mounts.c:20:
> > include/net/dst.h: In function 'dst_hold':
> > include/net/dst.h:238:2: error: size of unnamed array is negative
> > In file included from include/linux/nfs_fs.h:59:0,
> > 
> >                  from init/do_mounts.c:20:
> > include/linux/mempool.h: In function 'mempool_create_kmalloc_pool':
> > include/linux/mempool.h:58:10: warning: cast to pointer from integer of
> > different size
> > 
> > This is both in 2.6.38.6 and 2.6.39, but is not in 2.6.38.4 when
> > compiling for my C8000.
> 
> Could you bisect it down to the patch that causes the problem in
> 2.6.38.6?

I will try if I find time in the next days. Until now I can only confirm that 
2.6.38.5 builds fine.

Eike	
--nextPart1739995.G2MFWqQSJG
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.15 (GNU/Linux)

iEYEABECAAYFAk3ZjkwACgkQXKSJPmm5/E4SegCgpCW43wAsqm8Yf1A3pOknddrb
1TgAoJIbSXrBWcDU5eSchkHEmZG6bqkt
=HtkC
-----END PGP SIGNATURE-----

--nextPart1739995.G2MFWqQSJG--

